//
//  AccelerometerTestViewController.h
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "HDTAppDelegate.h"

@interface AccelerometerTestViewController : UIViewController <BannerViewDelegate>
{
    IBOutlet UILabel *x;
    IBOutlet IBOutlet UILabel *y;
    UILabel *z;
}

@property (unsafe_unretained, readonly) CMMotionManager *motionManager;
@property (strong) IBOutlet UILabel *x;
@property (strong) IBOutlet UILabel *y;
@property (strong) IBOutlet UILabel *z;

@property (strong) IBOutlet UIImageView *horizantalDot;
@property (strong) IBOutlet UIImageView *verticalDot;
@property (strong) IBOutlet UIImageView *horizantalTube;
@property (strong) IBOutlet UIImageView *verticalTube;

@end
