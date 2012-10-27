//
//  ResultView.h
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResultView;

@protocol ResultViewDelegate
- (NSArray *)resultArrayForView:(ResultView *)sender;
- (UIFont *)fontForView:(ResultView *)sender;
@end

@interface ResultView : UIView
{
    id <ResultViewDelegate> __unsafe_unretained delegate;
    float scale;
}
@property (unsafe_unretained) id <ResultViewDelegate> delegate;
@property float scale;

@end
