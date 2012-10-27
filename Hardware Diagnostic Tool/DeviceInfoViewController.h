//
//  DeviceInfoViewController.h
//  Hardware Diagnostic Tool
//
//  Created by Aryan Sharifian on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDTAppDelegate.h"
#import <StoreKit/StoreKit.h>

@interface DeviceInfoViewController : UIViewController <BannerViewDelegate, SKProductsRequestDelegate, UIAlertViewDelegate, SKPaymentTransactionObserver, UIActionSheetDelegate> {
    
}

@property (strong) IBOutlet UIButton *adButton;

- (IBAction)batteryTaped:(id)sender;
- (IBAction)infoTaped:(id)sender;
- (IBAction)removeAdsTaped:(id)sender;

@end
