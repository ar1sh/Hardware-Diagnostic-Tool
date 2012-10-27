//
//  TouchTestViewController.m
//  TouchTest
//
//  Created by Arish on 9/1/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "TouchTestViewController.h"

@implementation TouchTestViewController

@synthesize tv;
@synthesize delegate;

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if (motion == UIEventSubtypeMotionShake )
	{
        [self resignFirstResponder];
		[self.delegate touchTestViewControllerDidFinishTestingWithSender:self];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self.tv action:@selector(tap:)];
	UIPanGestureRecognizer *pa = [[UIPanGestureRecognizer alloc] initWithTarget:self.tv action:@selector(pan:)];
	UIPinchGestureRecognizer *pi = [[UIPinchGestureRecognizer alloc] initWithTarget:self.tv action:@selector(pinch:)];
	UILongPressGestureRecognizer *l = [[UILongPressGestureRecognizer alloc] initWithTarget:self.tv action:@selector(longG:)];
	UIRotationGestureRecognizer *r = [[UIRotationGestureRecognizer alloc] initWithTarget:self.tv action:@selector(rotate:)];
	UITapGestureRecognizer *mt = [[UITapGestureRecognizer alloc] initWithTarget:self.tv action:@selector(multiTap:)];
    
	[mt setNumberOfTouchesRequired:2];
	
	[self.tv addGestureRecognizer:t];	[self.tv addGestureRecognizer:pa];	[self.tv addGestureRecognizer:pi];	[self.tv addGestureRecognizer:l];
	[self.tv addGestureRecognizer:r];	[self.tv addGestureRecognizer:mt];
	
	
	[self.tv setNeedsDisplay];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



@end
