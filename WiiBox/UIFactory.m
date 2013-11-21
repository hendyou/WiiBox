//
//  UIFactory.m
//  WiiBox
//
//  Created by Hendy on 13-9-13.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "UIFactory.h"


@implementation UIFactory

+ (ThemeButton *)createButton:(NSString *)imageName highlighted:(NSString*)highlightedName
{
    ThemeButton *button = [[ThemeButton alloc] initWithImage:imageName highlightedImage:highlightedName];
    return [button autorelease];
}

+ (ThemeButton *)createButton:(NSString *)background highlightedBackground:(NSString *)highlightedBackground
{
    ThemeButton *button = [[ThemeButton alloc] initwithBackground:background highlightedBackground:highlightedBackground];
    return [button autorelease];
}

+ (ThemeButton *)createBarButtonItemWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action
{
    ThemeButton *button = [UIFactory createButton:@"navigationbar_button_background.png" highlightedBackground:nil];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSString *themeName = [ThemeManager shareThemeManager].themeName;
    if ([themeName isEqualToString:@"default"]) {
        button.insets = UIEdgeInsetsMake(4, 5, 4, 5);
    } else {
        button.insets = UIEdgeInsetsMake(4, 2, 4, 2);
    }
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    return button;
}

+ (ThemeImageView *)createImageView:(NSString *)imageName
{
    ThemeImageView *imageView = [[ThemeImageView alloc] initWithImageName:imageName];
    return [imageView autorelease];
}

+ (ThemeLabel *)createLabel:(NSString *)fontColorName
{
    ThemeLabel *label = [[ThemeLabel alloc] initWithFontColor:fontColorName];
    return [label autorelease];
}

@end
