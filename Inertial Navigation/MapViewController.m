//
//  ViewController.m
//  Inertial Navigation
//
//  Created by Kristen Kozmary on 10/3/16.
//  Copyright © 2016 koz. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController () <GMSMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation MapViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
   // [self.mapView addObserver:self forKeyPath:@"myLocation" options:0 context:nil];
}


//- (void)enableMyLocation
//{
//  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
  
 // if (status == kCLAuthorizationStatusNotDetermined)
 //   [self requestLocationAuthorization];
 // else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted)
 //   return; // we weren't allowed to show the user's location so don't enable
//  else
 //   [self.mapView setMyLocationEnabled:YES];
//}


   // myLocation *location;
   // GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: 51.5 longitude: -.127 zoom:6];
    //GMSMapView *mapView = [GMSMapView mapWithFrame: CGRectZero camera:camera];
   // mapView.myLocationEnabled = YES;
    //self.view = mapView;
    //mapView.myLocationEnabled = YES;
   // location = mapView.myLocation;
    
    //[_mapView addObserver:self
     //          forKeyPath:@"myLocation"
     //             options:NSKeyValueObservingOptionNew
      //            context:NULL];

    
    

    
    
    -(void)loadView {
      _mapView.myLocationEnabled = YES;
      [self.locationManager startUpdatingLocation];
    }


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray*)locations {
  CLLocation *newLocation = [locations lastObject];
  
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: newLocation.coordinate.latitude longitude: newLocation.coordinate.longitude zoom:6];
  [_mapView animateToCameraPosition:camera];
}
    
    
    //GMSMarker *marker = [[GMSMarker alloc] init];
   //marker.position = CLLocationCoordinate2DMake(51.5, -.127);
    //marker.position = mapView.myLocation;
    //marker.title = @"London";
   // marker.snippet = @"England";
   // marker.map = mapView;










- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}







@end
