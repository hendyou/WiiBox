//
//  UIFactory.h
//  WiiBox
//
//  Created by Hendy on 13-9-13.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeButton.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"

@interface UIFactory : NSObject

+ (ThemeButton *)createButton:(NSString *)imageName highlighted:(NSString*)highlightedName;

+ (ThemeButton *)createButton:(NSString *)background highlightedBackground:(NSString *)highlightedBackground;

+ (ThemeButton *)createBarButtonItemWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;

+ (ThemeImageView *)createImageView:(NSString *)imageName;

+ (ThemeLabel *)createLabel:(NSString *)fontColorName;

@end
