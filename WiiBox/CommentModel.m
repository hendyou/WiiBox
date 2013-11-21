//
//  CommentModel.m
//  WiiBox
//
//  Created by Hendy on 13-9-25.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    
    NSDictionary *userDic = dataDic[@"user"];
    if (userDic != nil) {
        UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
        self.user = user;
        [user release];
    }
    
    NSDictionary *weiboDic = dataDic[@"status"];
    if (weiboDic != nil) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:weiboDic];
        self.status = weibo;
        [weibo release];
    }
    
    NSDictionary *commentDic = dataDic[@"reply_comment"];
    if (commentDic != nil) {
        CommentModel *comment = [[CommentModel alloc] initWithDataDic:commentDic];
        self.reply_comment = comment;
        [comment release];
    }
}

@end
