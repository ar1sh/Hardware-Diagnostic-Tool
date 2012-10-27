//
//  SingleResultViewController.h
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultView.h"
#import "ResultViewController.h"

@interface SingleResultViewController : UIViewController <ResultViewDelegate>
{
    NSArray *myArray;
    BOOL isManagedObjectProvided;
    NSManagedObject *managedObject;
    UIPopoverController *pop;
    BOOL needHistory;
    ResultViewController *rvc;
}
@property (strong) IBOutlet ResultView *rv;
@property (strong) NSArray *myArray;
@property BOOL isManagedObjectProvided;
@property (strong) NSManagedObject *managedObject;
@property (strong) UIPopoverController *pop;
@property BOOL needHistory;

@end
