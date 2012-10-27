//
//  MicTestViewController.m
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MicTestViewController.h"

@interface MicTestViewController()

@property (strong) ADBannerView *bannerView;

- (void)layoutForCurrentOrientation:(BOOL)animated;

@end

@implementation MicTestViewController
@synthesize rec, stop, rewind, play;
@synthesize bannerView;

- (void)layoutForCurrentOrientation:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    CGRect bannerFrame = self.bannerView.frame;
    if (self.bannerView.bannerLoaded) {
        bannerFrame.origin.y = 0;
    } else {
        bannerFrame.origin.y = [[UIScreen mainScreen] bounds].size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        self.bannerView.frame = bannerFrame;
    }];
}

- (void)showBannerView:(ADBannerView *)banner
{
    self.bannerView = banner;
    [self.view addSubview:banner];
    [self layoutForCurrentOrientation:YES];
}

- (void)hideBannerView:(ADBannerView *)banner
{
    [banner removeFromSuperview];
    self.bannerView = nil;
    [self layoutForCurrentOrientation:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)recTaped:(UIButton *)sender
{
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	NSURL *recordURL = [NSURL URLWithString:[cacheDirectory stringByAppendingPathComponent:@"AnswerRecording.aif"]];
	if (!recorder.recording) {
        if (!recorder) 
        {
            recorder = [[AVAudioRecorder alloc] initWithURL:recordURL settings:nil error:NULL];  
        }
		[recorder record];
        self.play.enabled = NO;
        self.rewind.enabled = NO;
        self.rec.enabled = NO;
        self.stop.enabled = YES;
	}
}

- (IBAction)stopTaped:(UIButton *)sender
{
    if (player.playing) {
        [player stop];
        self.play.enabled = YES;
        self.rec.enabled = YES;
        self.stop.enabled = NO;
        self.rewind.enabled = NO;
    } else if (recorder.recording)
    {
        [recorder stop];
        self.play.enabled = YES;
        self.rec.enabled = YES;
        self.stop.enabled = NO;
        self.rewind.enabled = NO;
    } else {
        
    }
}

- (IBAction)playTaped:(UIButton *)sender
{
    if (!player.playing)
    {
        NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSURL *recordURL = [NSURL URLWithString:[cacheDirectory stringByAppendingPathComponent:@"AnswerRecording.aif"]];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordURL error:NULL];
        player.delegate = self;
        [player play];
        self.play.enabled = NO;
        self.rec.enabled = NO;
        self.stop.enabled = YES;
        self.rewind.enabled = YES;
    }
}

- (IBAction)rewindTaped:(UIButton *)sender
{
    if (player.playing) {
        [player setCurrentTime:0];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.rewind.enabled = NO;
    self.play.enabled = NO;
    self.stop.enabled = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.rec = nil;
    self.stop = nil;
    self.rewind = nil;
    self.play = nil;
}

- (void)dealloc
{
    self.rec = nil;
    self.stop = nil;
    self.rewind = nil;
    self.play = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.play.enabled = YES;
    self.rec.enabled = YES;
    self.stop.enabled = NO;
    self.rewind.enabled = NO;
}

@end
