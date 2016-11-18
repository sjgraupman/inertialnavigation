//@import CoreMotion;
#import <CoreMotion/CoreMotion.h>
#import "PedoemeterViewController.h"

@interface PedoemeterViewController()

@property(strong,nonatomic) CMPedometer *pedometer;
@property(strong,nonatomic) NSMutableArray *stepCountLog;

@end

@implementation PedoemeterViewController

-(void) viewDidLoad {
	[super viewDidLoad];
	
	self.pedometer = [[CMPedometer alloc] init];
	// [self startQueryingPedometer];
	// self.stepCountLog = [[NSMutableArray alloc] initWithCapacity: 40];
	
	
//	if ([CMPedometer isDistanceAvailable]) {
//		self.pedometer = [[CMPedometer alloc] init];
//  } else {
//    //NSLog(@"%@", error.localizedDescription);
//  }
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
  [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData *pedometerData, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      
      NSLog(@"data:%@, error:%@", pedometerData, error);
    });
  }];
}


-(void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}
			

-(void) stopQueryingPedometer {
	[self.pedometer stopPedometerUpdates];
	[self.stepCountLog removeAllObjects];
}
	


@end
