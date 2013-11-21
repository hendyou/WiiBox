//
//  UserViewController.m
//  WiiBox
//
//  Created by Hendy on 13-10-1.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoView.h"
#import "WeiboTableView.h"
#import "WeiboModel.h"

#define kLoadCount 20

@interface UserViewController ()

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"个人资料";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _userInfoView = [[UserInfoView alloc] init];

    self.tableView.tableHeaderView = _userInfoView;
    
    //读取用户数据
    [self loadUserData];
    
    //读取微博数据
    [self loadWeiboData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_user release];
    [_tableView release];
    [_userInfoView release];
    [_userName release];
    [super dealloc];
}

#pragma mark - Data
- (void)loadUserData
{
    if (!NSStringIsEmpty(self.userName)) {
        NSString *url = @"users/show.json";
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userName  forKey:@"screen_name"];
        SinaWeiboRequest *request = [self.sinaweibo requestWithURL:url params:params httpMethod:@"GET" finished:^(id result) {
            [self finishedUserData:result];
        }];
        [_requestArray addObject:request];
    }
}

- (void)finishedUserData:(NSDictionary *)userDic
{
    _user = [[UserModel alloc] initWithDataDic:userDic];
    
    _userInfoView.user = _user;
}

- (void)loadWeiboData
{
    [_tableView loadData:nil];
//    if (NSStringIsEmpty(_userName)) {
//        return;
//    }
//    
//    NSString *url = @"statuses/home_timeline.json";
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", kLoadCount]  forKey:@"count"];
////    [params setObject:_userName forKey:@"screen_name"];
//    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:url params:params httpMethod:@"GET" finished:^(id result) {
//        [self finishedWeiboData:result];
//    }];
//    [_requestArray addObject:request];
}

- (void)finishedWeiboData:(NSDictionary *)result
{
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    if (weibos.count > 0) {
        [weibos addObjectsFromArray:_tableView.data];
        
        _tableView.data = weibos;
        
        [_tableView reloadData];
    }
}
@end
