//
//  UserInfoView.h
//  WiiBox
//
//  Created by Hendy on 13-10-1.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserInfoButton.h"
#import "UserModel.h"

@interface UserInfoView : UIView

@property (retain, nonatomic) UserModel *user;

@property (retain, nonatomic) IBOutlet UIImageView *userImage;
@property (retain, nonatomic) IBOutlet UILabel *userName;
@property (retain, nonatomic) IBOutlet UILabel *sexAndCity;
@property (retain, nonatomic) IBOutlet UILabel *introduction;

@property (retain, nonatomic) IBOutlet UserInfoButton *attentionBtn;
@property (retain, nonatomic) IBOutlet UserInfoButton *fansBtn;
@property (retain, nonatomic) IBOutlet UserInfoButton *infoBtn;
@property (retain, nonatomic) IBOutlet UserInfoButton *moreBtn;

@property (retain, nonatomic) IBOutlet UILabel *weiboCountLabel;
@end
