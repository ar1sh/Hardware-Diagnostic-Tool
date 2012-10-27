//
//  HDTAppDelegate.h
//  Hardware Diagnostic Tool
//
//  Created by Aryan Sharifian on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <iAd/iAd.h>

@protocol BannerViewDelegate <NSObject>

- (void)showBannerView:(ADBannerView *)banner;
- (void)hideBannerView:(ADBannerView *)banner;

@end

@interface HDTAppDelegate : UIResponder <UIApplicationDelegate, ADBannerViewDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate>
{
    UITabBarController *tbc;
	CMMotionManager *motionManager;
    id <BannerViewDelegate> delegate;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong) id <BannerViewDelegate> delegate;
@property (strong) UIViewController <BannerViewDelegate> *currentController;
@property (strong) ADBannerView *bannerView;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (unsafe_unretained, readonly) CMMotionManager *motionManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)AdsPurchased;
- (void)updateBanner;

@end
