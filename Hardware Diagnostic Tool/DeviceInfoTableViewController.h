//
//  DeviceInfoTableViewController.h
//  Hardware Diagnostic Tool
//
//  Created by Aryan Sharifian on 10/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "HDTAppDelegate.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <stdio.h>
#import <string.h>
#import <mach/mach_host.h>
#import <sys/sysctl.h>

@interface DeviceInfoTableViewController : UITableViewController <BannerViewDelegate>
{
}

@end
