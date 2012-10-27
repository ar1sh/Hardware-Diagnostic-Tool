//
//  GyroRotationViewController.m
//  Hardware Diagnostic Tool
//
//  Created by Aryan Sharifian on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GyroRotationViewController.h"

@implementation GyroRotationViewController
@synthesize grv;

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
        // Custom initialization
    }
    return self;
}

- (CMAttitude *)centerValueWithGyroRotationView:(GyroRotationView *)sender
{
    CMAttitude *att = nil;
    if (myAttitude) {
        att = myAttitude;
    }
    return att;
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
    
    grv.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    grv = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.motionManager startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMDeviceMotion *motion, NSError *error){
        if (!myAttitude) {
            myAttitude = [[CMAttitude alloc] init];
        }
        myAttitude = motion.attitude;
        
        [grv setNeedsLayout];
        dispatch_async(dispatch_get_main_queue(), ^{
            [grv setNeedsDisplay];
        });
    }];
     
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.motionManager stopDeviceMotionUpdates];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
