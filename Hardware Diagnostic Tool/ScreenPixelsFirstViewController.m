//
//  ScreenPixelsFirstViewController.m
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScreenPixelsFirstViewController.h"
#import "PixelCheckHistory.h"
#import "SingleResultViewController.h"
#import "HDTAppDelegate.h"

@interface ScreenPixelsFirstViewController()

@property (strong) ADBannerView *bannerView;

- (void)layoutForCurrentOrientation:(BOOL)animated;

@end

@implementation ScreenPixelsFirstViewController
@synthesize pop, bannerView;

- (void)layoutForCurrentOrientation:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    CGRect bannerFrame = self.bannerView.frame;
    if (self.bannerView.bannerLoaded) {
        bannerFrame.origin.y = 0;
    } else {
        bannerFrame.origin.y = [[UIScreen mainScreen] bounds].size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        self.bannerView.frame = bannerFrame;
    }];
}

- (void)showBannerView:(ADBannerView *)banner
{
    self.bannerView = banner;
    [self.view addSubview:banner];
    [self layoutForCurrentOrientation:YES];
}

- (void)hideBannerView:(ADBannerView *)banner
{
    self.bannerView = nil;
    [self layoutForCurrentOrientation:YES];
}

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

- (IBAction)beginTest:(UIButton *)sender
{
    pixelView = [[ScreenPixelsViewController alloc] init];
    pixelView.delegate = self;
    pixelView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:pixelView animated:YES];
}

- (void)screenPixelsViewController:(ScreenPixelsViewController *)sender didFinishTestingWithReturnArray:(NSArray *)array
{
    [PixelCheckHistory pixelHistoryWithArray:array inContext:[self context]];
    [(HDTAppDelegate *)[UIApplication sharedApplication].delegate saveContext];
    
    [self dismissModalViewControllerAnimated:YES];
    
    SingleResultViewController *srvc = [[SingleResultViewController alloc] init];
    srvc.needHistory = YES;
    [srvc setMyArray:array];
    [self.navigationController pushViewController:srvc animated:YES];
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

- (void)setup
{
    self.title = @"Pixels";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
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
	
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"History" style:UIBarButtonItemStyleBordered target:self action:@selector(showHistory)];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    pixelView = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
