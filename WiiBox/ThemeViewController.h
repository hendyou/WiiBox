//
//  ThemeViewController.h
//  WiiBox
//
//  Created by Hendy on 13-9-13.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "BaseViewController.h"

@interface ThemeViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    @private
    NSArray *_themeArray;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSIndexPath *currentChecked;

@end
