//
//  GyroRotationView.h
//  Hardware Diagnostic Tool
//
//  Created by Aryan Sharifian on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@class GyroRotationView;

@protocol GyroRotationViewDelegate
- (CMAttitude *)centerValueWithGyroRotationView:(GyroRotationView *)sender;
@end

@interface GyroRotationView : UIView
{
    id <GyroRotationViewDelegate> __unsafe_unretained delegate;
}

@property (unsafe_unretained) id <GyroRotationViewDelegate> delegate;

@end
