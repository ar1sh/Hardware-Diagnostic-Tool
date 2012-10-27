//
//  LocationDetailsViewController.m
//  LocationTest
//
//  Created by Aryan Sharifian on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationDetailsViewController.h"
#import "LocationMapViewController.h"

@implementation LocationDetailsViewController

@synthesize latitute, longitute, atitute, accracy, speed;
@synthesize delegate;

- (void)setup
{
    self.title = @"Current Location Details";
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
    // Do any additional setup after loading the view from its nib.
    
    self.latitute.text = [NSString stringWithFormat:@"%f", [self.delegate coordinates:self].coordinate.latitude];
    self.longitute.text = [NSString stringWithFormat:@"%f", [self.delegate coordinates:self].coordinate.longitude];
    self.atitute.text = [NSString stringWithFormat:@"%f", [self.delegate coordinates:self].altitude];
    self.speed.text = [NSString stringWithFormat:@"%f", [self.delegate coordinates:self].speed];
    self.accracy.text = [NSString stringWithFormat:@"Vertical: %f,\nHorizantal: %f", [self.delegate coordinates:self].verticalAccuracy, [self.delegate coordinates:self].horizontalAccuracy];  
}

- (void)viewDidUnload
{
    self.latitute = nil;
    self.longitute = nil;
    self.atitute = nil;
    self.accracy = nil;
    self.speed = nil;
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
