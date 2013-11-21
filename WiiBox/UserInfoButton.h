//
//  UserInfoButton.h
//  WiiBox
//
//  Created by Hendy on 13-10-1.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoButton : UIButton
{
    @private
    UILabel *_mainTitleLabel;
    UILabel *_subTitleLabel;
}

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *subTitle;

@end
