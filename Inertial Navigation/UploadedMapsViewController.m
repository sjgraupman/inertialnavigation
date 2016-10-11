//
//  UploadedMapsViewController.m
//  Inertial Navigation
//
//  Created by Kristen Kozmary on 10/3/16.
//  Copyright © 2016 koz. All rights reserved.
//

#import "UploadedMapsViewController.h"

@interface UploadedMapsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UploadedMapsViewController

//UITableView *tableView = [[UITableView alloc] init];

//tableView.delegate = self;
//tableView.dataSource = self;
//[_mapsTable UITableViewCell.self forCellReuseIdentifier:@"mapsCell" ];
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 4;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //UITableViewCell *cell = [mapsTable dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
 // return cell;
//}

@end
