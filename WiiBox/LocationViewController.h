//
//  LocationViewController.h
//  WiiBox
//
//  Created by Hendy Ou on 13-11-25.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface LocationViewController : BaseViewController <UITableViewDataSource, CLLocationManagerDelegate, UIAlertViewDelegate>
{
    @private
    MBProgressHUD *_indicatorView;
    NSArray *_data;
    CLLocation *_location;
    
    CLLocationManager *_locationManager;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
