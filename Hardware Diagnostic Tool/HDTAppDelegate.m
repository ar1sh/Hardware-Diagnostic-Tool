//
//  HDTAppDelegate.m
//  Hardware Diagnostic Tool
//
//  Created by Aryan Sharifian on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HDTAppDelegate.h"
#import "ScreenTestViewController.h"
#import "LocationMapViewController.h"
#import "MainMotionScreenViewController.h"
#import "SoundFirstViewController.h"
#import "DeviceInfoViewController.h"
#import "Ads.h"

@implementation HDTAppDelegate

@synthesize delegate;
@synthesize currentController, bannerView;

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)AdsPurchased
{
    Ads *ads = [Ads purchaseValue];
    return [ads.purchased boolValue];
}

- (void)updateBanner
{
    if ([self AdsPurchased]) {
        [self.delegate hideBannerView:bannerView];
        bannerView = nil;
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self.delegate showBannerView:banner];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self.delegate hideBannerView:banner];
}

- (CMMotionManager *)motionManager
{
	if (!motionManager) motionManager = [[CMMotionManager alloc] init];
	return motionManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //Application
    if (!tbc) {
        tbc = [[UITabBarController alloc] init];
    }
    
    //iAd banner
    if (![self AdsPurchased]) {
        self.bannerView = [[ADBannerView alloc] init];
        CGRect frame = self.bannerView.frame;
        frame.origin = CGPointMake(CGRectGetMinX([[UIScreen mainScreen] bounds]), CGRectGetMaxY([[UIScreen mainScreen] bounds]));
        bannerView.frame = frame;
        bannerView.delegate = self;
    }
    //Display
    ScreenTestViewController *stvc = [[ScreenTestViewController alloc] init];
    self.delegate = stvc;
    UINavigationController *screenNVC = [[UINavigationController alloc] init];
    [screenNVC pushViewController:stvc animated:NO];
    //Location
    LocationMapViewController *lmvc = [[LocationMapViewController alloc] init];
    UINavigationController *locationNVC = [[UINavigationController alloc] init];
    [locationNVC pushViewController:lmvc animated:NO];
    
    //Motion
    MainMotionScreenViewController *msvc = [[MainMotionScreenViewController alloc] init];
    UINavigationController *motionNVC = [[UINavigationController alloc] init];
    [motionNVC pushViewController:msvc animated:NO];
    
    //Sound
    SoundFirstViewController *sfvc = [[SoundFirstViewController alloc] init];
    UINavigationController *soundNVC = [[UINavigationController alloc] init];
    [soundNVC pushViewController:sfvc animated:NO];
    
    //Device Info
    DeviceInfoViewController *divc = [[DeviceInfoViewController alloc] init];
    UINavigationController *deviceNVC = [[UINavigationController alloc] init];
    [deviceNVC pushViewController:divc animated:NO];
    
    //Main
    screenNVC.delegate = self;
    locationNVC.delegate = self;
    motionNVC.delegate = self;
    soundNVC.delegate = self;
    deviceNVC.delegate = self;
    
    [tbc setViewControllers:[NSArray arrayWithObjects:screenNVC, locationNVC, motionNVC, soundNVC, deviceNVC, nil]];
    
    self.currentController = (UIViewController<BannerViewDelegate> *)((UINavigationController *)tbc.selectedViewController).visibleViewController;
    if ([((UINavigationController *)tbc.selectedViewController).visibleViewController conformsToProtocol:@protocol(BannerViewDelegate)]) {
        self.currentController = (UIViewController <BannerViewDelegate> *)((UINavigationController *)tbc.selectedViewController).visibleViewController;
        //[(UIViewController <BannerViewDelegate> *)((UINavigationController *)tbc.selectedViewController).visibleViewController showBannerView:bannerView];
    }
    
    [self.window addSubview:tbc.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}



- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - UITabBarViewControllerDelegate
/*
- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (currentController == viewController) {
        return;
    }
    if (bannerView.bannerLoaded) {
        [currentController hideBannerView:bannerView];
        [(UIViewController <BannerViewDelegate> *)viewController showBannerView:bannerView];
    }
    
    self.currentController = (UIViewController <BannerViewDelegate>*)viewController;
}
*/
- (void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (currentController == viewController) {
        return;
    }
    if (bannerView.bannerLoaded) {
        
        if ([currentController conformsToProtocol:@protocol(BannerViewDelegate)]) {
            [currentController hideBannerView:bannerView];
        }
        
        if ([viewController conformsToProtocol:@protocol(BannerViewDelegate)]) {
            [(UIViewController <BannerViewDelegate> *)viewController showBannerView:bannerView];
        }
    }
    
    self.currentController = (UIViewController <BannerViewDelegate>*)viewController;
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Hardware_Diagnostic_Tool" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Hardware_Diagnostic_Tool.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
