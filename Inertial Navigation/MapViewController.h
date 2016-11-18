//
//  ViewController.h
//  Inertial Navigation
//
//  Created by Kristen Kozmary on 10/3/16.
//  Copyright © 2016 koz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@import GoogleMaps;

@interface MapViewController : UIViewController <GMSMapViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@end

