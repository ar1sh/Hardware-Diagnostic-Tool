//
//  ResultViewController.h
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataTableViewController.h"
#import "PixelCheckHistory.h"
#import "ResultView.h"


@interface ResultViewController : CoreDataTableViewController
{
    ResultView *rv;
}

- initInManagedObjectContext:(NSManagedObjectContext *)context;

@end
