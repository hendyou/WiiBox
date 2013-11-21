//
//  ThemeButton.m
//  WiiBox
//
//  Created by Hendy on 13-9-13.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

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

- (id)initWithImage:(NSString *)imageName highlightedImage:(NSString *)highlightedImage
{
    self = [self init];
    if (self) {
        self.imageName = imageName;
        self.highlightImageName = highlightedImage;
    }
    return self;
}

- (id)initwithBackground:(NSString *)background highlightedBackground:(NSString *)highlightedBackground
{
    self = [self init];
    if (self) {
        self.backgroundImageName = background;
        self.backgroundHighlightImageName = highlightedBackground;
    }
    return self;
}

- (void)loadThemeImage
{
    ThemeManager *themeManager = [ThemeManager shareThemeManager];
    
    UIImage *image = [themeManager themeImage:self.imageName];
    UIImage *highlightedImage = [themeManager themeImage:self.highlightImageName];
    
    image = [image resizableImageWithCapInsets:self.insets];
    highlightedImage = [highlightedImage resizableImageWithCapInsets:self.insets];
    
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:highlightedImage forState:UIControlStateHighlighted];
    
    
    UIImage *background = [themeManager themeImage:self.backgroundImageName];
    UIImage *backgroundHighlighted = [themeManager themeImage:self.backgroundHighlightImageName];
    
    background = [background resizableImageWithCapInsets:self.insets];
    backgroundHighlighted = [backgroundHighlighted resizableImageWithCapInsets:self.insets];
    
    [self setBackgroundImage:background forState:UIControlStateNormal];
    [self setBackgroundImage:backgroundHighlighted forState:UIControlStateHighlighted];
}

- (void)setImageName:(NSString *)imageName
{
    if (_imageName != imageName) {
        [_imageName release];
        _imageName = [imageName copy];
        ThemeManager *themeManager = [ThemeManager shareThemeManager];
        [self setImage:[themeManager themeImage:self.imageName] forState:UIControlStateNormal];
    }
}

- (void)setHighlightImageName:(NSString *)highlightImageName
{
    if (_highlightImageName != highlightImageName) {
        [_highlightImageName release];
        _highlightImageName = [highlightImageName copy];
        ThemeManager *themeManager = [ThemeManager shareThemeManager];
        [self setImage:[themeManager themeImage:self.highlightImageName] forState:UIControlStateHighlighted];
    }
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName
{
    if (_backgroundImageName != backgroundImageName) {
        [_backgroundImageName release];
        _backgroundImageName = [backgroundImageName copy];
        ThemeManager *themeManager = [ThemeManager shareThemeManager];
        [self setBackgroundImage:[themeManager themeImage:self.backgroundImageName] forState:UIControlStateNormal];
    }
}

- (void)setBackgroundHighlightImageName:(NSString *)backgroundHighlightImageName
{
    if (_backgroundHighlightImageName != backgroundHighlightImageName) {
        [_backgroundHighlightImageName release];
        _backgroundHighlightImageName = [backgroundHighlightImageName copy];
        ThemeManager *themeManager = [ThemeManager shareThemeManager];
        [self setBackgroundImage:[themeManager themeImage:self.backgroundHighlightImageName] forState:UIControlStateHighlighted];
    }
}

- (void)setInsets:(UIEdgeInsets)insets
{
    _insets = insets;
    [self loadThemeImage];
}

@end
