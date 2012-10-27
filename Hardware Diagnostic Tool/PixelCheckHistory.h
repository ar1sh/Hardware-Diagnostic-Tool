//
//  PixelCheckHistory.h
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PixelCheckHistory : NSManagedObject {
@private
}

+ (PixelCheckHistory *)pixelHistoryWithArray:(NSArray *)array inContext:(NSManagedObjectContext *)context;
+ (NSArray *)pixelCheckHistoryInContext:(NSManagedObjectContext *)context;
+ (int)countInHistoryWithContext:(NSManagedObjectContext *)context;
+ (NSArray *)pixelCheckHistoryWithGivenManagedObject:(NSManagedObject *)managedObject inContext:(NSManagedObjectContext *)context;

@property (nonatomic, strong) NSDate * Date;
@property (nonatomic, strong) NSNumber * Blue;
@property (nonatomic, strong) NSNumber * Red;
@property (nonatomic, strong) NSNumber * Green;
@property (nonatomic, strong) NSNumber * White;
@property (nonatomic, strong) NSNumber * Black;
@property (nonatomic, strong) NSNumber * HistoryID;


@end
