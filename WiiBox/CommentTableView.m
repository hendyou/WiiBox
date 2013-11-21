//
//  CommentTableView.m
//  WiiBox
//
//  Created by Hendy on 13-9-25.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentCell.h"

@implementation CommentTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        self.enableRefreshHeader = YES;
    }
    return self;
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentify";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
    }
    
    CommentModel *commentModel = self.data[indexPath.row];
    cell.commentModel = commentModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = [CommentCell cellHdight:self.data[indexPath.row]];
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, kCommentSectionHeader)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, kCommentSectionHeader)];
    label.textColor = [UIColor blueColor];
    label.font = [UIFont systemFontOfSize:16];
    [view addSubview:label];
    [label release];
    
    NSNumber *total = self.commentDic[@"total_number"];
    label.text = [NSString stringWithFormat:@"评论: %@", total == nil ? @"0" : [total stringValue]];
    
    //分隔线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, view.width, 1)];
    line.image = [UIImage imageNamed:@"userinfo_header_separator.png"];
    [view addSubview:line];
    [line release];
    
    return [view autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kCommentSectionHeader;
}

@end
