//
//  ScreenTestViewController.h
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenPixelsFirstViewController.h"
#import "TouchTestViewController.h"
#import "HDTAppDelegate.h"


@interface ScreenTestViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, TouchTestViewControllerDelegate, BannerViewDelegate>
{
    TouchTestViewController *touchView;
    ScreenPixelsFirstViewController *firstPixel;
}

@property (strong) TouchTestViewController *touchView;
@property (strong) ScreenPixelsFirstViewController *firstPixel;
@property (strong) IBOutlet UIButton *camera;

- (IBAction)pixelTest:(UIButton *)sender;
- (IBAction)touchTest:(UIButton *)sender;
- (IBAction)cameraTest:(UIButton *)sender;

@end
