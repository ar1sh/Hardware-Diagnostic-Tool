//
//  PixelCheck.m
//  ScreenPixels
//
//  Created by Arish on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PixelCheck.h"


@implementation PixelCheck

@synthesize delegate;
@synthesize Blac = c1;
@synthesize White = c2;
@synthesize Red = c3;
@synthesize Blue = c4;
@synthesize Green = c5;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
    }
    return self;
}

- (void)drawTestInRect:(CGRect)testRect withColor:(UIColor *)color inContext:(CGContextRef)context
{
	UIGraphicsPushContext(context);
	[color setFill];
	[color setStroke];
	CGContextAddRect(context, testRect);
	CGContextFillPath(context);
	UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect 
{
	
	CGContextRef con = UIGraphicsGetCurrentContext();
	
	if (returnCount == 1) {
		c1 = [self.delegate testReturn:self];
	} else if (returnCount == 2) {
		c2 = [self.delegate testReturn:self];
	} else if (returnCount == 3) {
		c3 = [self.delegate testReturn:self];
	} else if (returnCount == 4) {
		c4 = [self.delegate testReturn:self];
	} else if (returnCount == 5) {
		c5 = [self.delegate testReturn:self];
	}
	
	returnCount++;
	
    [self drawTestInRect:self.bounds withColor:[self.delegate testColor:self] inContext:con];	
}



@end
