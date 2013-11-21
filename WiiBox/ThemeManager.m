//
//  ThemeManager.m
//  WiiBox
//
//  Created by Hendy on 13-9-13.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "ThemeManager.h"

static ThemeManager *singleton = nil;

@implementation ThemeManager

+ (ThemeManager *) shareThemeManager
{
    @synchronized(self) {
        if (singleton == nil) {
            singleton = [[[self class] alloc] init];
        }
    }
    return singleton;
}

- (id)init
{
    self = [super init];
    if (self) {
        //主题路径
        NSString *themePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        self.themesPlist = [NSDictionary dictionaryWithContentsOfFile:themePath];
        
        self.themeName = nil;
    }
    return self;
}

#pragma mark -下面的方法为了确保只有一个引用对象
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (singleton == nil) {
            singleton = [super allocWithZone:zone];
        }
    }
    return singleton;
}

- (id)copyWithZone:(NSZone *)zone
{
    return singleton;
}

- (id)retain
{
    return singleton;
}

- (oneway void)release
{
    //do nothing;
}

- (id)autorelease
{
    return singleton;
}

- (NSUInteger)retainCount {
    return UINT_MAX;
}

- (UIImage *)themeImage:(NSString *)imageName
{
    if (imageName == nil || imageName.length < 1) {
        return nil;
    }
    
    NSString *imagePath = [[self themePath] stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

- (NSString *)themePath
{
    //程序包根路径
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    if (self.themeName == nil) {
        return resourcePath;
    } else {
        NSString *skinPath = self.themesPlist[self.themeName];
        NSString *path = [resourcePath stringByAppendingPathComponent:skinPath];
        return path;
    }
    
    return resourcePath;
}

//overide
- (void)setThemeName:(NSString *)themeName
{
    if (_themeName != themeName) {
        [_themeName release];
        _themeName = [themeName copy];
        
        //切换字体颜色
        NSString *fontColorPlistPath = [[self themePath] stringByAppendingPathComponent:@"fontColor.plist"];
        self.fontColorPlist = [NSDictionary dictionaryWithContentsOfFile:fontColorPlistPath];
    }
}

- (UIColor *)fontColor:(NSString *)name
{
    if (NSStringIsEmpty(name)) {
        return nil;
    }
    
    NSString *colorStr = self.fontColorPlist[name];
    NSArray *rgbs = [colorStr componentsSeparatedByString:@","];
    if (rgbs.count == 3) {
        float red = [rgbs[0] floatValue];
        float green = [rgbs[1] floatValue];
        float blue = [rgbs[2] floatValue];
        
        UIColor *color = [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
        return color;
    } else {
        return nil;
    }
}

@end
