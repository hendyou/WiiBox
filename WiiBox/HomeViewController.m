//
//  HomeViewController.m
//  WiiBox
//
//  Created by Hendy on 13-9-11.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "HomeViewController.h"
#import "WeiboModel.h"
#import "UIFactory.h"
#import "AttentionUtil.h"
#import "MainViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

#define kLoadCount 20

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"微博";
    }
    return self;
}

- (void)dealloc {
    [_tableView release];
    [_weiboCountView release];
    [_countLabel release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //绑定账号按钮
    UIBarButtonItem *bindItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定账号" style:UIBarButtonItemStyleBordered target:self action:@selector(bindAction:)];
    self.navigationItem.rightBarButtonItem = bindItem;
    [bindItem release];
    
    //注销按钮
    UIBarButtonItem *registerItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(registerAction:)];
    self.navigationItem.leftBarButtonItem = registerItem;
    [registerItem release];
    
    //Table view
    _tableView = [[WeiboTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.weiboDelegate = self;
    _tableView.enableRefreshHeader = YES;
    
    if (self.sinaweibo.isAuthValid) {
        [self loadData];
    } else {
        [self.sinaweibo logIn];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //开启左滑右滑
    [self.appDelegate.menu setEnableGesture:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //禁用左滑右滑
    [self.appDelegate.menu setEnableGesture:NO];
}

#pragma mark - Public methods
- (void)initLoading
{
    [_tableView pullDownLoading];
}

#pragma mark - UI
//显示更新了多少条微博
- (void)showWeiboCount:(int)count
{
    if (_weiboCountView == nil) {
        //微博更新数量提示View
        _weiboCountView = [UIFactory createImageView:@"timeline_new_status_background.png"];
        _weiboCountView.frame = CGRectMake(0, -34, ScreenWidth, 34);
        _weiboCountView.insets = UIEdgeInsetsMake(5, 5, 5, 5);
        //提示的内容
        _countLabel = [[UILabel alloc] initWithFrame:_weiboCountView.bounds];
        _countLabel.font = [UIFont systemFontOfSize:16];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        [_weiboCountView addSubview:_countLabel];
        [self.view addSubview:_weiboCountView];
    }
    
    //显示更新了多少条微博
    //    NSLog(@"更新了%d", updateCount);
    _countLabel.text = [NSString stringWithFormat:@"更新了%d条微博", count];
    [UIView animateWithDuration:0.5 animations:^{
        _weiboCountView.top = 2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _weiboCountView.top = -_weiboCountView.height;
        } completion:nil];
    }];
    
    if (count > 0) {        
        //播放提示音
        [AttentionUtil playSystemSound:@"msgcome.wav"];
    }
}

#pragma mark - load data
- (void)loadData
{
    //显示loading提示
    MainViewController *main = (MainViewController *)self.tabBarController;
    [main showIndicator:@"正在读取数据..."];
    _tableView.hidden = YES;

    [_tableView loadData:^(NSArray *weibos) {
        //关闭loading提示
        MainViewController *main = (MainViewController *)self.tabBarController;
        [main hideIndicator:0];
        _tableView.hidden = NO;
    }];
    
}

#pragma mark - WeiboTableViewDelegate
- (void)pullDownFinished:(NSArray *)weibos
{
    [self showWeiboCount:weibos.count];
    
    //隐藏TabBar里的未读微博数
    [(MainViewController *)self.tabBarController hideUnreadBadge];
}

#pragma mark - SinaWeiboRequestDelegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"登陆失败");
}

#pragma mark - actions
- (void)bindAction:(UIBarButtonItem *)barButton
{
    [self.sinaweibo logIn];
} 

- (void)registerAction:(UIBarButtonItem *)barButton
{
    [self.sinaweibo logOut];
}


@end
