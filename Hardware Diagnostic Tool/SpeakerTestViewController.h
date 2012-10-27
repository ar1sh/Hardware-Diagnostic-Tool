//
//  SpeakerTestViewController.h
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HDTAppDelegate.h"

@interface SpeakerTestViewController : UIViewController <AVAudioPlayerDelegate, BannerViewDelegate>
{
    NSURL *url;
    AVAudioPlayer *stereoPlayer;
    
}


- (IBAction)bothTestTaped:(UIButton *)sender;
- (IBAction)rightTestTaped:(UIButton *)sender;
- (IBAction)leftTestTaped:(UIButton *)sender;
- (IBAction)stopTestTaped:(UIButton *)sender;


@end
