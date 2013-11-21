//
//  CommentCell.h
//  WiiBox
//
//  Created by Hendy on 13-9-25.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "RTLabel.h"
#import "HeaderImageView.h"

@interface CommentCell : UITableViewCell<RTLabelDelegate>
{
    @private
//    UIImageView *_userHeaderView;
//    UILabel *_userNameLabel;
//    UILabel *_timeLabel;
    RTLabel *_commentLabel;
}

@property (retain, nonatomic) CommentModel *commentModel;

@property (retain, nonatomic) IBOutlet HeaderImageView *userHeaderView;
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;

+ (float)cellHdight:(CommentModel *)comment;

@end
