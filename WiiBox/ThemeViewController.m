//
//  ThemeViewController.m
//  WiiBox
//
//  Created by Hendy on 13-9-13.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeManager.h"
#import "UIFactory.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _themeArray = [[[[ThemeManager shareThemeManager] themesPlist] allKeys] retain];
        
        self.title = @"主题";
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
    [_tableView release];
    [_themeArray release];
    [_currentChecked release];
    [super dealloc];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _themeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
        UILabel *label = [UIFactory createLabel:@"kThemeListLabel"];
//        label.frame = CGRectMake(0, 0, 280, 30);
        CGRect frame = cell.contentView.bounds;
        frame.origin.x = 10;
        label.frame = frame;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 100;
        [cell.contentView addSubview:label];
        [cell autorelease];
    }
    
//    cell.textLabel.text = _themeArray[indexPath.row];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    label.text = _themeArray[indexPath.row];
    
    NSString *themeName = [ThemeManager shareThemeManager].themeName;
    if ([themeName isEqualToString:_themeArray[indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.currentChecked = indexPath;
    }

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //切换主题
    NSString *themeName = _themeArray[indexPath.row];
    [ThemeManager shareThemeManager].themeName = themeName;
    //通知切换
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangedNofication object:themeName];
    //记录当前主题
    [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:kCurrentTheme];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![indexPath isEqual:self.currentChecked]) {
        //改变选中状态
        [tableView cellForRowAtIndexPath:_currentChecked].accessoryType = UITableViewCellAccessoryNone;
        self.currentChecked = indexPath;
        [tableView cellForRowAtIndexPath:_currentChecked].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
