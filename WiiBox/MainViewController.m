//
//  MainViewController.m
//  WiiBox
//
//  Created by Hendy on 13-9-10.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"
#import "ThemeButton.h"
#import "UIFactory.h"
#import "AppDelegate.h"

@interface MainViewController ()

- (void)initViewControllers;

- (void)initTabBar;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.tabBar.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initViewControllers];
    
    [self initTabBar];
    
    //请求未读数
    [NSTimer scheduledTimerWithTimeInterval:kRefreshUnreadCountInterval target:self selector:@selector(requestUnreadCount) userInfo:nil repeats:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    _tabBarView.frame = self.tabBar.bounds;
    _bgView.frame = self.tabBarView.bounds;
    
    float width = self.tabBarView.bounds.size.width;
    float height = self.tabBarView.bounds.size.height;
    float offx = (width / _tabButtons.count - 30) / 2;
    for (int i = 0; i < _tabButtons.count; i++) {
        UIButton *button = _tabButtons[i];
        button.frame = CGRectMake(offx + (30 + offx * 2) * i, (height - 30) / 2, 30, 30);
    }
    
    _sliderOffX = (width / _tabButtons.count - 15) / 2;
    _slider.frame = CGRectMake(_sliderOffX + (15 + _sliderOffX * 2) * self.selectedIndex, (height - 44) / 2, 15, 44);
}

- (void)dealloc
{
    [_tabBarView release];
    [_slider release];
    [_badgeView release];
    [_badgeLabel release];
    [_homeViewController release];
    [_tabButtons release];
    [_bgView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public methods
- (void)hideUnreadBadge
{
    _badgeView.hidden = YES;
}

- (void)showTabBar:(BOOL)show
{
    [UIView animateWithDuration:0.25 animations:^{
        if (show) {
            _tabBarView.left = 0;
        } else {
            _tabBarView.left = -ScreenWidth;
        }
    }];
    
}

- (void)showIndicator:(NSString *)title
{
    if (self.indicatorView == nil) {
        self.indicatorView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.indicatorView.labelText = title;
    }
}

- (void)hideIndicator:(NSTimeInterval)delay
{
    [self.indicatorView hide:YES afterDelay:delay];
}

#pragma mark - Init views
- (void)initViewControllers
{
    _homeViewController = [[HomeViewController alloc] init];
    MessageViewController *message = [[MessageViewController alloc] init];
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    DiscoverViewController *discover = [[DiscoverViewController alloc] init];
    MoreViewController *more = [[MoreViewController alloc] init];
    
    NSArray *views = @[_homeViewController, message, profile, discover, more];
    NSMutableArray *naviViews = [NSMutableArray arrayWithCapacity:5];
    
    for (UIViewController *view in views) {
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:view];
        nav.delegate = self;
        [naviViews addObject:nav];
        [nav release];
    }
    
    self.viewControllers = naviViews;
    
    [message release];
    [profile release];
    [discover release];
    [more release];
}

- (void)initTabBar
{
    self.tabBarView = [[UIView alloc] initWithFrame:self.tabBar.frame];
    
    //背景
    _bgView = [UIFactory createImageView:@"tabbar_background.png"];
//    bgView.frame = self.tabBarView.bounds;
    [self.tabBarView addSubview:_bgView];
    
    //添加TabBarItem
    NSArray *tabBarItemBgNames = @[@"tabbar_home.png", @"tabbar_message_center.png", @"tabbar_profile.png", @"tabbar_discover.png", @"tabbar_more.png"];
    NSArray *tabBarItemBgHightlightNames = @[@"tabbar_home_highlighted.png", @"tabbar_message_center_highlighted.png", @"tabbar_profile_highlighted.png", @"tabbar_discover_highlighted.png", @"tabbar_more_highlighted.png"];
    
    if (_tabButtons == nil) {
        _tabButtons = [[NSMutableArray arrayWithCapacity:tabBarItemBgNames.count] retain];
    }
    
//    float width = self.tabBarView.bounds.size.width;
//    float height = self.tabBarView.bounds.size.height;
//    float offx = (width / tabBarItemBgNames.count - 30) / 2;
    for (int i = 0; i < tabBarItemBgNames.count; i++) {
        UIButton *button = [UIFactory createButton:tabBarItemBgNames[i] highlighted:tabBarItemBgHightlightNames[i]];
//        button.frame = CGRectMake(offx + (30 + offx * 2) * i, (height - 30) / 2, 30, 30);
        button.tag = i;
        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarView addSubview:button];
        [_tabButtons addObject:button];
    }
    
//    [self.view addSubview:self.tabBarView];
    [self.tabBar addSubview:self.tabBarView];
    
    //指示条
    _slider = [[UIFactory createImageView:@"tabbar_slider.png"] retain];
    _slider.backgroundColor = [UIColor clearColor];
//    _sliderOffX = (width / tabBarItemBgNames.count - 15) / 2;
//    _slider.frame = CGRectMake(_sliderOffX + (15 + offx * 2) * 0, (height - 44) / 2, 15, 44);
    [self.tabBarView addSubview:_slider];
}

#pragma mark - Actions
- (void)selectedTab:(UIButton *)button
{
    //重复点击Home键时刷新数据
    if (self.selectedIndex == button.tag)
    {
        if (self.selectedIndex == 0) {
            HomeViewController *home = [[self.viewControllers[0] viewControllers] objectAtIndex:0];
            [home initLoading];
        }
        return;
    }
        
    self.selectedIndex = button.tag;
    [UIView animateWithDuration:0.2 animations:^{
        _slider.frame = CGRectMake(_sliderOffX + (15 + _sliderOffX * 2) * self.selectedIndex, (self.tabBarView.bounds.size.height - 44) / 2, 15, 44);
    }];
    
}

//请求未读数
- (void)requestUnreadCount
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.sinaweibo requestWithURL:@"remind/unread_count.json" params:nil httpMethod:@"GET" finished:^(NSDictionary *result) {
        [self refreshUnreadCount:result];
    }];
}

#pragma mark - UI
- (void)refreshUnreadCount:(NSDictionary *)result
{
    if (_badgeView == nil) {
        _badgeView = [UIFactory createImageView:@"main_badge.png"];
        _badgeView.frame = CGRectMake(64 - 25, 3, 25, 24);
        [_tabBarView addSubview:_badgeView];
        
        _badgeLabel = [[UILabel alloc] initWithFrame:_badgeView.bounds];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.textColor = [UIColor purpleColor];
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.font = [UIFont boldSystemFontOfSize:13];
        [_badgeView addSubview:_badgeLabel];
    }
    
    NSNumber *status = result[@"status"];
    int count = [status intValue];
    if (count > 0) {
        NSString *countStr = nil;
        if (count > 99) {
            countStr = @"N";
        } else {
            countStr = [NSString stringWithFormat:@"%@", status];
        }
        _badgeLabel.text = countStr;
        _badgeView.hidden = NO;
    } else {
        _badgeView.hidden = YES;
    }
}

#pragma mark - SinaWeiboDelegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"--------sinaweiboDidLogIn");
    //保存认证的数据
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //读取微博
    [_homeViewController loadData];
}
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"--------sinaweiboDidLogOut");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    
}
- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    int count = navigationController.viewControllers.count;
//    NSLog(@"---------%d", count);
    if (count == 2) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
}

@end
