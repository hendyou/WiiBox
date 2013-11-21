//
//  ThemeButton.h
//  WiiBox
//
//  Created by Hendy on 13-9-13.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *highlightImageName;

@property (nonatomic, copy) NSString *backgroundImageName;
@property (nonatomic, copy) NSString *backgroundHighlightImageName;

@property (assign, nonatomic) UIEdgeInsets insets;

- (id)initWithImage:(NSString *)imageName highlightedImage:(NSString *)highlightedImage;

- (id)initwithBackground:(NSString *)background highlightedBackground:(NSString *)highlightedBackground;

@end
