//
//  HeaderImageView.m
//  WiiBox
//
//  Created by Hendy Ou on 13-10-8.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "HeaderImageView.h"
#import "UserViewController.h"
#import "UIImageView+WebCache.h"
#import "ImageUtil.h"

@implementation HeaderImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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

- (void)setup
{
    // Initialization code
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    //圆角
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    [ImageUtil fillet:self];
}

- (void)dealloc
{
    [_userName release];
    [_imageUrl release];
    [super dealloc];
}

- (void)setImageUrl:(NSString *)imageUrl
{
    if (_imageUrl != imageUrl) {
        [_imageUrl release];
        _imageUrl = [imageUrl copy];
        
        [self setImageWithURL:[NSURL URLWithString:_imageUrl]];
    }
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    [self goToUser];
}

- (void)goToUser
{
    if (NSStringIsEmpty(_userName)) {
        return;
    }
    
    UserViewController *viewCtrl = [[UserViewController alloc] init];
    viewCtrl.userName = _userName;
    [self.viewController.navigationController pushViewController:viewCtrl animated:YES];
    [viewCtrl release];
}

@end
