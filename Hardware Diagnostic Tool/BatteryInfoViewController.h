//
//  BatteryInfoViewController.h
//  Hardware Diagnostic Tool
//
//  Created by Aryan Sharifian on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDTAppDelegate.h"

@interface BatteryInfoViewController : UIViewController <BannerViewDelegate>
{
    IBOutlet UIImageView *image;
    IBOutlet UILabel *level;
    IBOutlet UILabel *state;

}

@property (strong) IBOutlet UIImageView *image;
@property (strong) IBOutlet  UILabel *level;
@property (strong) IBOutlet UILabel *state;

@end
