//
//  ScreenPixelsFirstViewController.h
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenPixelsViewController.h"
#import "ResultViewController.h"
#import "HDTAppDelegate.h"

@interface ScreenPixelsFirstViewController : UIViewController <ScreenPixelsViewControllerDelegate, BannerViewDelegate>
{
    UIPopoverController *pop;
    ScreenPixelsViewController *pixelView;
    ResultViewController *rvc;
}

- (IBAction)beginTest:(UIButton *)sender;
@property (strong) UIPopoverController *pop;

@end
