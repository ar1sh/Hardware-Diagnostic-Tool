//
//  Ads.m
//  Tehran Metro Ultimate Guide
//
//  Created by Aryan Sharifian on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Ads.h"
#import "HDTAppDelegate.h"

@implementation Ads

@dynamic purchased;

+ (Ads *)purchaseValueInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Ads" inManagedObjectContext:context];
    Ads *ads = [[context executeFetchRequest:request error:NULL] lastObject];
    if (!ads) {
        ads = [NSEntityDescription insertNewObjectForEntityForName:@"Ads" inManagedObjectContext:context];
        ads.purchased = [NSNumber numberWithBool:NO];
    }
    return ads;
}

+ (NSManagedObjectContext *)managedObjectContext
{
    HDTAppDelegate *appDelegate = (HDTAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context;
    if ([appDelegate respondsToSelector:@selector(managedObjectContext)]) {
        context = [appDelegate managedObjectContext];
    }
    return context;
}

+ (Ads *)purchaseValue
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Ads" inManagedObjectContext:[self managedObjectContext]];
    Ads *ads = [[[self managedObjectContext] executeFetchRequest:request error:NULL] lastObject];
    if (!ads) {
        ads = [NSEntityDescription insertNewObjectForEntityForName:@"Ads" inManagedObjectContext:[self managedObjectContext]];
        ads.purchased = [NSNumber numberWithBool:NO];
    }
    return ads;
}

@end
