//
//  AccelerometerTestViewController.m
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AccelerometerTestViewController.h"

@interface AccelerometerTestViewController()

@property (strong) ADBannerView *bannerView;

- (void)layoutForCurrentOrientation:(BOOL)animated;

@end

@implementation AccelerometerTestViewController
@synthesize x, y, z;
@synthesize verticalDot, horizantalDot, verticalTube, horizantalTube;
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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
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
    
}

- (CGRect)dotLocationWithAccelerationValue:(CGFloat)value forOrientation:(NSString *)orientation
{
    CGRect tubeRect;
    CGPoint dotPoint;
    CGFloat v;
    CGRect ret;
    if ([orientation isEqualToString:@"x"]) {
        tubeRect = self.horizantalTube.frame;
        v = ((((-value + 1.00) / 2.00) * tubeRect.size.width) + tubeRect.origin.x) - (self.horizantalDot.bounds.size.width / 2.00);
        dotPoint = CGPointMake(v, tubeRect.origin.y);
        ret = CGRectMake(dotPoint.x, dotPoint.y, self.horizantalDot.frame.size.width, self.horizantalDot.frame.size.height);
    } else if ([orientation isEqualToString:@"y"]) {
        tubeRect = self.verticalTube.frame;
        v = ((((value + 1.00) / 2.00) * tubeRect.size.height) + tubeRect.origin.y) - (self.verticalDot.bounds.size.height / 2.00);
        dotPoint = CGPointMake(tubeRect.origin.x, v);
        ret = CGRectMake(dotPoint.x, dotPoint.y, self.verticalDot.frame.size.width, self.verticalDot.frame.size.height);
    }
    return ret;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.motionManager isDeviceMotionAvailable]) {
        [self.motionManager startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMDeviceMotion *motion, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                CMAcceleration accel = motion.gravity;
                self.x.text = [NSString stringWithFormat:@"%f", accel.x];
                self.y.text = [NSString stringWithFormat:@"%f", accel.y];
                self.z.text = [NSString stringWithFormat:@"%f", accel.z];
                self.horizantalDot.frame = [self dotLocationWithAccelerationValue:accel.x forOrientation:@"x"];
                self.verticalDot.frame = [self dotLocationWithAccelerationValue:accel.y forOrientation:@"y"];
            });
        }];
    } else {
        [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            CMAcceleration accel = accelerometerData.acceleration;
            double ax = accel.x, ay = accel.y, az = accel.z;
            ax -= (ax * 1000.00 - ((int)(ax * 1000))) / 1000.00;
            ay -= (ay * 1000.00 - ((int)(ay * 1000))) / 1000.00;
            az -= (az * 1000.00 - ((int)(az * 1000))) / 1000.00;
            
            self.x.text = [NSString stringWithFormat:@"%f", ax];
            self.y.text = [NSString stringWithFormat:@"%f", ay];
            self.z.text = [NSString stringWithFormat:@"%f", az];
            self.horizantalDot.frame = [self dotLocationWithAccelerationValue:ax forOrientation:@"x"];
            self.verticalDot.frame = [self dotLocationWithAccelerationValue:ay forOrientation:@"y"];
        });
    }];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.motionManager stopAccelerometerUpdates];
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
    return NO;
}

@end
