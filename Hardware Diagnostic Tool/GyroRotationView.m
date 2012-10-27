//
//  GyroRotationView.m
//  Hardware Diagnostic Tool
//
//  Created by Aryan Sharifian on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GyroRotationView.h"

@implementation GyroRotationView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawLineInPoint:(CGPoint)point withIndex:(int)index withOrientation:(float)orientation withMaxSize:(CGFloat)maxSize withContext:(CGContextRef)context;
{
    CGFloat size;
    float firstR, secondR, thirdR;
    //double first, second, third;
    
    //first = floor(index / 4);
    firstR = fmodf(index, 4);
    
    //second = floor(index / 16);
    secondR = fmodf(index, 16);
    
    //third = floor(index / 32);
    thirdR = fmodf(index, 32);
    
    if ((firstR == 0)&&(secondR == 0)&&(thirdR == 0)) {
        size = maxSize;
    } else if ((firstR == 0)&&(secondR == 0))
    {
        size = maxSize / 2;
    } else if (firstR == 0)
    {
        size = maxSize / 4;
    } else
    {
        size = maxSize / 8;
    }
    
    CGFloat oneX, oneY, twoX, twoY;
    
    oneX = point.x + sin(orientation) * size;
    oneY = point.y - cos(orientation) * size;
    
    twoX = point.x - sin(orientation) * size;
    twoY = point.y + cos(orientation) * size;
    
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, oneX, oneY);
    CGContextAddLineToPoint(context, twoX, twoY);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat x = self.bounds.origin.x;
    CGFloat y = self.bounds.origin.y;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat topForth = y + (height / 4);
    CGPoint forthMid = CGPointMake((x + (width / 2)), topForth);
    
    //devide
    
    UIGraphicsPushContext(context);
    [[UIColor whiteColor] set];
    CGContextBeginPath(context);
    CGContextAddRect(context, CGRectMake(x, y, width, height));
    CGContextMoveToPoint(context, x, topForth);
    CGContextAddLineToPoint(context, x + width, topForth);
    CGContextMoveToPoint(context, forthMid.x, forthMid.y);
    CGContextAddLineToPoint(context, forthMid.x, y + height);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
    
    //roll
    CGPoint beginRoll = CGPointMake(x + (width / 20), (topForth - y)/2);
    CGFloat defRoll = (width - (width / 10)) / 12;
    //CGPoint endRoll = CGPointMake(x + width - (width / 20), (topForth - y)/2);
    CGFloat maxSize = topForth - ((topForth - y) / 1.5);
    
    for (int i = -6; i < 7; i++) {
        [self drawLineInPoint:CGPointMake(beginRoll.x + ((i + 6) * defRoll), beginRoll.y) withIndex:((([self.delegate centerValueWithGyroRotationView:self].roll) / M_PI) * 32) + i withOrientation:0 withMaxSize:maxSize withContext:context]; 
    }
    
    //pitch
    CGPoint beginPitch = CGPointMake((x + width) / 4, topForth + (height / 20));
    CGFloat defPitch = ((height - (beginPitch.y + height / 20)) / 12);
    
    for (int i = -6; i < 7; i++) {
        [self drawLineInPoint:CGPointMake(beginPitch.x, beginPitch.y + ((i + 6) * defPitch)) withIndex:((([self.delegate centerValueWithGyroRotationView:self].pitch) / M_PI) * 32) + i withOrientation:M_PI / 2 withMaxSize:maxSize withContext:context];
    }
    
    //yaw
    //CGPoint beginYaw = CGPointMake((x + (width / 2)) + (width / 4), topForth + (height / 20));
    CGFloat sizeYaw;
    if ((width / 2) > (height - topForth))
    {
        sizeYaw = ((height - topForth - (height / 10)) / 2);
    } else
    {
        sizeYaw = ((width / 2) - (width / 10)) / 2;
    }
    CGPoint midYaw = CGPointMake((3 * width) / 4, ((height - topForth) / 2) + topForth);
    
    double yaw = [self.delegate centerValueWithGyroRotationView:self].yaw;
    
    for (double i = yaw; i < ((2 * M_PI) + yaw); i += (M_PI / 32)) {
        [self drawLineInPoint:CGPointMake(midYaw.x + (cos(i) * sizeYaw), midYaw.y + (sin(i) * sizeYaw)) withIndex:((i - yaw) / (M_PI / 32)) withOrientation:i - (M_PI / 2) withMaxSize:maxSize / 3 withContext:context];
    }
}


@end
