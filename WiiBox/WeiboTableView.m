//
//  WeiboTableView.m
//  WiiBox
//
//  Created by Hendy on 13-9-18.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboModel.h"
#import "WeiboCell.h"
#import "WeiboView.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

@implementation WeiboTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)dealloc
{
    [_topId release];
    [_lastId release];
    [super dealloc];
}

- (void)setup
{
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kReloadWeiboList object:nil];
    
    self.loadCount = 20;
    
    self.eventDelegate = self;
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)excuteBlock:(NSArray*)weibos
{
    if (_block) {
        _block(weibos);
        Block_release(_block);
        _block = nil;
    }
}

#pragma mark - Public methods
- (void)loadData:(FinishedLoading) finishedBlock;
{
    if (_block != nil) {
        Block_release(_block);
    }
    if (finishedBlock) {
        _block = Block_copy(finishedBlock);
    }

    [self loadingData];

}

- (void)pullDownLoading
{
    if (self.enableRefreshHeader) {
        [self initLoading];
        [self pullDownData];
    }
}

#pragma mark - Table view source data

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentify";
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        [cell autorelease];
    }
    
    WeiboModel *weiboModel = self.data[indexPath.row];
    cell.weiboModel = weiboModel;
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = [WeiboView weiboViewHeight:self.data[indexPath.row] isDetail:NO isRepost:NO];
    if ([self.data[indexPath.row] retweeted] != nil) {
        height += 90;
    } else {
        height += 75;
    }
    return height;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    DetailViewController *detail = [[DetailViewController alloc] init];
    [detail autorelease];
    detail.weiboModel = self.data[indexPath.row];
    [self.viewController.navigationController pushViewController:detail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - BaseTableView event delegate
- (void)pullDown:(BaseTableView *)tableView
{
    //    NSLog(@"----------请求网络数据");
    //    [_tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
    [self pullDownData];
}

- (void)pullUp:(BaseTableView *)tableView
{
    [self pullUpData];
}

#pragma mark - load data
- (void)loadingData
{
    NSString *url = @"statuses/home_timeline.json";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", _loadCount]  forKey:@"count"];
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:url params:params httpMethod:@"GET" finished:^(id result) {
        NSArray *statuses = result[@"statuses"];
        NSMutableArray *weiboArray = [NSMutableArray arrayWithCapacity:statuses.count];
        for (NSDictionary *weiboDic in statuses) {
            WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:weiboDic];
            [weiboArray addObject:weibo];
            [weibo release];
        }
        
        if (weiboArray.count > 0) {
            self.topId = [[weiboArray[0] id] stringValue];
            self.lastId = [[weiboArray.lastObject id] stringValue];
        }
        
        self.data = weiboArray;
        
        //更新下拉视图的最后更新日期
        [self refreshUpdateDate];
        
        [self reloadData];
        
        [self excuteBlock:weiboArray];
    }];
    
    [_requestArray addObject:request];
}

- (void) pullDownData
{
    if (self.topId == nil) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithFormat:@"%d", _loadCount], @"count",
                                   self.topId, @"since_id",
                                   nil];
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          finished:^(id result) {
                              [self pullDownDataFinished:result];
                          }];
    
    [_requestArray addObject:request];
}

- (void) pullDownDataFinished:(id) result
{
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    NSArray *array = [[NSArray alloc] initWithArray:weibos];
    
    if (weibos.count > 0) {
        [weibos addObjectsFromArray:self.data];
        
        self.data = weibos;
        
        self.topId = [[weibos[0] id] stringValue];
        
        [self reloadData];
    }
    //隐藏下拉视图
    [self doneLoadingTableViewData];

    if ([_weiboDelegate respondsToSelector:@selector(pullDownFinished:)]) {
        [_weiboDelegate pullDownFinished:array];
    }
    [array release];
}

- (void) pullUpData
{
    if (self.lastId == nil) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithFormat:@"%d", _loadCount+1], @"count",
                                   self.lastId, @"max_id",
                                   nil];
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          finished:^(id result) {
                              [self pullUpDataFinished:result];
                          }];
    
    [_requestArray addObject:request];
}

- (void) pullUpDataFinished:(id) result
{
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    //返回ID小于或等于max_id的微博, 包括max_id的微博, 要移除
    if (weibos.count > 0) {
        [weibos removeObjectAtIndex:0];
    }
    
    if (weibos.count > 0) {
        
        [self.data addObjectsFromArray:weibos];
        
        self.lastId = [[weibos.lastObject id] stringValue];
        
        [self reloadData];
    }
    //标记数据加载完成
    [self finishMoreLoading];
    
    if (weibos.count < _loadCount) {
        self.isMore = NO;
    }
    
    if ([_weiboDelegate respondsToSelector:@selector(pullUpFinished:)]) {
        [_weiboDelegate pullDownFinished:weibos];
    }
}

@end
