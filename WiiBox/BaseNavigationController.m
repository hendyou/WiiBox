//
//  BaseNavigationController.m
//  WiiBox
//
//  Created by Hendy on 13-9-10.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangedNotification:) name:kThemeDidChangedNofication object:nil];
        
//        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadThemeImage];
    
    UISwipeGestureRecognizer *swipGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
    swipGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipGesture];
    [swipGesture release];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangedNofication object:nil];
    [super dealloc];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    int count = self.viewControllers.count;
    if (count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

#pragma mark - Actions
- (void)swipAction:(UISwipeGestureRecognizer *)gesture
{
    if (self.viewControllers.count > 1) {
//        CGPoint point = [gesture locationInView:self.view];
//        if (point.x < 30) {
        [self popViewControllerAnimated:YES];
//        }
    }
}

- (void)themeChangedNotification:(NSNotification *)notification
{
    [self loadThemeImage];
}

- (void)loadThemeImage
{
    if (WXHLOSVersion() >= 5.0) {
        UIImage *bg = [[ThemeManager shareThemeManager] themeImage:@"navigationbar_background.png"];
        [self.navigationBar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
    } else {
        //让渲染引擎异步调用draw方法
        [self.navigationBar setNeedsDisplay];
    }
}

@end
