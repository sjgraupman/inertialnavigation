//
//  Measurements.h
//  Inertial Navigation
//
//  Created by Kristen Kozmary on 10/9/16.
//  Copyright © 2016 koz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Measurements : NSObject
+ (void)sendLoginEvent;
+ (void)sendLogoutEvent;
+ (void)sendMessageEvent;
@end
