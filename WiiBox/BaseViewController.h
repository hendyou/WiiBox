//
//  BaseViewController.h
//  WiiBox
//
//  Created by Hendy on 13-9-10.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@class AppDelegate;

@interface BaseViewController : UIViewController
{
    NSMutableArray *_requestArray;
}
@property (assign, nonatomic) BOOL showHomeButton;

- (SinaWeibo *)sinaweibo;
- (AppDelegate *)appDelegate;

@end
