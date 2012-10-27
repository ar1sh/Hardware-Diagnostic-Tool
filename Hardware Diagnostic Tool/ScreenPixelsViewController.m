//
//  ScreenPixelsViewController.m
//  ScreenPixels
//
//  Created by Arish on 8/29/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "ScreenPixelsViewController.h"
#import "ResultViewController.h"
#import "PixelCheckHistory.h"
#import "SingleResultViewController.h"

@implementation ScreenPixelsViewController

@synthesize color;
@synthesize colorReturn;

@synthesize blackLabel, whiteLabel, redLabel, greenLabel, blueLabel;
@synthesize blackYes, blackNo, whiteYes, whiteNo, redYes, redNo, blueYes, blueNo, greenYes, greenNo;

@synthesize pc;

@synthesize pop;
@synthesize delegate;


-(UIColor *)testColor:(PixelCheck *)requestor
{
	UIColor *r = [UIColor blackColor];
	if (requestor == self.pc) r = self.color;
	return r;
}

-(BOOL)testReturn:(PixelCheck *)requestor
{
	BOOL c = NO;
	if (requestor == self.pc) c = self.colorReturn;
	return c;
}

- (NSString *)stringForBool:(BOOL)b
{
    if (b) {
        return @"YES"; 
    } else
    {
        return @"NO";
    }
}

- (void)updateUIWithReturn:(BOOL)accepted
{
	if (arrayCount == 0) 
	{
		self.color = [UIColor blackColor];
		self.blackLabel.alpha = 1;
		self.blackYes.alpha = 1;
		self.blackNo.alpha =1;
		
	} 
	else if (arrayCount == 1) 
	{
		self.color = [UIColor whiteColor];
		self.blackLabel.alpha = 0;
		self.blackYes.alpha = 0;
		self.blackNo.alpha =0;
		self.whiteLabel.alpha = 1;
		self.whiteYes.alpha = 1;
		self.whiteNo.alpha =1;
		self.colorReturn = accepted;
        c1 = accepted;
	} 
	else if (arrayCount == 2) 
	{
		self.color = [UIColor redColor];
		self.whiteLabel.alpha = 0;
		self.whiteYes.alpha = 0;
		self.whiteNo.alpha = 0;
		self.redLabel.alpha = 1;
		self.redYes.alpha = 1;
		self.redNo.alpha =1;
		self.colorReturn = accepted;
        c2 = accepted;
	} 
	else if (arrayCount == 3) 
	{
		self.color = [UIColor blueColor];
		self.redLabel.alpha = 0;
		self.redYes.alpha = 0;
		self.redNo.alpha =0;
		self.blueLabel.alpha = 1;
		self.blueYes.alpha = 1;
		self.blueNo.alpha =1;
		self.colorReturn = accepted;
        c3 = accepted;
	} 
	else if (arrayCount == 4) 
	{
		self.color = [UIColor greenColor];
		self.blueLabel.alpha = 0;
		self.blueYes.alpha = 0;
		self.blueNo.alpha =0;
		self.greenLabel.alpha = 1;
		self.greenYes.alpha = 1;
		self.greenNo.alpha =1;
		self.colorReturn = accepted;
        c4 = accepted;
	} 
	else if (arrayCount == 5) 
	{
		
        self.pc.alpha =0;
		self.greenLabel.alpha = 0;
		self.greenYes.alpha = 0;
		self.greenNo.alpha =0;
		self.colorReturn = accepted;
        c5 = accepted;
        
        NSArray *ar = [NSArray  arrayWithObjects:@"start", [self stringForBool:c1], [self stringForBool:c2], [self stringForBool:c3], [self stringForBool:c4], [self stringForBool:c5], nil];
        [self.delegate screenPixelsViewController:self didFinishTestingWithReturnArray:ar];
	}
	
	[pc setNeedsDisplay];
	arrayCount++;
}

- (IBAction)buttonClicked:(UIButton *)sender
{
	if ([sender.titleLabel.text isEqual:@"Yes"]) {
		[self updateUIWithReturn:YES];
	} else if ([sender.titleLabel.text isEqual:@"No"]) {
		[self updateUIWithReturn:NO];
	}
}


- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.pc.delegate = self;
    
	arrayCount = 0;
    
	[self updateUIWithReturn:0];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



@end
