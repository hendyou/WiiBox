//
//  DetailViewController.h
//  WiiBox
//
//  Created by Hendy on 13-9-24.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "BaseViewController.h"

#import "WeiboModel.h"
#import "CommentTableView.h"
#import "HeaderImageView.h"

@class WeiboView;

@interface DetailViewController : BaseViewController<UITableViewEventDelegate>
{
    @private
    WeiboView *_weiboView;
    CommentTableView *_tableView;
}

@property (retain, nonatomic) WeiboModel *weiboModel;

@property (copy, nonatomic) NSString *lastId;

@property (retain, nonatomic) IBOutlet UIView *userInfoBar;
@property (retain, nonatomic) IBOutlet HeaderImageView *userHeaderView;
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;

@end
