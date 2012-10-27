//
//  SpeakerTestViewController.m
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SpeakerTestViewController.h"

@interface SpeakerTestViewController()

@property (strong) ADBannerView *bannerView;

- (void)layoutForCurrentOrientation:(BOOL)animated;

@end

@implementation SpeakerTestViewController
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    
}

- (IBAction)bothTestTaped:(UIButton *)sender
{
    url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Sound Test(Stereo)" ofType:@"m4a"]];
    stereoPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [stereoPlayer prepareToPlay];
	[stereoPlayer setVolume: 1.0];
	[stereoPlayer setDelegate: self];
    [stereoPlayer play];
}

- (IBAction)rightTestTaped:(UIButton *)sender
{
    url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Sound Test(Right)" ofType:@"m4a"]];
    stereoPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [stereoPlayer prepareToPlay];
	[stereoPlayer setVolume: 1.0];
	[stereoPlayer setDelegate: self];
    [stereoPlayer play];
}

- (IBAction)leftTestTaped:(UIButton *)sender
{
    url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Sound Test(Left)" ofType:@"m4a"]];
    stereoPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [stereoPlayer prepareToPlay];
	[stereoPlayer setVolume: 1.0];
	[stereoPlayer setDelegate: self];
    [stereoPlayer play];
}

- (IBAction)stopTestTaped:(UIButton *)sender
{
    if (stereoPlayer) {
        [stereoPlayer stop];
    }
    
}

- (void)setup
{
    self.title = @"Speaker";
    self.tabBarItem.image = [UIImage imageNamed:@"speaker 15.png"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
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
    if (!url) {
        url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Sound Test(Stereo)" ofType:@"m4a"]];
    }
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
