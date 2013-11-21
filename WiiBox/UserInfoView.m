//
//  UserInfoView.m
//  WiiBox
//
//  Created by Hendy on 13-10-1.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "UserInfoView.h"
#import "ImageUtil.h"
#import "UIImageView+WebCache.h"

@implementation UserInfoView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"UserInfoView" owner:self options:nil];
        if (views.count > 0) {
            UIView *view = views[0];
            [self addSubview:view];
            self.size = view.size;
            self.clipsToBounds = YES;
        }
        [self initViews];
    }
    return self;
}

- (void)dealloc {
    [_user release];
    
    [_userImage release];
    [_userName release];
    [_sexAndCity release];
    [_introduction release];
    
    [_fansBtn release];
    [_attentionBtn release];
    [_infoBtn release];
    [_moreBtn release];
    
    [_weiboCountLabel release];
    [super dealloc];
}

- (void)setUser:(UserModel *)user
{
    if (_user != user) {
        [_user release];
        _user = [user retain];
        
        [self updateUserData];
    }
}

#pragma mark - UI
- (void)initViews
{
    CGRect userImageFrame = self.userImage.frame;
    userImageFrame.size = CGSizeMake(80, 80);
    self.userImage.frame = userImageFrame;
    self.userImage.contentMode = UIViewContentModeScaleAspectFill;
    self.userImage.clipsToBounds = YES;
    [ImageUtil fillet:self.userImage];
    
    self.attentionBtn.title = @"关注";
    self.fansBtn.title = @"粉丝";
    self.infoBtn.title = @"资料";
    self.moreBtn.title = @"更多";
}

#pragma mark - Data
- (void)updateUserData
{
    if (_user != nil) {
        //头像
        [self.userImage setImageWithURL:[NSURL URLWithString:_user.avatar_large]];
        //个人信息
        self.userName.text = _user.screen_name;
        
        NSMutableString *sexCity = [NSMutableString string];
        [sexCity appendString:_user.sex];
        [sexCity appendString:[NSString stringWithFormat:@" %@", _user.location]];
        self.sexAndCity.text = sexCity;
        
        self.introduction.text = _user.description;
        
        //关注数
        if (_user.friends_count != nil) {
            int friendsCount = [_user.friends_count intValue];
            NSString *friendsCountStr = [NSString stringWithFormat:@"%d", friendsCount];
            if (friendsCount >= 10000) {
                friendsCountStr = [NSString stringWithFormat:@"%.0f万", friendsCount/10000.0];
            }
            self.attentionBtn.subTitle = friendsCountStr;
        }
        
        //粉丝数
        if (_user.followers_count != nil) {
            int followersCount = [_user.followers_count intValue];
            NSString *followersCountStr = [NSString stringWithFormat:@"%d", followersCount];
            if (followersCount >= 10000) {
                followersCountStr = [NSString stringWithFormat:@"%.0f万", followersCount/10000.0];
            }
            self.fansBtn.subTitle = followersCountStr;
        }
        
        //微博数
        if (_user.statuses_count != nil) {
            int weiboCount = [_user.statuses_count intValue];
            NSString *weiboCountStr = [NSString stringWithFormat:@"%d", weiboCount];
            if (weiboCount >= 10000) {
                weiboCountStr = [NSString stringWithFormat:@"%.1f万", weiboCount/10000.0];
            }
            self.weiboCountLabel.text = [NSString stringWithFormat:@"%@条微博", weiboCountStr];
        }

    }
}

#pragma mark - On click
- (void)attentionClick
{
    NSLog(@"---------");
}

@end
