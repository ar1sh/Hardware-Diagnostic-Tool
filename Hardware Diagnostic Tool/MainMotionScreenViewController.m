//
//  MainMotionScreenViewController.m
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMotionScreenViewController.h"
#import "AccelerometerTestViewController.h"
#import "GyroRotationViewController.h"
#import "ProximityViewController.h"

@interface MainMotionScreenViewController()

@property (strong) ADBannerView *bannerView;

- (void)layoutForCurrentOrientation:(BOOL)animated;

@end

@implementation MainMotionScreenViewController
@synthesize gyro;
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

- (CMMotionManager *)motionManager
{
    CMMotionManager *motionManager = nil;
    id appDelegate = [UIApplication sharedApplication].delegate;
    if ([appDelegate respondsToSelector:@selector(motionManager)]) {
        motionManager = [appDelegate motionManager];
    }
    return motionManager;
}

- (IBAction)accelerometerTaped:(id)sender
{
    AccelerometerTestViewController *acc = [[AccelerometerTestViewController alloc] init];
    [self.navigationController pushViewController:acc animated:YES];
}

- (IBAction)gyroTaped:(id)sender
{
    GyroRotationViewController *grvc = [[GyroRotationViewController alloc] init];
    [self.navigationController pushViewController:grvc animated:YES];
}

- (IBAction)proximityTaped:(id)sender
{
    ProximityViewController *pvc = [[ProximityViewController alloc] init];
    [self.navigationController pushViewController:pvc animated:YES];
}

- (void)setup
{
    self.title = @"Motion";
    self.tabBarItem.image = [UIImage imageNamed:@"accelerometer 15.png"];
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
    // Do any additional setup after loading the view from its nib.
    
    if (![self.motionManager isDeviceMotionAvailable]) {
        [self.gyro setHidden:YES];
    }
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.gyro = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
