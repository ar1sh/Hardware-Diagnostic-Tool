//
//  SingleResultViewController.m
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SingleResultViewController.h"

@implementation SingleResultViewController
@synthesize rv;
@synthesize myArray;
@synthesize isManagedObjectProvided, managedObject;
@synthesize pop;
@synthesize needHistory;

- (NSManagedObjectContext *)context
{
    NSManagedObjectContext *context = nil;
    id appDelegate = [UIApplication sharedApplication].delegate;
    if ([appDelegate respondsToSelector:@selector(managedObjectContext)])
    {
        context = [appDelegate managedObjectContext];
    }
    return context;
}

- (UIFont *)fontForView:(ResultView *)sender
{
    return [UIFont fontWithName:@"arial" size:10];
}

- (NSArray *)resultArrayForView:(ResultView *)sender
{
    if (isManagedObjectProvided) {
        myArray = [NSArray arrayWithObjects:@"Start", [managedObject valueForKey:@"Black"], [managedObject valueForKey:@"White"], [managedObject valueForKey:@"Red"], [managedObject valueForKey:@"Blue"], [managedObject valueForKey:@"Green"], nil]; 
    } 
    return myArray;
}

- (void)setup
{
    if (needHistory)
    {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"History" style:UIBarButtonItemStyleBordered target:self action:@selector(showHistory)];
    }
    [self.navigationItem.leftBarButtonItem setAction:@selector(doNothing)];
    
    self.contentSizeForViewInPopover = CGSizeMake(480, 640);
}

- (void)doNothing
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isManagedObjectProvided = NO;
        self.needHistory = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)showHistory
{
    rvc = [[ResultViewController alloc] initInManagedObjectContext:[self context]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UINavigationController *navPop = [[UINavigationController alloc] init];
        [navPop pushViewController:rvc animated:NO];
        if (!pop) {
            pop = [[UIPopoverController alloc] initWithContentViewController:navPop];
        }
        [self.pop presentPopoverFromBarButtonItem: self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } 
    else
    {
        [self.navigationController pushViewController:rvc animated:YES];
    } 
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    rv.delegate = self;
    [self setup];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.pop = nil;
    self.managedObject = nil;
    self.myArray = nil;
    self.rv = nil;
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
