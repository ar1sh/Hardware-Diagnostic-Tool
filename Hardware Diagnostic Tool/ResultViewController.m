//
//  ResultViewController.m
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultViewController.h"
#import "PixelCheckHistory.h"
#import "SingleResultViewController.h"

@interface ResultViewController()
@property (unsafe_unretained, readonly) NSArray *myArray;
@property (strong) NSArray *fullArray;
@property (strong) PixelCheckHistory *pch;
@end


@implementation ResultViewController
@synthesize pch;
@synthesize myArray, fullArray;




- initInManagedObjectContext:(NSManagedObjectContext *)context
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"PixelCheckHistory" inManagedObjectContext:context];
        request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"Date" ascending:YES], nil];
        request.predicate = nil;
        request.fetchBatchSize = 20;
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:@"myPhotogChach"];
        self.fetchedResultsController = frc;
        self.title = @"Date";
    }
    return self;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
    SingleResultViewController *srvc = [[SingleResultViewController alloc] init];
    [srvc setManagedObject:managedObject];
    [srvc setIsManagedObjectProvided:YES];
    [srvc setNeedHistory:NO];
    [self.navigationController pushViewController:srvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (!rv) {
        rv = [[ResultView alloc] init];
    }
    
    self.contentSizeForViewInPopover = CGSizeMake(480, 640);

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
