//
//  AppState.h
//  Inertial Navigation
//
//  Created by Kristen Kozmary on 10/8/16.
//  Copyright © 2016 koz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppState : NSObject

+ (AppState *)sharedInstance;

@property (nonatomic) BOOL signedIn;
@property (nonatomic, retain) NSString *displayName;

@end
