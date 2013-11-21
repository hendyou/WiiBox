//
//  ScanModeViewController.m
//  WiiBox
//
//  Created by Hendy on 13-9-29.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "ScanModeViewController.h"

@interface ScanModeViewController ()

@end

@implementation ScanModeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"浏览模式";
        
        _modes = [@[@"小图模式", @"大图模式"] retain];
        
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

- (void)dealloc {
    [_modes release];
    
    [_tableView release];
    [super dealloc];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
        [cell autorelease];
    }
    
    cell.textLabel.text = _modes[indexPath.row];
    
    int mode = [[NSUserDefaults standardUserDefaults] integerForKey:kCurrentScanMode];
    if (mode == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.currentChecked = indexPath;
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![indexPath isEqual:self.currentChecked]) {
        //记录当前模式
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:kCurrentScanMode];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //改变选中状态
        [tableView cellForRowAtIndexPath:_currentChecked].accessoryType = UITableViewCellAccessoryNone;
        self.currentChecked = indexPath;
        [tableView cellForRowAtIndexPath:_currentChecked].accessoryType = UITableViewCellAccessoryCheckmark;
        
        //通知刷新列表
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWeiboList object:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
