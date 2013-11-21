//
//  AppDelegate.h
//  WiiBox
//
//  Created by Hendy on 13-9-10.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"

@class MainViewController;
@class SinaWeibo;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    SinaWeibo *_sinaweibo;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) DDMenuController *menu;
@property (readonly, nonatomic) SinaWeibo *sinaweibo;
@property (nonatomic, retain) MainViewController *main;

@end
