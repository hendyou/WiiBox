//
//  RightViewController.m
//  WiiBox
//
//  Created by Hendy on 13-9-11.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "RightViewController.h"
#import "NewWeiboViewController.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)newWeibo:(UIButton *)sender {
    NewWeiboViewController *newWeiboCtrl = [[NewWeiboViewController alloc] init];
    BaseNavigationController *naviCtrl = [[BaseNavigationController alloc] initWithRootViewController:newWeiboCtrl];
    [self.appDelegate.menu presentViewController:naviCtrl animated:YES completion:nil];
    
    [newWeiboCtrl release];
    [naviCtrl release];
}
@end
