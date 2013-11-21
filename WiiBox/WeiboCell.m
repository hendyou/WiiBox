//
//  WeiboCell.m
//  WiiBox
//
//  Created by Hendy on 13-9-16.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "WeiboCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WeiboView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "DateUtil.h"
#import "RegexKitLite.h"

@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initViews];
    }
    return self;
}

- (void)dealloc
{
    [_userImage release];
    [_userName release];
    [_repostCount release];
    [_commentCount release];
    [_source release];
    [_createDate release];
    [super dealloc];
}

- (void)initViews
{
    //头像
    _userImage = [[HeaderImageView alloc] initWithFrame:CGRectZero];
    _userImage.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_userImage];
    
    //用户名
    _userName = [[UILabel alloc] initWithFrame:CGRectZero];
    _userName.backgroundColor = [UIColor clearColor];
    _userName.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_userName];
    
    //转发数
    _repostCount = [[UILabel alloc ] initWithFrame:CGRectZero];
    _repostCount.font = [UIFont systemFontOfSize:12];
    _repostCount.backgroundColor = [UIColor clearColor];
    _repostCount.textColor = [UIColor blackColor];
    [self.contentView addSubview:_repostCount];
    
    //评论数
    _commentCount = [[UILabel alloc ] initWithFrame:CGRectZero];
    _commentCount.font = [UIFont systemFontOfSize:12];
    _commentCount.backgroundColor = [UIColor clearColor];
    _commentCount.textColor = [UIColor blackColor];
    [self.contentView addSubview:_commentCount];
    
    //来源
    _source = [[UILabel alloc ] initWithFrame:CGRectZero];
    _source.font = [UIFont systemFontOfSize:12];
    _source.backgroundColor = [UIColor clearColor];
    _source.textColor = [UIColor blackColor];
    [self.contentView addSubview:_source];
    
    //发布时间
    _createDate = [[UILabel alloc ] initWithFrame:CGRectZero];
    _createDate.font = [UIFont systemFontOfSize:12];
    _createDate.backgroundColor = [UIColor clearColor];
    _createDate.textColor = [UIColor blueColor];
    [self.contentView addSubview:_createDate];
    
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboView];
    
    //设置选中背景
    UIView *bg = [[UIView alloc] initWithFrame:CGRectZero];
    bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"statusdetail_cell_sepatator.png"]];
    self.selectedBackgroundView = bg;
    [bg release];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //用户头像
    _userImage.frame = CGRectMake(5, 5, 35, 35);
    _userImage.imageUrl = _weiboModel.user.profile_image_url;
    _userImage.userName = _weiboModel.user.screen_name;
    
    //用户名称
    _userName.frame = CGRectMake(50, 5, 200, 20);
    _userName.text = _weiboModel.user.screen_name;
    
    //微博视图
    _weiboView.frame = CGRectMake(0, _userImage.bottom + 5, ScreenWidth, [WeiboView weiboViewHeight:self.weiboModel isDetail:NO isRepost:NO]);
    _weiboView.weiboModel = self.weiboModel;
    
    //判断系统版本, 6.0之前的版本不会调用WeiboView的layoutsubviews方法
    if (WXHLOSVersion() < 6.0) {
        [_weiboView setNeedsLayout];
    }
    
    //发布日期
    //Tue May 31 17:46:55 +0800 2011
    //from:  E MMM dd HH:mm:ss Z yyyy
    //  to:  MM-dd hh:mm
    if (_weiboModel.createDate != nil) {
        NSString *dateStr = [DateUtil formatDate:@"MM-dd hh:mm" fromSina:_weiboModel.createDate];
        _createDate.frame = CGRectMake(10, self.height - 20, 80, 15);
        _createDate.text = dateStr;
        [_createDate sizeToFit];
        _createDate.hidden = NO;
    } else {
        _createDate.hidden = YES;
    }
    
    //微博来源
    //<a href="http://weibo.com" rel="nofollow">新浪微博</a>
    NSString *source = self.weiboModel.source;
    if (source != nil) {
        _source.frame = CGRectMake(_createDate.right + 10, _createDate.top, 10, 15);
        _source.text = [NSString stringWithFormat:@"来自%@", [self parseSource:source]];
        [_source sizeToFit];
        _source.hidden = NO;
    } else {
        _source.hidden = YES;
    }
    
    //评论数
    _commentCount.text = [NSString stringWithFormat:@"评论:%@", _weiboModel.commentsCount];
    [_commentCount sizeToFit];
    _commentCount.left = self.width - _commentCount.width - 10;
    _commentCount.top = 8;
    
    //转发数
    _repostCount.text = [NSString stringWithFormat:@"转发:%@  |", _weiboModel.repostsCount];
    [_repostCount sizeToFit];
    _repostCount.right = _commentCount.left - 5;
    _repostCount.top = 8;
    
}

- (NSString *)parseSource:(NSString *)source
{
    NSString *regex = @">.*<";
    NSArray *matchArray = [source componentsMatchedByRegex:regex];
    if (matchArray.count > 0) {
        source = matchArray[0];
        NSRange range = {1, source.length - 2};
        source = [source substringWithRange:range];
        return source;
    }
    return  nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
