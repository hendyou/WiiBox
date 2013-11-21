//
//  WeiboCell.h
//  WiiBox
//
//  Created by Hendy on 13-9-16.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HeaderImageView.h"

@class WeiboModel;
@class WeiboView;

@interface WeiboCell : UITableViewCell
{
    @private
    HeaderImageView *_userImage;    //用户头像
    UILabel *_userName;  //用户名称
    UILabel *_repostCount;    //转发数
    UILabel *_commentCount;  //评论数
    UILabel *_source;    //发布来源
    UILabel *_createDate;    //发布时间
    
}

@property (retain, nonatomic) WeiboModel *weiboModel;
@property (retain, nonatomic) WeiboView *weiboView;

@end
