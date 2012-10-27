//
//  BatteryInfoViewController.m
//  Hardware Diagnostic Tool
//
//  Created by Aryan Sharifian on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BatteryInfoViewController.h"

@interface BatteryInfoViewController()

@property (strong) ADBannerView *bannerView;

- (void)layoutForCurrentOrientation:(BOOL)animated;

@end

@implementation BatteryInfoViewController

@synthesize image;
@synthesize level, state;
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

- (void)setup
{
    self.title = @"Battery";
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

- (void)batteryImageUpdate
{
    UIDeviceBatteryState bs = [UIDevice currentDevice].batteryState;
    float bl = [UIDevice currentDevice].batteryLevel * 100.00;
    
    if (bs == UIDeviceBatteryStateUnknown) {
        self.image.image = [UIImage imageNamed:@"Battery Unknown 30.png"];
    } 
    else if (bs == UIDeviceBatteryStateFull)
    {
        self.image.image = [UIImage imageNamed:@"Battery Green 30.png"];
    } 
    else if (bs == UIDeviceBatteryStateCharging)
    {
        if (bl < 100) {
            self.image.image = [UIImage imageNamed:@"Battery Charging 30.png"];
        } else
        {
            self.image.image = [UIImage imageNamed:@"Battery Pluged 30.png"];
        }
    } 
    else if (bs == UIDeviceBatteryStateUnplugged)
    {
        if (bl >= 70) {
            self.image.image = [UIImage imageNamed:@"Battery Green 30.png"];
        } else if (bl >= 20 && bl < 70)
        {
            self.image.image = [UIImage imageNamed:@"Battery Yellow 30.png"];
        } else
        {
            self.image.image = [UIImage imageNamed:@"Battery Red 30.png"];
        }
    }
}

- (void)batteryStateDidChange
{
    //state.text = [@"State: " stringByAppendingFormat:@"%@", [UIDevice currentDevice].batteryState];
    if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateCharging) {
        state.text = @"State: Charging";
    } else if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateFull) {
        state.text = @"State: Full";
    } else if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateUnplugged) {
        state.text = @"State: Unplugged";
    } else if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateUnknown) {
        state.text = @"State: Unknown";
    }
    [self batteryImageUpdate];
}

- (void)batteryLevelDidChange
{
    int d = ([UIDevice currentDevice].batteryLevel * 100);
    level.text = [@"Level: " stringByAppendingFormat:@"%d", d];
    if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateUnknown) {
        level.text = @"Level: Unknown";
    }
    [self batteryImageUpdate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    [self batteryLevelDidChange];
    [self batteryStateDidChange];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIDevice currentDevice].batteryMonitoringEnabled = NO;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(batteryStateDidChange)
												 name:UIDeviceBatteryStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(batteryLevelDidChange)
												 name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.state = nil;
    self.level = nil;
    self.image = nil;
}

- (void)dealloc
{
    self.state = nil;
    self.level = nil;
    self.image = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
