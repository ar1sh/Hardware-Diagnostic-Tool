//
//  ScreenPixelsViewController.h
//  ScreenPixels
//
//  Created by Arish on 8/29/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PixelCheck.h"

@class ScreenPixelsViewController;

@protocol ScreenPixelsViewControllerDelegate
- (void)screenPixelsViewController:(ScreenPixelsViewController *)sender didFinishTestingWithReturnArray:(NSArray *)array;
@end

@interface ScreenPixelsViewController : UIViewController <PixelCheckDelegate>
{
	UIColor *testColor;
	UILabel *blackLabel, *whiteLabel, *greenLabel, *redLabel, *blueLabel;
	UIButton *blackYes, *blackNo, *whiteYes, *whiteNo, *redYes, *redNo, *greenYes, *greenNo, *blueYes, *blueNo;
	PixelCheck *pc;
	BOOL colorReturn;
	int arrayCount;
    BOOL c1, c2, c3, c4, c5;
    UIPopoverController *pop;
    id <ScreenPixelsViewControllerDelegate> __unsafe_unretained delegate;
}

@property (strong) IBOutlet UILabel *blackLabel;
@property (strong) IBOutlet UILabel *whiteLabel;
@property (strong) IBOutlet UILabel *redLabel;
@property (strong) IBOutlet UILabel *blueLabel;
@property (strong) IBOutlet UILabel *greenLabel;

@property (strong) IBOutlet UIButton *blackYes;
@property (strong) IBOutlet UIButton *blackNo;
@property (strong) IBOutlet UIButton *whiteYes;
@property (strong) IBOutlet UIButton *whiteNo;
@property (strong) IBOutlet UIButton *redYes;
@property (strong) IBOutlet UIButton *redNo;
@property (strong) IBOutlet UIButton *blueYes;
@property (strong) IBOutlet UIButton *blueNo;
@property (strong) IBOutlet UIButton *greenYes;
@property (strong) IBOutlet UIButton *greenNo;

@property (strong) IBOutlet PixelCheck *pc;

@property (strong) UIPopoverController *pop;

@property (strong) UIColor *color;
@property BOOL colorReturn;

@property (unsafe_unretained) id <ScreenPixelsViewControllerDelegate> delegate;

- (IBAction)buttonClicked:(UIButton *)sender;

@end

