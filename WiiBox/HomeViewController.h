//
//  HomeViewController.h
//  WiiBox
//  首页控制器

//  Created by Hendy on 13-9-11.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableView.h"
#import "WeiboTableView.h"

@class ThemeImageView;

@interface HomeViewController : BaseViewController <SinaWeiboRequestDelegate,WeiboTableViewDelegate>
{
    WeiboTableView *_tableView;
    ThemeImageView *_weiboCountView;
    UILabel *_countLabel;
}

@property (copy, nonatomic) NSString *topId;
@property (copy, nonatomic) NSString *lastId;

- (void)initLoading;
- (void)loadData;

@end
