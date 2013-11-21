//
//  CommentCell.m
//  WiiBox
//
//  Created by Hendy on 13-9-25.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "CommentCell.h"
#import "RTLabel.h"
#import "NSString+URLEncoding.h"
#import "DateUtil.h"
#import "ImageUtil.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _commentLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _commentLabel.delegate = self;
    _commentLabel.font = [UIFont systemFontOfSize:14.0f];
    _commentLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
    _commentLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"red" forKey:@"color"];
    [self addSubview:_commentLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //头像
    _userHeaderView.imageUrl = self.commentModel.user.profile_image_url;
    _userHeaderView.userName = self.commentModel.user.screen_name;
    
    //昵称
    _userNameLabel.text = self.commentModel.user.screen_name;
    
    //时间
    NSString *dateStr = [DateUtil formatDate:@"MM-dd hh:mm" fromSina:_commentModel.created_at];
    _timeLabel.text = dateStr;
    
    _commentLabel.frame = CGRectMake(_userNameLabel.left, _userNameLabel.bottom + 5, 250, 0);
    _commentLabel.text = self.commentModel.text;
    _commentLabel.height = [_commentLabel optimumSize].height;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_commentLabel release];
    
    [_userHeaderView release];
    [_userNameLabel release];
    [_timeLabel release];
    [super dealloc];
}

#pragma mark - Public methods
+ (float)cellHdight:(CommentModel *)comment
{
    float height = 31;//昵称的高度+top距离
    
    RTLabel *text = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 250, 0)];
    text.text = comment.text;
    height += [text optimumSize].height;
    
    height += 10;
    
    return height;
}

#pragma mark - RTLabelDelegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSString *absoluteString = [url absoluteString];
    if ([absoluteString hasPrefix:@"user"]) {
        NSString *host = [[url host] URLDecodedString];
        NSLog(@"用户: %@", host);
        
    } else if ([absoluteString hasPrefix:@"http"]) {
        NSLog(@"%@", absoluteString);
    } else if ([absoluteString hasPrefix:@"topic"]) {
        NSString *host = [[url host] URLDecodedString];
        NSLog(@"话题: %@", host);
    }
}
@end
