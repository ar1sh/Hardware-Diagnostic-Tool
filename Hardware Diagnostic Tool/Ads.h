//
//  Ads.h
//  Tehran Metro Ultimate Guide
//
//  Created by Aryan Sharifian on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Ads : NSManagedObject

@property (nonatomic, retain) NSNumber * purchased;

+ (Ads *)purchaseValueInManagedObjectContext:(NSManagedObjectContext *)context;
+ (Ads *)purchaseValue;

@end