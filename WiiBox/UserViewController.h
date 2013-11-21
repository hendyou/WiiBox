//
//  UserViewController.h
//  WiiBox
//
//  Created by Hendy on 13-10-1.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "BaseViewController.h"
#import "UserModel.h"

@class WeiboTableView;
@class UserInfoView;

@interface UserViewController : BaseViewController
{
    @private
    UserInfoView *_userInfoView;
}

@property (copy, nonatomic) NSString *userName;

@property (retain, nonatomic) UserModel *user;

@property (retain, nonatomic) IBOutlet WeiboTableView *tableView;

@end
