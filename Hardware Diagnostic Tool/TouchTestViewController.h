//
//  TouchTestViewController.h
//  TouchTest
//
//  Created by Arish on 9/1/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchView.h"

@class TouchTestViewController;

@protocol TouchTestViewControllerDelegate
- (void)touchTestViewControllerDidFinishTestingWithSender:(TouchTestViewController *)sender;
@end

@interface TouchTestViewController : UIViewController {
	TouchView *tv;
    id <TouchTestViewControllerDelegate> __unsafe_unretained delegate;
}


@property (strong) IBOutlet TouchView *tv;
@property (unsafe_unretained) id <TouchTestViewControllerDelegate> delegate;


@end

