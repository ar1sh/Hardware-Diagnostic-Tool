//
//  LocationDetailsViewController.h
//  LocationTest
//
//  Created by Aryan Sharifian on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class LocationDetailsViewController;

@protocol LocationDetailsViewControllerDelegate

- (CLLocation * )coordinates:(LocationDetailsViewController *)ldvc;

@end

@interface LocationDetailsViewController : UIViewController
{
    id <LocationDetailsViewControllerDelegate> __unsafe_unretained delegate;
}

@property (unsafe_unretained) id <LocationDetailsViewControllerDelegate> delegate;

@property (strong) IBOutlet UILabel *latitute;
@property (strong) IBOutlet UILabel *longitute;
@property (strong) IBOutlet UILabel *speed;
@property (strong) IBOutlet UILabel *atitute;
@property (strong) IBOutlet UILabel *accracy;

@end
