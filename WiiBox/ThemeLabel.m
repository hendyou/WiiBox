//
//  ThemeLabel.m
//  WiiBox
//
//  Created by Hendy on 13-9-14.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangedNotification:) name:kThemeDidChangedNofication object:nil];
    }
    return self;
}

- (id)initWithFontColor:(NSString *)colorName
{
    self = [self init];
    if (self) {
        self.fontColorName = colorName;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangedNofication object:nil];
    [super dealloc];
}

//overide
- (void)setFontColorName:(NSString *)fontColorName
{
    if (_fontColorName != fontColorName) {
        [_fontColorName release];
        _fontColorName = [fontColorName copy];
        
        UIColor *color = [[ThemeManager shareThemeManager] fontColor:_fontColorName];
        self.textColor = color;
    }
}

- (void)themeChangedNotification:(NSNotification *)notification
{
    [self loadTheme];
}

- (void)loadTheme
{
    UIColor *color = [[ThemeManager shareThemeManager] fontColor:_fontColorName];
    self.textColor = color;
    
}

@end
