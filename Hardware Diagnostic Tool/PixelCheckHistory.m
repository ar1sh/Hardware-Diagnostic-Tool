//
//  PixelCheckHistory.m
//  iOS Diagnostic
//
//  Created by Aryan Sharifian on 10/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PixelCheckHistory.h"


@implementation PixelCheckHistory

+ (int)countInHistoryWithContext:(NSManagedObjectContext *)context
{
    NSArray *ph = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"PixelCheckHistory" inManagedObjectContext:context];
    ph = [context executeFetchRequest:request error:NULL];
    return ph.count;
}

+ (NSNumber *)boolNumberForString:(NSString *)s
{
    if (s == @"YES")
    {
        return [NSNumber numberWithInt:1];
    }
    else
    {
        return [NSNumber numberWithInt:0];
    }
}

+ (PixelCheckHistory *)pixelHistoryWithArray:(NSArray *)array inContext:(NSManagedObjectContext *)context
{
    PixelCheckHistory *ph = nil;
    
    ph = [NSEntityDescription insertNewObjectForEntityForName:@"PixelCheckHistory" inManagedObjectContext:context];
    
    ph.HistoryID = [NSNumber numberWithInt:[self countInHistoryWithContext:context]];
    ph.Black = [self boolNumberForString:[array objectAtIndex:1]];
    ph.White = [self boolNumberForString:[array objectAtIndex:2]];
    ph.Red = [self boolNumberForString:[array objectAtIndex:3]];
    ph.Blue = [self boolNumberForString:[array objectAtIndex:4]];
    ph.Green = [self boolNumberForString:[array objectAtIndex:5]];
    ph.Date = [NSDate date];
    
    return ph;
}

+ (NSArray *)pixelCheckHistoryInContext:(NSManagedObjectContext *)context
{
    NSArray *array = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"PixelCheckHistory" inManagedObjectContext:context];
    request.predicate = nil;
    NSError *error;
    array = [context executeFetchRequest:request error:&error];
    return array;
}

+ (NSArray *)pixelCheckHistoryWithGivenManagedObject:(NSManagedObject *)managedObject inContext:(NSManagedObjectContext *)context
{
    NSArray *array = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"PixelCheckHistory" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"Date = %@", [managedObject valueForKey:@"Date"]];
    NSError *error;
    array = [context executeFetchRequest:request error:&error];
    return array;
}

@dynamic Date;
@dynamic Blue;
@dynamic Red;
@dynamic Green;
@dynamic White;
@dynamic Black;
@dynamic HistoryID;


@end
