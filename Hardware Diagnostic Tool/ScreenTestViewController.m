//
//  ScreenTestViewController.m
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScreenTestViewController.h"

@interface ScreenTestViewController()

@property (strong) ADBannerView *bannerView;

- (void)layoutForCurrentOrientation:(BOOL)animated;

@end

@implementation ScreenTestViewController

@synthesize firstPixel, touchView;
@synthesize camera;
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
    self.bannerView = nil;
    [self layoutForCurrentOrientation:YES];
}

- (void)touchTestViewControllerDidFinishTestingWithSender:(TouchTestViewController *)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)pixelTest:(UIButton *)sender
{
    self.firstPixel = [[ScreenPixelsFirstViewController alloc] init];
    [self.navigationController pushViewController:firstPixel animated:YES];
}

- (IBAction)touchTest:(UIButton *)sender
{
    self.touchView = [[TouchTestViewController alloc] init];
    self.touchView.delegate = self;
    self.touchView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:touchView animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
}



- (IBAction)cameraTest:(UIButton *)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)setup
{
    self.title = @"Display";
    self.tabBarItem.image = [UIImage imageNamed:@"Display 15.png"];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.camera setHidden:YES];
    } else
    {
        self.camera.hidden = NO;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
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
    self.firstPixel = nil;
    self.touchView = nil;
    // Do any additional setup after loading the view from its nib.
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.camera setHidden:YES];
    } else
    {
        self.camera.hidden = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self layoutForCurrentOrientation:NO];
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
    return YES;
}

@end
