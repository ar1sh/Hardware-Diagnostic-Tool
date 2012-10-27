//
//  LocationMapViewController.h
//  LocationTest
//
//  Created by Aryan Sharifian on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationDetailsViewController.h"
#import "HDTAppDelegate.h"

@interface LocationMapViewController : UIViewController <MKMapViewDelegate, LocationDetailsViewControllerDelegate, BannerViewDelegate>
{
    MKMapView *mapView;
    NSString *state;
    UIPopoverController *pop;
}

@property (strong) IBOutlet MKMapView *mapView;

@end
