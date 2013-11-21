//
//  ScanModeViewController.h
//  WiiBox
//
//  Created by Hendy on 13-9-29.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "BaseViewController.h"

@interface ScanModeViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    @private
    NSArray *_modes;
}

@property (retain, nonatomic) NSIndexPath *currentChecked;

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
