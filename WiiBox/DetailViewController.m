//
//  DetailViewController.m
//  WiiBox
//
//  Created by Hendy on 13-9-24.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "ImageUtil.h"
#import "WeiboView.h"
#import "CommentModel.h"

#define kLoadCount 5

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"微博正文";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initViews];
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)dealloc {    
    [_tableView release];
    [_userInfoBar release];
    [_userHeaderView release];
    [_userNameLabel release];
    [_weiboView release];
    [_weiboModel release];
    [super dealloc];
}

#pragma mark - Init views
- (void)initViews
{
    UIView *_tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //用户信息栏
    self.userHeaderView.imageUrl = self.weiboModel.user.profile_image_url;
    self.userHeaderView.userName = self.weiboModel.user.screen_name;
    
    self.userNameLabel.text = self.weiboModel.user.screen_name;
    [self.userNameLabel sizeToFit];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToUserPage:)];
    [_userInfoBar addGestureRecognizer:tap];
    
    [_tableHeaderView addSubview:_userInfoBar];
    
    
    //微博视图
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    _weiboView.weiboModel = self.weiboModel;
    _weiboView.isDetail = YES;
    [_tableHeaderView addSubview:_weiboView];
    
    self.userInfoBar.frame = CGRectMake(0, 0, ScreenWidth, 60);
    
    float weiboHeight = [WeiboView weiboViewHeight:self.weiboModel isDetail:YES isRepost:NO];
    _weiboView.frame = CGRectMake(0, _userInfoBar.bottom + 10, ScreenWidth, weiboHeight);
    
    _tableHeaderView.frame = CGRectMake(0, 0, ScreenWidth, _userInfoBar.height + _weiboView.height + 30);

    _tableView = [[CommentTableView alloc] initWithFrame:CGRectZero];
    _tableView.eventDelegate = self;
    _tableView.tableHeaderView = _tableHeaderView;
    _tableView.enableRefreshHeader = NO;
    [_tableHeaderView release];
    [self.view addSubview:_tableView];
}

#pragma mark - Actions
- (void)goToUserPage:(UITapGestureRecognizer *)tap
{
    [_userHeaderView goToUser];
}

#pragma mark - Load data
- (void)loadData
{
    if (self.weiboModel.id == nil) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[self.weiboModel.id stringValue] forKey:@"id"];
    [params setObject:[NSString stringWithFormat:@"%d", kLoadCount] forKey:@"count"];
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" finished:^(id result) {
        [self loadDataFinished:result];
    }];
    [_requestArray addObject:request];
}

- (void)loadDataFinished:(NSDictionary *)result
{
    NSArray *array = result[@"comments"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        CommentModel *comment = [[CommentModel alloc] initWithDataDic:dic];
        [comments addObject:comment];
        [comment release];
    }
    
    if (comments.count > 0) {
        [_tableView.data addObjectsFromArray:comments];
        self.lastId = [[_tableView.data.lastObject id] stringValue];
        _tableView.commentDic = result;
        [_tableView reloadData];
    } else {
        [_tableView enableLoadingMore:NO];
    }
    
}

- (void)loadPullUpData
{
    if (self.lastId == nil) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[self.weiboModel.id stringValue] forKey:@"id"];
    [params setObject:[NSString stringWithFormat:@"%d", kLoadCount+1] forKey:@"count"];
    [params setObject:self.lastId forKey:@"max_id"];
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" finished:^(id result) {
        [self pullUpLoadDataFinished:result];
    }];
    [_requestArray addObject:request];
}

- (void)pullUpLoadDataFinished:(NSDictionary *)result
{
    NSArray *array = result[@"comments"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        CommentModel *comment = [[CommentModel alloc] initWithDataDic:dic];
        [comments addObject:comment];
        [comment release];
    }
    
    if (comments.count > 0) {
        [comments removeObjectAtIndex:0];
    }
    
    if (comments.count > 0) {
        [_tableView.data addObjectsFromArray:comments];
        self.lastId = [[_tableView.data.lastObject id] stringValue];
        _tableView.commentDic = result;
        [_tableView reloadData];
    }
    
    [_tableView finishMoreLoading];
    
    if (comments.count < kLoadCount) {
        _tableView.isMore = NO;
    }
}

#pragma mark - BaseTableView EventDelegate
- (void)pullUp:(BaseTableView *)tableView
{
    [self loadPullUpData];
}
@end
