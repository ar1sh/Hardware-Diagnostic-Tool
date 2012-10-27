//
//  MicTestViewController.h
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HDTAppDelegate.h"

@interface MicTestViewController : UIViewController <AVAudioPlayerDelegate, BannerViewDelegate>
{
    IBOutlet UIButton *rec;
    IBOutlet UIButton *stop;
    IBOutlet UIButton *play;
    IBOutlet UIButton *rewind;
	AVAudioPlayer *player;
	AVAudioRecorder *recorder;
}

@property (strong) IBOutlet UIButton *rec;
@property (strong) IBOutlet UIButton *stop;
@property (strong) IBOutlet UIButton *play;
@property (strong) IBOutlet UIButton *rewind;

- (IBAction)recTaped:(UIButton *)sender;
- (IBAction)stopTaped:(UIButton *)sender;
- (IBAction)playTaped:(UIButton *)sender;
- (IBAction)rewindTaped:(UIButton *)sender;

@end
