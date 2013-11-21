//
//  BaseTableView.m
//  WiiBox
//
//  Created by Hendy on 13-9-18.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "BaseTableView.h"
#import "SinaWeiboRequest.h"

@implementation BaseTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        [self initViews];
    }
    return self;
}

//使用xib创建
- (void)awakeFromNib
{
    [self initViews];
}

- (void)initViews
{
    _requestArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _data = [[NSMutableArray array] retain];
    self.isMore = YES;
    
    self.dataSource = self;
    self.delegate = self;
    
    self.enableRefreshHeader = YES;
    [self enableLoadingMore:YES];
    
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    view.backgroundColor = [UIColor clearColor];
    view.delegate = self;
    [self addSubview:view];
    _refreshHeaderView = view;
    
    //底部上拉更多
    _moreBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _moreBtn.backgroundColor = [UIColor clearColor];
    _moreBtn.frame = CGRectMake(0, 0, ScreenWidth, 40);
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_moreBtn setTitle:@"上拉加载更多" forState:UIControlStateNormal];
    [_moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize textSize = [@"正在加载..." sizeWithFont:_moreBtn.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, _moreBtn.titleLabel.height)];
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicator stopAnimating];
    _indicator.frame = CGRectMake(_moreBtn.center.x - textSize.width/2.0 - 20, _moreBtn.center.y, 0, 0);
    [_moreBtn addSubview:_indicator];
    
    self.tableFooterView = _moreBtn;
}

- (void)dealloc
{
    [_data release];
    [_refreshHeaderView release];
    [_moreBtn release];
    [_indicator release];
    
    for (SinaWeiboRequest *request in _requestArray) {
        [request disconnect];
    }
    [_requestArray release];
    [super dealloc];
}

#pragma mark - Overide
- (void)setIsMore:(BOOL)isMore
{
    _isMore = isMore;
    [_indicator stopAnimating];
    if (isMore) {
        [_moreBtn setTitle:@"上拉加载更多" forState:UIControlStateNormal];
        _moreBtn.enabled = YES;
    } else {
        [_moreBtn setTitle:@"加载完成" forState:UIControlStateNormal];
        _moreBtn.enabled = NO;
    }
}

#pragma mark - Public methods
- (void)initLoading
{
    [_refreshHeaderView initLoading:self];
}

- (void)setMoreStateLoading
{
    _moreBtn.enabled = NO;
    [_moreBtn setTitle:@"正在加载..." forState:UIControlStateNormal];
    [_indicator startAnimating];
}

- (void)finishMoreLoading
{
    
    _moreBtn.enabled = YES;
    [_moreBtn setTitle:@"上拉加载更多" forState:UIControlStateNormal];
    [_indicator stopAnimating];
}

- (void)enableLoadingMore:(BOOL)enable
{
    if (enable) {
        _moreBtn.hidden = NO;
    } else {
        _moreBtn.hidden = YES;
    }
}

#pragma mark - UI
- (void)refreshUpdateDate
{
    [_refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark - Actions
- (void)loadMore
{
    if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
        [self.eventDelegate pullUp:self];
        [self setMoreStateLoading];
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (self.enableRefreshHeader) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (self.enableRefreshHeader) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    if (self.isMore && !_moreBtn.hidden && _moreBtn.enabled) {
        float offset = scrollView.contentOffset.y;
        float contentHeight = scrollView.contentSize.height;
        
        float dis = scrollView.height - self.contentInset.top - self.contentInset.bottom - (contentHeight - offset);
        if (dis > 30) {
            [self loadMore];
        }
        
    }
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    //停止加载，弹回下拉
    //!!数据加载完成后要调用doneLoadingTableViewData方法让下拉视图弹回!!
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
    if ([self.eventDelegate respondsToSelector:@selector(pullDown:)])
    {
        [self.eventDelegate pullDown:self];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        [cell autorelease];
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

//overide
- (void)setEnableRefreshHeader:(BOOL)enableRefreshHeader
{
    _enableRefreshHeader = enableRefreshHeader;
    
    if (_enableRefreshHeader) {
        [self addSubview:_refreshHeaderView];
    } else {
        if ([_refreshHeaderView superview]) {
            [_refreshHeaderView removeFromSuperview];
        }
    }
}

@end
