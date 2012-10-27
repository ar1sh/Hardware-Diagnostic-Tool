//
//  PixelCheck.h
//  ScreenPixels
//
//  Created by Arish on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PixelCheck;

@protocol PixelCheckDelegate

-(UIColor *)testColor:(PixelCheck *)requestor;
-(BOOL)testReturn:(PixelCheck *)requestor;

@end



@interface PixelCheck : UIView {
	id <PixelCheckDelegate> __unsafe_unretained delegate;
	
	int returnCount;
}

@property (unsafe_unretained) id <PixelCheckDelegate> delegate;
@property (readonly) BOOL Blac;
@property (readonly) BOOL White;
@property (readonly) BOOL Red;
@property (readonly) BOOL Blue;
@property (readonly) BOOL Green;
@end
