//
//  WeiboTableView.h
//  WiiBox
//
//  Created by Hendy on 13-9-18.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "BaseTableView.h"

@class WeiboModel;

typedef void (^FinishedLoading)(NSArray *weibos);

@protocol WeiboTableViewDelegate <NSObject>

@optional
- (void)pullDownFinished:(NSArray *)weibos;

- (void)pullUpFinished:(NSArray *)weibos;

@end

@interface WeiboTableView : BaseTableView<UITableViewEventDelegate>
{
    @private
    FinishedLoading _block;
}

@property (assign, nonatomic) int loadCount;

@property (copy, nonatomic) NSString *topId;
@property (copy, nonatomic) NSString *lastId;

@property (assign, nonatomic) id<WeiboTableViewDelegate> weiboDelegate;

- (void)loadData:(FinishedLoading) finishedBlock;

- (void)pullDownLoading;


@end
