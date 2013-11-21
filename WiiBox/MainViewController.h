//
//  MainViewController.h
//  WiiBox
//
//  Created by Hendy on 13-9-10.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "MBProgressHUD.h"

#define kRefreshUnreadCountInterval 60

@class ThemeImageView;
@class HomeViewController;

@interface MainViewController : UITabBarController <SinaWeiboDelegate,UINavigationControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView *_slider;
    float _sliderOffX;
    ThemeImageView *_badgeView;
    UILabel *_badgeLabel;
    NSMutableArray *_tabButtons;
    UIImageView *_bgView;
    
    HomeViewController *_homeViewController;
}

@property (nonatomic, retain) UIView *tabBarView;

@property (nonatomic, retain) MBProgressHUD *indicatorView;

- (void)hideUnreadBadge;

- (void)showTabBar:(BOOL)show;

- (void)showIndicator:(NSString *)title;

- (void)hideIndicator:(NSTimeInterval)delay;

@end
