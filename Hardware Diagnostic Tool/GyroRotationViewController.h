//
//  GyroRotationViewController.h
//  Hardware Diagnostic Tool
//
//  Created by Aryan Sharifian on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GyroRotationView.h"
#import <CoreMotion/CoreMotion.h>

@interface GyroRotationViewController : UIViewController <GyroRotationViewDelegate>
{
    IBOutlet GyroRotationView *grv;
    CMAttitude *myAttitude;
}

@property (strong) IBOutlet GyroRotationView *grv;
@property (unsafe_unretained, readonly) CMMotionManager *motionManager;

@end
