//
//  ThemeLabel.h
//  WiiBox
//
//  Created by Hendy on 13-9-14.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeLabel : UILabel

@property (nonatomic,copy) NSString *fontColorName;

- (id)initWithFontColor:(NSString *)colorName;

@end
