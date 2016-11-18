//
//  Gyroscope.h
//  Inertial Navigation
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CMMotionManager.h>



@interface Gyroscope : AbstractSensor {
  
  CMMotionManager *motionManager;
  
  NSMutableSet *accelerometerListeners;
  BOOL isAccelerometerActive;
  BOOL isMotionManagerActive;
  NSTimeInterval timestampOffsetFrom1970;
  BOOL timestampOffsetInitialized;
  
  NSTimer *pollingTimer;
}

@property(nonatomic,readonly) BOOL isAccelerometerActive;
@property(nonatomic) int frequency;

//singleton pattern
+(Gyroscope *)sharedInstance;
-(void)actuallyStart;
-(void)actuallyStop;

//methods called by Accelerometer if it acts as a dummy
-(void)startAccelerometer;
-(void)stopAccelerometer;
-(void)addAccelerometerListener:(id <SensorListener>)listener;
-(void)removeAccelerometerListener:(id<SensorListener>)listener;
-(void)removeAllAccelerometerListeners;

@end
