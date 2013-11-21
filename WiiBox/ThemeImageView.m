//
//  ThemeImageView.m
//  WiiBox
//
//  Created by Hendy on 13-9-14.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "ThemeImageView.h"

@implementation ThemeImageView

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangedNotification:) name:kThemeDidChangedNofication object:nil];
    }
    return self;
}

- (void)themeChangedNotification:(NSNotification *)notification
{
    [self loadThemeImage];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangedNofication object:nil];
    [super dealloc];
}

- (id) initWithImageName:(NSString *)imageName
{
    self = [self init];
    if (self) {
        self.imageName = imageName;
    }
    return self;
}

- (void)setImageName:(NSString *)imageName
{
    if (_imageName != imageName) {
        [_imageName release];
        _imageName = [imageName copy];
        [self loadThemeImage];
    }
}

- (void)loadThemeImage
{
    UIImage *image = [[ThemeManager shareThemeManager] themeImage:self.imageName];
    image = [image resizableImageWithCapInsets:self.insets];
    self.image = image;
}

- (void)setInsets:(UIEdgeInsets)insets
{
    _insets = insets;
    if (!NSStringIsEmpty(self.imageName)) {
        [self loadThemeImage];
    }
}

@end
