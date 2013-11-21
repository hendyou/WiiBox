//
//  ImageUtil.m
//  WiiBox
//
//  Created by Hendy on 13-9-25.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "ImageUtil.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImageUtil

+ (void)fillet:(UIView *)view
{
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
}

@end
