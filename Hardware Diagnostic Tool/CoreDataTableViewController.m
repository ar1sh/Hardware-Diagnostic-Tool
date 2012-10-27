//
//  CoreDataTableViewController.m
//
//  Created for Stanford CS193p Spring 2010
//

#import "CoreDataTableViewController.h"

@implementation CoreDataTableViewController

@synthesize fetchedResultsController;
@synthesize titleKey, subtitleKey, searchKey;

- (void)createSearchBar
{
	if (self.searchKey.length) {
		if (self.tableView && !self.tableView.tableHeaderView) {
			UISearchBar *searchBar = [[UISearchBar alloc] init];
			//[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
			self.searchDisplayController.searchResultsDelegate = self;
			self.searchDisplayController.searchResultsDataSource = self;
			self.searchDisplayController.delegate = self;
			searchBar.frame = CGRectMake(0, 0, 0, 38);
			self.tableView.tableHeaderView = searchBar;
		}
	} else {
		self.tableView.tableHeaderView = nil;
	}
}

- (void)setSearchKey:(NSString *)aKey
{
	searchKey = [aKey copy];
	[self createSearchBar];
}

- (NSString *)searchKey
{
    return searchKey;
}

- (NSString *)titleKey
{
	if (!titleKey) {
		NSArray *sortDescriptors = [self.fetchedResultsController.fetchRequest sortDescriptors];
		if (sortDescriptors.count) {
			return [[sortDescriptors objectAtIndex:0] key];
		} else {
			return nil;
		}
	} else {
		return titleKey;
	}
}

- (void)setTitleKey:(NSString *)aTitleKey
{
    titleKey = aTitleKey;
}

- (void)performFetchForTableView:(UITableView *)tableView
{
	NSError *error = nil;
	[self.fetchedResultsController performFetch:&error];
	if (error) {
		NSLog(@"[CoreDataTableViewController performFetchForTableView:] %@ (%@)", [error localizedDescription], [error localizedFailureReason]);
	}
	[tableView reloadData];
}

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
{
	if (tableView == self.tableView) {
		if (self.fetchedResultsController.fetchRequest.predicate != normalPredicate) {
			[NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
			self.fetchedResultsController.fetchRequest.predicate = normalPredicate;
			[self performFetchForTableView:tableView];
		}
		currentSearchText = nil;
	} else if ((tableView == self.searchDisplayController.searchResultsTableView) && self.searchKey && ![currentSearchText isEqual:self.searchDisplayController.searchBar.text]) {
		currentSearchText = [self.searchDisplayController.searchBar.text copy];
		NSString *searchPredicateFormat = [NSString stringWithFormat:@"%@ contains[c] %@", self.searchKey, @"%@"];
		NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:searchPredicateFormat, self.searchDisplayController.searchBar.text];
		[NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
		self.fetchedResultsController.fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:searchPredicate, normalPredicate , nil]];
		[self performFetchForTableView:tableView];
	}
	return self.fetchedResultsController;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	// reset the fetch controller for the main (non-searching) table view
	[self fetchedResultsControllerForTableView:self.tableView];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)controller
{
	fetchedResultsController.delegate = nil;
	fetchedResultsController = controller;
	controller.delegate = self;
	normalPredicate = self.fetchedResultsController.fetchRequest.predicate;
	if (!self.title) self.title = controller.fetchRequest.entity.name;
	if (self.view.window) [self performFetchForTableView:self.tableView];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    return fetchedResultsController;
}

- (UITableViewCellAccessoryType)accessoryTypeForManagedObject:(NSManagedObject *)managedObject
{
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (UIImage *)thumbnailImageForManagedObject:(NSManagedObject *)managedObject
{
	return nil;
}

- (void)configureCell:(UITableViewCell *)cell forManagedObject:(NSManagedObject *)managedObject
{
}

- (NSString *)stringForNumber:(NSNumber *)number;
{
    if ([number doubleValue] == 0) {
        return @"N/P";
    } else {
      return @"P";  
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForManagedObject:(NSManagedObject *)managedObject
{
    static NSString *ReuseIdentifier = @"CoreDataTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (cell == nil) {
		UITableViewCellStyle cellStyle = UITableViewCellStyleSubtitle;
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:ReuseIdentifier];
    }
	
    
	if (self.titleKey) cell.textLabel.text = [NSString stringWithFormat:@"%@", [managedObject valueForKey:self.titleKey]];
    NSString *subtitle = @"Black: ";
    subtitle = [subtitle stringByAppendingString:[self stringForNumber:[managedObject valueForKey:@"Black"]]];
    subtitle = [subtitle stringByAppendingString:@" White: "];
    subtitle = [subtitle stringByAppendingString:[self stringForNumber:[managedObject valueForKey:@"White"]]];
    subtitle = [subtitle stringByAppendingString:@" Red: "];
    subtitle = [subtitle stringByAppendingString:[self stringForNumber:[managedObject valueForKey:@"Red"]]];
    subtitle = [subtitle stringByAppendingString:@" Green: "];
    subtitle = [subtitle stringByAppendingString:[self stringForNumber:[managedObject valueForKey:@"Green"]]];
    subtitle = [subtitle stringByAppendingString:@" Blue: "];
    subtitle = [subtitle stringByAppendingString:[self stringForNumber:[managedObject valueForKey:@"Blue"]]];

	cell.detailTextLabel.text = subtitle;
	cell.accessoryType = [self accessoryTypeForManagedObject:managedObject];
	UIImage *thumbnail = [self thumbnailImageForManagedObject:managedObject];
	if (thumbnail) cell.imageView.image = thumbnail;
	
	return cell;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
    
}

- (void)deleteManagedObject:(NSManagedObject *)managedObject
{
}

- (BOOL)canDeleteManagedObject:(NSManagedObject *)managedObject
{
	return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSManagedObject *managedObject = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
	return [self canDeleteManagedObject:managedObject];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSManagedObject *managedObject = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
	[self deleteManagedObject:managedObject];
}

#pragma mark UIViewController methods

- (void)viewDidLoad
{
	[self createSearchBar];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self performFetchForTableView:self.tableView];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[self fetchedResultsControllerForTableView:tableView] sections] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return [[self fetchedResultsControllerForTableView:tableView] sectionIndexTitles];
}

#pragma mark UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[self fetchedResultsControllerForTableView:tableView] sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
	return [self tableView:tableView cellForManagedObject:[[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self managedObjectSelected:[[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[[[self fetchedResultsControllerForTableView:tableView] sections] objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [[self fetchedResultsControllerForTableView:tableView] sectionForSectionIndexTitle:title atIndex:index];
}

#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{	
    switch(type)
	{
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{	
    UITableView *tableView = self.tableView;
	
    switch(type)
	{
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
			[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark dealloc

- (void)dealloc
{
	fetchedResultsController.delegate = nil;
}

@end

