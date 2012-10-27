//
//  ResultView.m
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultView.h"

@implementation ResultView
@synthesize delegate;
@synthesize scale;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSString *)stringForBool:(NSString *)b
{
    if ([b isKindOfClass:[NSString class]]) {
        if ([@"NO" isEqual:b])
        {
            return @"Not Passed";
        } else
        {
            return @"Passed";
        }
    }
    else
    {
        if ([b doubleValue] == 0) {
            return @"Not Passed";
        } else {
            return @"Passed";  
        }
    }
    
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if ([self.delegate resultArrayForView:self]) {
        CGPoint upLeftPoint;
        upLeftPoint.x = self.bounds.origin.x;
        upLeftPoint.y = self.bounds.origin.y;
        
        CGSize textSize;
        
        UIFont *f = [self.delegate fontForView:self];
        
        CGContextRef con=UIGraphicsGetCurrentContext();
        
        UIGraphicsPushContext(con);
        NSString *currentResult;
        
        NSArray *ar = [self.delegate resultArrayForView:self];
        
        //black
        upLeftPoint.x = self.bounds.origin.x + 5;
        upLeftPoint.y += 5;
        currentResult = @"Black: ";
        textSize = [currentResult sizeWithFont:f];
        [currentResult drawAtPoint:upLeftPoint withFont:f];
        upLeftPoint.x += textSize.width;
        currentResult = [self stringForBool:[ar objectAtIndex:1]];
        [currentResult drawAtPoint:upLeftPoint withFont:f];
        
        //white
        upLeftPoint.x  = self.bounds.origin.x + 5;
        upLeftPoint.y += textSize.height + 5;
        currentResult = @"White: ";
        textSize = [currentResult sizeWithFont:f];
        [currentResult drawAtPoint:upLeftPoint withFont:f];
        upLeftPoint.x += textSize.width;
        currentResult = [self stringForBool:[ar objectAtIndex:2]];
        [currentResult drawAtPoint:upLeftPoint withFont:f];
        
        //red
        upLeftPoint.x  = self.bounds.origin.x + 5;
        upLeftPoint.y += textSize.height + 5;
        currentResult = @"Red: ";
        textSize = [currentResult sizeWithFont:f];
        [currentResult drawAtPoint:upLeftPoint withFont:f];
        upLeftPoint.x += textSize.width;
        currentResult = [self stringForBool:[ar objectAtIndex:3]];
        [currentResult drawAtPoint:upLeftPoint withFont:f];
        
        //blue
        upLeftPoint.x  = self.bounds.origin.x + 5;
        upLeftPoint.y += textSize.height + 5;
        currentResult = @"Blue: ";
        textSize = [currentResult sizeWithFont:f];
        [currentResult drawAtPoint:upLeftPoint withFont:f];
        upLeftPoint.x += textSize.width;
        currentResult = [self stringForBool:[ar objectAtIndex:4]];
        [currentResult drawAtPoint:upLeftPoint withFont:f];
        
        //green
        upLeftPoint.x  = self.bounds.origin.x + 5;
        upLeftPoint.y += textSize.height + 5;
        currentResult = @"Green: ";
        textSize = [currentResult sizeWithFont:f];
        [currentResult drawAtPoint:upLeftPoint withFont:f];
        upLeftPoint.x += textSize.width;
        currentResult = [self stringForBool:[ar objectAtIndex:5]];
        [currentResult drawAtPoint:upLeftPoint withFont:f];
        
    }
    
}

@end
