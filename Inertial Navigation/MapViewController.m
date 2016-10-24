//
//  ViewController.m
//  Inertial Navigation
//
//  Created by Kristen Kozmary on 10/3/16.
//  Copyright © 2016 koz. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()
@property (retain, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
  [super viewDidLoad];
 
  _mapView = [[MKMapView alloc] init];
  _mapView.showsUserLocation = YES;
  _mapView.mapType = MKMapTypeStandard;
  _mapView.delegate = self;
  [self.view addSubview:_mapView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  MKCoordinateRegion region;
  MKCoordinateSpan span;
  span.latitudeDelta = 0.5;
  span.longitudeDelta = 0.5;
  CLLocationCoordinate2D location;
  location.latitude = userLocation.coordinate.latitude;
  location.longitude = userLocation.coordinate.longitude;
  region.span = span;
  region.center = location;
  [mapView setRegion:region animated:YES];
}





@end
