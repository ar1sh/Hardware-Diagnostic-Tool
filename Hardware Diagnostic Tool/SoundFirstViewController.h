//
//  SoundFirstViewController.h
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDTAppDelegate.h"

@interface SoundFirstViewController : UIViewController <BannerViewDelegate>
{
}


- (IBAction)speakerTest:(UIButton *)sender;
- (IBAction)micTest:(UIButton *)sender;

@end
