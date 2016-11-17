//
//  Gyroscope.m
//  Inertial Navigation
//
//  Created by Kristen Kozmary on 11/14/16.
//  Copyright © 2016 koz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gyroscope.h"


@interface Gyroscope ()

-(void)startMotionManager;
-(void)stopMotionManager;

@end


@implementation Gyroscope

@synthesize isAccelerometerActive, frequency;

static Gyroscope *sharedSingleton;

+(Gyroscope *)sharedInstance {
  
  return sharedSingleton;
}


+ (void)initialize
{

  static BOOL initialized = NO;
  
  if(!initialized)
  {
    initialized = YES;
    sharedSingleton = [[Gyroscope alloc] init];
  }
}


-(id)init {
  
  self = [super init];
  
  if (self != nil) {
    
    motionManager = [[CMMotionManager alloc] init];
    
    accelerometerListeners = [[NSMutableSet alloc] initWithCapacity:3];
    
    timestampOffsetInitialized = NO;
    
    isMotionManagerActive = NO;
    
    //gyroscope available?
    if ((isAvailable = [motionManager isDeviceMotionAvailable])) {
      
      self.frequency = 1.0 / 60;
      
    } else {
      
      [motionManager release];
      motionManager = nil;
    }
    
    pollingTimer = nil;
  }
  
  return self;
}


-(void)dealloc {
  [self stop];
  
  if (motionManager) [motionManager release];
  
  [accelerometerListeners release];
  [super dealloc];
}

#pragma mark -
#pragma mark methods used by Accelerometer if it acts as a dummy


-(void)addAccelerometerListener:(id <SensorListener>)listener {
  
  //mutex to allow listener adding/removing while sensors are running
  //we are using Gyroscope's mutex here, as it is used in the callback
  dispatch_semaphore_wait(listenersSemaphore, DISPATCH_TIME_FOREVER);
  
  [accelerometerListeners addObject:listener];
  
  dispatch_semaphore_signal(listenersSemaphore);
}

-(void)removeAccelerometerListener:(id<SensorListener>)listener {
  
  dispatch_semaphore_wait(listenersSemaphore, DISPATCH_TIME_FOREVER);
  
  [accelerometerListeners removeObject:listener];
  
  dispatch_semaphore_signal(listenersSemaphore);
}

-(void)removeAllAccelerometerListeners {
  
  dispatch_semaphore_wait(listenersSemaphore, DISPATCH_TIME_FOREVER);
  
  [accelerometerListeners removeAllObjects];
  
  dispatch_semaphore_signal(listenersSemaphore);
}

-(void)startAccelerometer {
  
  if (isAvailable) {
    
    isAccelerometerActive = YES;
    if (!isActive) [self startMotionManager];
  }
  
  
}

-(void)stopAccelerometer {
  
  if (isAvailable) {
    
    isAccelerometerActive = NO;
    [self stopMotionManager];
  }
  
  
}

#pragma mark -
#pragma mark sensor methods


-(void)actuallyStart {
  
  if (isAvailable) {
    
    isActive = YES;
    if (!isAccelerometerActive) [self startMotionManager];
  }
}


-(void)actuallyStop {
  
  if (isAvailable) {
    
    isActive = NO;
    [self stopMotionManager];
  }
}

-(BOOL)isActive {
  
  return isAvailable && [motionManager isDeviceMotionActive];
}

-(void)setFrequency:(int)_frequency {
  
  if (_frequency > 0) {
    
    frequency = _frequency;
    
    /*
     * We dispatch the restarting of the timer for later, as testing has
     * shown that - for reasons unknown - the app would stall if resuming
     * from background and this method being called due to changes in frequncy.
     */
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      
      if (self.isActive) {
        
        //restart the timer
        [pollingTimer invalidate];
        pollingTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / frequency)
                                                        target:self
                                                      selector:@selector(captureDeviceMotion)
                                                      userInfo:nil
                                                       repeats:YES];
      }
    });
  }
}


-(void)startMotionManager {
  
  //should at least one sensor (acc or gyro) be on?
  if (isAvailable && (isAccelerometerActive || isActive)) {
    
    if (!isMotionManagerActive) {//instead of buggy !([motionManager.isDeviceMotionActive])...
      
      isMotionManagerActive = YES;
      
      //let the motion manage sample at 100Hz, actual polling might be lower
      motionManager.deviceMotionUpdateInterval = 1.0 / 100;
      
      [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
      //            CMAttitudeReferenceFrameXTrueNorthZVertical];
      
      [pollingTimer invalidate];
      pollingTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / frequency)
                                                      target:self
                                                    selector:@selector(captureDeviceMotion)
                                                    userInfo:nil
                                                     repeats:YES];
    }
  }
}


-(void)captureDeviceMotion {
  
  CMDeviceMotion *motion = motionManager.deviceMotion;
  
  if (motion) {
    
    if (!timestampOffsetInitialized) {
      
      timestampOffsetFrom1970 = [self getTimestamp] - motion.timestamp;
      timestampOffsetInitialized = YES;
    }
    
    NSTimeInterval timestamp = motion.timestamp + timestampOffsetFrom1970;
    if (isActive) {
      
      id<SensorListener> listener;
      for (listener in listeners) {
        
        [listener didReceiveDeviceMotion:motion
                               timestamp:timestamp];
      }
      
    }
  }
}

-(void)stopMotionManager {
  
  //stop only if accelerometer AND gyroscope should be off
  if (isAvailable && !isAccelerometerActive && !isActive) {
    
    [pollingTimer invalidate];
    pollingTimer = nil;
    
    [motionManager stopDeviceMotionUpdates];
    
    isMotionManagerActive = NO;
    timestampOffsetInitialized = NO;
  }
  
}


@end
