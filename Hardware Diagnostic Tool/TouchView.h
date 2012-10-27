//
//  TouchView.h
//  TouchTest
//
//  Created by Arish on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchView : UIView {
	NSString *__unsafe_unretained state;
	int count;
	UIGestureRecognizer *touchGR;
	NSArray *colorArray;
	CGPoint loc;
}

@property (readonly) int count;


@end
