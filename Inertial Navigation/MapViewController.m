//
//  ViewController.m
//  Inertial Navigation
//
//  Created by Kristen Kozmary on 10/3/16.
//  Copyright © 2016 koz. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <CoreMotion/CoreMotion.h>
@import GoogleMaps;

@interface MapViewController () 

@property (nonatomic, strong) GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *viewForMap;
@property(strong,nonatomic) CMPedometer *pedometer;
@property(strong,nonatomic) NSMutableArray *stepCountLog;
@property (atomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) IBOutlet UIButton *tracking;
- (IBAction)getCurrentLocation:(id)sender;
@end

@implementation MapViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  

	self.pedometer = [[CMPedometer alloc] init];
  CLLocation* myLoc = _mapView.myLocation;
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:myLoc.coordinate.latitude longitude:myLoc.coordinate.longitude zoom:15];
  self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  //self.mapView.myLocationEnabled = YES;
  self.mapView.settings.myLocationButton = YES;

  [self.viewForMap addSubview:self.mapView];
  
  
//  GMSMarker *marker = [[GMSMarker alloc] init];
//  marker.position = CLLocationCoordinate2DMake(43.0386, -87.9309);
//  marker.title = @"Marquette University";
//  marker.snippet = @"Wisconsin";
//  marker.map = self.mapView;
  
  
  self.mapView.delegate = self;
  _locationManager.delegate = self;
  [_locationManager requestWhenInUseAuthorization];
  

  
  [_mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
  dispatch_async(dispatch_get_main_queue(), ^{
    _mapView.myLocationEnabled = YES;
  });
  
  
  
  
  
 }
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
    [_locationManager startUpdatingLocation];
    _mapView.myLocationEnabled = YES;
    _mapView.settings.myLocationButton = YES;
  }
  
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
  CLLocation *newLocation = [locations lastObject];
  _mapView.camera = GMSCameraPosition(target: newLocation.coordinate.latitude)
}


-(IBAction)didTapStartTracking:(id)sender {
  
  [_tracking setTitle:@"Start" forState:UIControlStateNormal];
  [_tracking setTitle:@"Stop" forState:UIControlStateSelected];
  [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData *pedometerData, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      
      NSLog(@"data:%@, error:%@", pedometerData, error);
    });
  }];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

//  if (!firstLocationUpdate) {
//    
//  }
  
  
//  if([keyPath isEqualToString:@"myLocation"]) {
//    CLLocation *location = [object myLocation];
//    //...
//    NSLog(@"Location, %@,", location);
//    
//    CLLocationCoordinate2D target =
//    CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
//
//  }
//}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if([keyPath isEqualToString:@"myLocation"]) {
    CLLocation *location = [object myLocation];
    //...
    NSLog(@"Location, %@,", location);
    
    CLLocationCoordinate2D target =
    CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    [self.mapView animateToLocation:target];
    [self.mapView animateToZoom:17];
  }
}





- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)getCurrentLocation:(id)sender {
  _locationManager.delegate = self;
  _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  [_locationManager startUpdatingLocation];
  CLLocation *location = [_mapView myLocation];
  //...
  NSLog(@"Location, %@,", location);
  
  CLLocationCoordinate2D target =
  CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
  
  [self.mapView animateToLocation:target];
  [self.mapView animateToZoom:17];
  
  
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"didFailWithError: %@", error);

}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
  [_mapView animateToLocation:newLocation.coordinate];
  
}



@end
