//
//  MainMotionScreenViewController.h
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "HDTAppDelegate.h"

@interface MainMotionScreenViewController : UIViewController <BannerViewDelegate>
{
    IBOutlet UIButton *gyro;
}

@property (strong) IBOutlet UIButton *gyro;

@property (unsafe_unretained, readonly) CMMotionManager *motionManager;

- (IBAction)accelerometerTaped:(id)sender;
- (IBAction)gyroTaped:(id)sender;
- (IBAction)proximityTaped:(id)sender;

@end
