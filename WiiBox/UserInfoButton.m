//
//  UserInfoButton.m
//  WiiBox
//
//  Created by Hendy on 13-10-1.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "UserInfoButton.h"

@implementation UserInfoButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initViews];
}

- (void)dealloc
{
    [_mainTitleLabel release];
    [_subTitleLabel release];
    [_title release];
    [_subTitle release];
    [super dealloc];
}

#pragma mark - Init views
- (void)initViews
{
    [self setTitle:nil forState:UIControlStateNormal];
    
    //background
    UIImage *bg = [UIImage imageNamed:@"userinfo_apps_background.png"];
    [self setBackgroundImage:bg forState:UIControlStateNormal];
    UIImage *bgHightlight = [UIImage imageNamed:@"userinfo_apps_background_highlighted.png"];
    [self setBackgroundImage:bgHightlight forState:UIControlStateHighlighted];
    
    _mainTitleLabel = [[UILabel alloc] init];
    _mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    _mainTitleLabel.textColor = [UIColor blackColor];
    _mainTitleLabel.font = [UIFont systemFontOfSize:14];
    _mainTitleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_mainTitleLabel];
    
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    _subTitleLabel.textColor = [UIColor blueColor];
    _subTitleLabel.font = [UIFont systemFontOfSize:14];
    _subTitleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_subTitleLabel];
    
    
    _mainTitleLabel.frame = self.bounds;
    _subTitleLabel.frame = CGRectMake(0, 0, self.width, self.height/2.0);
    _subTitleLabel.hidden = YES;
}

#pragma mark - Public methods
- (void)setTitle:(NSString *)title
{
    _mainTitleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle
{
    if (NSStringIsEmpty(subTitle)) {
        _mainTitleLabel.frame = self.bounds;
        _subTitleLabel.hidden = YES;
    } else {
        _subTitleLabel.text = subTitle;
        _subTitleLabel.hidden = NO;
        [_subTitleLabel sizeToFit];
        _subTitleLabel.frame = CGRectMake(0, self.height / 2.0 - _subTitleLabel.height, self.width, _subTitleLabel.height);
        [_mainTitleLabel sizeToFit];
        _mainTitleLabel.frame = CGRectMake(0, _subTitleLabel.bottom, self.width, _mainTitleLabel.height);
    }
}

@end
