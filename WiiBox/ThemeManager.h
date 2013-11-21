//
//  ThemeManager.h
//  WiiBox
//  主题管理类

//  Created by Hendy on 13-9-13.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kThemeDidChangedNofication @"kThemeDidChangedNofication"
#define kThemeListLabel @"kThemeListLabel"
#define kNavigationBarTitleLabel @"kNavigationBarTitleLabel"
#define kCurrentTheme @"kCurrentTheme"

@interface ThemeManager : NSObject

@property (nonatomic, copy) NSString *themeName;
@property (nonatomic, retain) NSDictionary *themesPlist;
@property (nonatomic, retain) NSDictionary *fontColorPlist;

+ (ThemeManager *) shareThemeManager;

//返回当前主题下的图片
- (UIImage *)themeImage:(NSString *)imageName;

- (UIColor *)fontColor:(NSString *)name;

@end
