//
//  LocationMapViewController.m
//  LocationTest
//
//  Created by Aryan Sharifian on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationMapViewController.h"

@interface LocationMapViewController()

@property (strong) ADBannerView *bannerView;

- (void)layoutForCurrentOrientation:(BOOL)animated;

@end

@implementation LocationMapViewController
@synthesize mapView;
@synthesize bannerView;

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
    [banner removeFromSuperview];
    self.bannerView = nil;
    [self layoutForCurrentOrientation:YES];
}

- (CLLocation *)coordinates:(LocationDetailsViewController *)ldvc
{
    return self.mapView.userLocation.location;
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[@"Unfortunately your location could not be found,\n" stringByAppendingString:error.localizedDescription] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    state = @"failed";
    [alert show];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (![state isEqualToString:@"failed"])
    {
        NSString *locate = [NSString stringWithFormat:@"%f, %f", self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude];
        self.mapView.userLocation.subtitle = locate;
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Details" style:UIBarButtonItemStyleBordered target:self action:@selector(toggle)];
    }
}

- (void)toggle
{
    LocationDetailsViewController *detailView = [[LocationDetailsViewController alloc] init];
    detailView.delegate = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        //detailView.contentSizeForViewInPopover = CGSizeMake(480, 640);
        if (!pop) {
            pop = [[UIPopoverController alloc] initWithContentViewController:detailView];
        }
        pop.popoverContentSize = CGSizeMake(400, 640);
        [pop presentPopoverFromBarButtonItem: self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:detailView animated:YES];
    }
}

static NSArray *mapTypeArray;

- (void)mapTypeChanged:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == [mapTypeArray indexOfObject:@"Standard"]) {
        self.mapView.mapType = MKMapTypeStandard;
    } else if (segment.selectedSegmentIndex == [mapTypeArray indexOfObject:@"Satellite"]) {
        self.mapView.mapType = MKMapTypeSatellite;
    } else if (segment.selectedSegmentIndex == [mapTypeArray indexOfObject:@"Hybrid"]) {
        self.mapView.mapType = MKMapTypeHybrid;
    } 
}

- (UISegmentedControl *)segmentController
{
    if (!mapTypeArray) mapTypeArray = [NSArray arrayWithObjects:@"Standard", @"Satellite", @"Hybrid", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:mapTypeArray];
    segment.segmentedControlStyle = UISegmentedControlStyleBar;
    [segment addTarget:self action:@selector(mapTypeChanged:) forControlEvents:UIControlEventValueChanged];
    switch (self.mapView.mapType) {
        case MKMapTypeStandard:
            segment.selectedSegmentIndex = [mapTypeArray indexOfObject:@"Standard"];
            break;
        case MKMapTypeSatellite:
            segment.selectedSegmentIndex = [mapTypeArray indexOfObject:@"Satellite"];
            break;
        case MKMapTypeHybrid:
            segment.selectedSegmentIndex = [mapTypeArray indexOfObject:@"Hybrid"];
            break;  
    }
    return segment;
}

- (void)setup
{
    self.title = @"Location";
    self.tabBarItem.image = [UIImage imageNamed:@"Location 15.png"];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.mapView && self.mapView.userLocation.updating) {
        [self.mapView setShowsUserLocation:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mapView.showsUserLocation = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeHybrid;
    self.navigationItem.titleView = [self segmentController];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.mapView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
