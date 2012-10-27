//
//  TouchView.m
//  TouchTest
//
//  Created by Arish on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TouchView.h"
#import "TouchTestViewController.h"

@implementation TouchView

@synthesize count;

- (void)setup
{
	self.contentMode = UIViewContentModeRedraw;
	count = 0;
	state = @"None";
	colorArray = [[NSArray alloc] initWithObjects:[UIColor blueColor], [UIColor redColor], [UIColor blackColor],
				  [UIColor yellowColor], [UIColor greenColor], [UIColor grayColor],
				  [UIColor colorWithRed:0.5 green:0.3 blue:0.1 alpha:1],
				  [UIColor colorWithRed:0.3 green:0.8 blue:1 alpha:1],
				  [UIColor colorWithRed:0.2 green:0.7 blue:0 alpha:1],
				  [UIColor colorWithRed:0.7 green:0.1 blue:0.15 alpha:1],
				  [UIColor colorWithRed:0.1 green:0.2 blue:0.6 alpha:1],
				  [UIColor colorWithRed:0.2 green:0 blue:0.3 alpha:1],
				  [UIColor colorWithRed:0.6 green:0.9 blue:0.41 alpha:1],
				  [UIColor colorWithRed:0.2 green:0.1 blue:0.15 alpha:1],
				  [UIColor colorWithRed:0.6 green:0.2 blue:0.9 alpha:1], nil];				  
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib
{
	[self setup];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized) {
		state = @"Taped";
		touchGR = gesture;
		loc = [gesture locationInView:self];
		[self setNeedsDisplay];
	}
}

- (void)multiTap:(UITapGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized) {
		state = @"Multi Finger Tapped";
		touchGR = gesture;
		loc = [gesture locationInView:self];
		[self setNeedsDisplay];
	}
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateChanged ||
		gesture.state == UIGestureRecognizerStateEnded) {
		state = @"Pinched";
		touchGR = gesture;
		[self setNeedsDisplay];
	}
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateChanged ||
		gesture.state == UIGestureRecognizerStateEnded) {
		state = @"Paned";
		touchGR = gesture;
		[self setNeedsDisplay];
	}
}

- (void)rotate:(UIRotationGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateChanged ||
		gesture.state == UIGestureRecognizerStateEnded) {
		state = @"Rotated";
		touchGR = gesture;
		[self setNeedsDisplay];
	}
}

- (void)longG:(UILongPressGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized ||
		gesture.state == UIGestureRecognizerStateBegan) {
		state = @"Long Pressed";
		touchGR = gesture;
		loc = [gesture locationInView:self];
		[self setNeedsDisplay];
	}
}

- (void)drawCircleAtPoint:(CGPoint)point withRadius:(CGFloat)radius withColor:(UIColor *)color isFilled:(BOOL)filled withOpacity:(CGFloat)opacity atContext:(CGContextRef)context
{
	UIGraphicsPushContext(context);
	CGContextBeginPath(context);
	if (opacity > 0 && opacity <= 1) {
		[color colorWithAlphaComponent:opacity];
	}
	[color setStroke];
	if (filled) [color setFill];
	CGRect rc = CGRectMake(point.x - radius, point.y - radius, radius * 2, radius * 2);
	CGContextFillEllipseInRect(context, rc);
	CGContextStrokePath(context);
	UIGraphicsPopContext();
}

-(CGPoint)correctTextLocation:(CGPoint)locat withText:(NSString *)text withFont:(UIFont *)fn
{
	CGPoint cp;
	if ([text sizeWithFont:fn].height + locat.y + 40 < self.bounds.size.height && 
		[text sizeWithFont:fn].width + locat.x < self.bounds.size.width) {
		cp.x = locat.x - 40;
		cp.y = locat.y + 45;
	} else if ([text sizeWithFont:fn].height + locat.y + 40 >= self.bounds.size.height && 
			   [text sizeWithFont:fn].width + locat.x < self.bounds.size.width){
		cp.x = locat.x - 40;
		cp.y = locat.y - 64;
	} else if ([text sizeWithFont:fn].height + locat.y + 40 < self.bounds.size.height && 
			   [text sizeWithFont:fn].width + locat.x >= self.bounds.size.width) {
		cp.x = locat.x - 40 - ([text sizeWithFont:fn].width + locat.x - self.bounds.size.width);
		cp.y = locat.y + 45;
	} else if ([text sizeWithFont:fn].height + locat.y + 40 >= self.bounds.size.height && 
			   [text sizeWithFont:fn].width + locat.x >= self.bounds.size.width) {
		cp.x = locat.x - 40 - ([text sizeWithFont:fn].width + locat.x - self.bounds.size.width);
		cp.y = locat.y - 64;
	}
	return cp;
}

- (void)drawRect:(CGRect)rect {
	count = [touchGR numberOfTouches];
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGPoint location;
    if (count) {
		for (int i = 0; i < count; i++) {
			location = [touchGR locationOfTouch:i inView:self];
			[self drawCircleAtPoint:location withRadius:40 withColor:[colorArray objectAtIndex:i] isFilled:YES withOpacity:0.3 atContext:c];
			NSString *locationText = [[@"Location " stringByAppendingString:[NSString stringWithFormat:@"%g", location.x * self.contentScaleFactor]] stringByAppendingString:[NSString stringWithFormat:@", %g", location.y * self.contentScaleFactor]];
			UIFont *fn = [UIFont fontWithName:@"helvetica" size:13];
			[locationText drawAtPoint:[self correctTextLocation:location withText:locationText withFont:fn] withFont:fn];			
		}
	}else if ([touchGR isKindOfClass:[UITapGestureRecognizer class]] || [touchGR isKindOfClass:[UILongPressGestureRecognizer class]]){
		count = [(UITapGestureRecognizer *)touchGR numberOfTouchesRequired];
		
			count = 1;
			location = loc;
			[self drawCircleAtPoint:location withRadius:40 withColor:[colorArray objectAtIndex:0] isFilled:YES withOpacity:0.3 atContext:c];
			NSString *locationText = [[@"Location " stringByAppendingString:[NSString stringWithFormat:@"%g", location.x * self.contentScaleFactor]] stringByAppendingString:[NSString stringWithFormat:@", %g", location.y * self.contentScaleFactor]];
			UIFont *fn = [UIFont fontWithName:@"helvetica" size:13];
			[locationText drawAtPoint:[self correctTextLocation:location withText:locationText withFont:fn] withFont:fn];

	}
}

@end
