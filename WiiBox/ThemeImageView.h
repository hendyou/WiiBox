//
//  ThemeImageView.h
//  WiiBox
//
//  Created by Hendy on 13-9-14.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"

@interface ThemeImageView : UIImageView

@property (nonatomic, copy) NSString *imageName;

@property (assign, nonatomic) UIEdgeInsets insets;

- (id) initWithImageName:(NSString *)imageName;

@end
