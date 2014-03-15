//
//  LocationViewController.m
//  WiiBox
//
//  Created by Hendy Ou on 13-11-25.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "LocationViewController.h"
#import "UIImageView+WebCache.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"附近";
        NSLog(@"------------ LocationViewController init");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _indicatorView = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
    _indicatorView.labelText = @"正在定位...";
    _tableView.hidden = YES;
    
    [self locate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)dealloc {
    [_indicatorView release];
    [_tableView release];
    [_locationManager release];
    [_location release];
    [_data release];
    [super dealloc];
}

#pragma mark - Data
- (void)loadLocations
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [@(_location.coordinate.longitude) stringValue], @"long",
                                [@(_location.coordinate.latitude) stringValue], @"lat",
                                nil];
    [self.sinaweibo requestWithURL:@"place/nearby/pois.json" params:dic httpMethod:@"GET" finished:^(id result) {
        NSDictionary *resultDic = result;
        _data = [resultDic[@"pois"] retain];
        if (_data.count > 0) {
            [_tableView reloadData];
            _tableView.hidden = NO;
            [_indicatorView hide:YES];
        }
    }];
}

#pragma mark - Location
- (void)locate
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//    [_locationManager startUpdatingLocation];
    
    _location = [[CLLocation alloc] initWithLatitude:22.9545000 longitude:113.23161700];
    [self loadLocations];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    NSLog(@"--------- %@", locations);
    if (_location == nil) {
        _location = [[locations lastObject] retain];
        [manager stopUpdatingLocation];
        
        [self loadLocations];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error != nil) {
        NSLog(@"%@", error);
        [_locationManager stopUpdatingLocation];
        
        UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle: nil message: @"无法定位" delegate: self cancelButtonTitle: @"确定" otherButtonTitles: nil];
        [alertDialog show];
        [alertDialog release];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
        [cell autorelease];
    }
    
    NSDictionary *loc = _data[indexPath.row];
    cell.textLabel.text = loc[@"title"];
    cell.detailTextLabel.text = loc[@"address"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:loc[@"icon"]]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.locationSelectedBlock) {
        NSDictionary *loc = _data[indexPath.row];
        self.locationSelectedBlock(loc);
        Block_release(self.locationSelectedBlock);
        self.locationSelectedBlock = nil;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
