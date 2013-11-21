//
//  WeiboView.h
//  WiiBox
//
//  Created by Hendy on 13-9-16.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
@class ThemeImageView;

#define kWeiboWidth ScreenWidth - 20
#define kImageHeight 80
#define kImageBigHeight 160
#define kImageDetailHeight 200

@class WeiboModel;

@interface WeiboView : UIView<RTLabelDelegate>
{
    @private
    RTLabel *_textLabel;    //微博内容
    UIImageView *_imageView;    //微博图片
    ThemeImageView *_retweetedBackgroundView; //转发的微博视图背景
    WeiboView *_retweetedView;   //转发微博视图
    NSMutableString *_parseText;
}

@property (retain, nonatomic) WeiboModel *weiboModel;

//是否转发的微博
@property (assign, nonatomic) BOOL isRetweeted;

//是否显示在详情页面
@property (assign, nonatomic) BOOL isDetail;

//计算微博视图的高度
+ (CGFloat) weiboViewHeight:(WeiboModel *) weiboModel
                   isDetail:(BOOL)isDetail
                   isRepost:(BOOL) isRepost;

//获取字体
+ (float)fontSize:(BOOL)isDetail isRepost:(BOOL)isRepost;

@end
