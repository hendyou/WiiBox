//
//  StringUtil.m
//  WiiBox
//
//  Created by Hendy on 13-9-14.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "StringUtil.h"


BOOL NSStringIsEmpty(NSString *string)
{
    if (string == nil || string.length == 0) {
        return YES;
    } else {
        return NO;
    }
}