//
//  ProximityViewController.h
//  Hardware Diagnostic Tool
//
//  Created by Aryan Sharifian on 10/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDTAppDelegate.h"

@interface ProximityViewController : UIViewController <BannerViewDelegate>
{
    IBOutlet UISegmentedControl *segment;
}

@property (strong) IBOutlet UISegmentedControl *segment;

@end
