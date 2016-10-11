//
//  AppState.m
//  Inertial Navigation
//
//  Created by Kristen Kozmary on 10/8/16.
//  Copyright © 2016 koz. All rights reserved.
//

#import "AppState.h"

@implementation AppState

+ (AppState *)sharedInstance {
  static AppState *sharedObject = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedObject = [[self alloc] init];
  });
  return sharedObject;
}

@end
