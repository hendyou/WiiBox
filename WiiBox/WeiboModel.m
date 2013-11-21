//
//  WeiboModel.m
//  WiiBox
//
//  Created by Hendy on 13-9-15.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "WeiboModel.h"
#import "UserModel.h"

@implementation WeiboModel

- (NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapDic = @{
                             @"createDate": @"created_at",
                             @"id": @"id",
                             @"text": @"text",
                             @"source": @"source",
                             @"favorited": @"favorited",
                             @"thumbnailPic": @"thumbnail_pic",
                             @"bmiddlePic": @"original_pic",
                             @"originalPic": @"original_pic",
                             @"geo": @"geo",
                             @"repostsCount": @"reposts_count",
                             @"commentsCount": @"comments_count"
                             };
    return mapDic;
}

- (void)setAttributes:(NSDictionary *)dataDic
{
    //将字典数据根据映射关系填充到当前对象的属性上
    [super setAttributes:dataDic];
    
    NSDictionary *retweetedDic = dataDic[@"retweeted_status"];
    if (retweetedDic != nil) {
        WeiboModel *retweeted = [[WeiboModel alloc] initWithDataDic:retweetedDic];
        self.retweeted = retweeted;
        [retweeted release];
    }
    
    NSDictionary *userDic = dataDic[@"user"];
    if (userDic != nil) {
        UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
        self.user = user;
        [user release];        
    }
}

@end
