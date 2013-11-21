//
//  UserModel.m
//  WiiBox
//
//  Created by Hendy on 13-9-15.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (NSString *)sex
{
    NSString *sex = @"未知";
    if (!NSStringIsEmpty(self.gender)) {
        if ([self.gender isEqualToString:@"m"]) {
            sex = @"男";
        } else if ([self.gender isEqualToString:@"f"]) {
            sex = @"女";
        }
    }
    
    return sex;
}

@end
