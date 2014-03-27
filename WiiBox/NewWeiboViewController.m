//
//  NewWeiboViewController.m
//  WiiBox
//
//  Created by Hendy Ou on 13-10-10.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "NewWeiboViewController.h"
#import "UIFactory.h"
#import "LocationViewController.h"
#import "ThemeManager.h"

#define kMenuBtnWidth 23
#define kMenuBtnHeight 20

@interface NewWeiboViewController ()

@end

@implementation NewWeiboViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"新微博";
        _menuBtns = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    float offX = (_menuBar.width / 5 - kMenuBtnWidth) / 2;
    for (int i = 0; i < _menuBtns.count; i++) {
        UIButton *btn = _menuBtns[i];
        if (i == 5) {
            btn.left = offX + (kMenuBtnWidth + 2 * offX) * 4;
            btn.hidden = YES;
        } else {
            btn.left = offX + (kMenuBtnWidth + 2 * offX) * i;
        }
    }
}

- (void)dealloc {
    [_menuBtns release];
    [_menuBar release];
    [_textView release];
    [_locationView release];
    [_locationViewbg release];
    [_locationLabel release];
    [super dealloc];
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - UI
- (void)initViews
{
    //取消按钮
    UIButton *cancelBtn = [UIFactory createBarButtonItemWithFrame:CGRectMake(0, 0, 50, 30) title:@"取消" target:self action:@selector(cancel)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelItem;
    [cancelItem release];
    
    //发布按钮
    UIButton *sendBtn = [UIFactory createBarButtonItemWithFrame:CGRectMake(0, 0, 50, 30) title:@"发布" target:self action:@selector(send)];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = sendItem;
    [sendItem release];
    
    [self initMenuBar];
    
    //TextView PlaceHolder
    _textView.placeholder = @"分享新鲜事...";
    
    //Location Views
    UIImage *locationBg = _locationViewbg.image;
    UIEdgeInsets insets = UIEdgeInsetsMake(9, 31, 9, 15);
    _locationViewbg.image = [locationBg resizableImageWithCapInsets:insets];
    _locationLabel.left = _locationViewbg.left + insets.left;
}

- (void)initMenuBar
{
    NSArray *imgNames = @[@"compose_locatebutton_background.png",
                          @"compose_camerabutton_background.png",
                          @"compose_trendbutton_background.png",
                          @"compose_mentionbutton_background.png",
                          @"compose_emoticonbutton_background.png",
                          @"compose_keyboardbutton_background.png"];
    
    NSArray *highlightedNames = @[@"compose_locatebutton_background_highlighted.png",
          @"compose_camerabutton_background_highlighted.png",
          @"compose_trendbutton_background_highlighted.png",
          @"compose_mentionbutton_background_highlighted.png",
          @"compose_emoticonbutton_background_highlighted.png",
          @"compose_keyboardbutton_background_highlighted.png"];
    
    float offY = (_menuBar.height - kMenuBtnHeight) / 2;
    for (int i = 0; i < imgNames.count; i++) {
        UIButton *btn = [UIFactory createButton:imgNames[i] highlighted:highlightedNames[i]];
        [btn setImage:highlightedNames[i] forState:UIControlStateSelected];
        btn.frame = CGRectMake(0, offY, kMenuBtnWidth, kMenuBtnHeight);
        [btn addTarget:self action:@selector(menuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.menuBar addSubview:btn];
        [_menuBtns addObject:btn];
    }
}

#pragma mark - Actions
- (void)send
{
//    [self.textView resignFirstResponder];
    NSString *text = _textView.text;
    if (!NSStringIsEmpty(text)) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:text forKey:@"status"];
        [self.sinaweibo requestWithURL:@"statuses/update.json" params:params httpMethod:@"POST" finished:^(id result) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
    }
}

- (void)menuBtnAction:(UIButton *)button
{
    switch (button.tag) {
        case 0: //location
        {
            LocationViewController *locationViewController = [[LocationViewController alloc] init];
            locationViewController.showHomeButton = NO;
            locationViewController.LocationSelectedBlock = ^(NSDictionary *location) {
//                NSLog(@"%@", location);
                NSString *title = location[@"title"];
                if (!NSStringIsEmpty(title)) {
                    _locationLabel.text = title;
                    [_locationLabel sizeToFit];
                    _locationViewbg.width = _locationLabel.right - _locationViewbg.left + _locationViewbg.image.capInsets.right;
                    _locationView.width = _locationViewbg.left - _locationView.left;
                    _locationView.hidden = NO;
                }
            };
            [self.navigationController pushViewController:locationViewController animated:YES];
            [locationViewController release];
            break;
        }
        default:
            break;
    }
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardAction:(NSNotification *)notification
{
    
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    BOOL isPortrait = YES;
    if (orientation == UIInterfaceOrientationLandscapeLeft
        || orientation == UIInterfaceOrientationLandscapeRight) {
        isPortrait = NO;
    }
    
    NSValue *frameValue = notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect frame = [frameValue CGRectValue];
    
    NSNumber *animDurationNumber = notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"];
    float animDuration = [animDurationNumber floatValue];
    
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:UIKeyboardWillShowNotification]) {
        _isKeyboardHidden = NO;
        [UIView animateWithDuration:animDuration animations:^{
            self.menuBar.bottom = self.view.height - (isPortrait ? frame.size.height : frame.size.width);
            self.textView.height = self.menuBar.top;
            self.locationView.bottom = self.menuBar.top;
        }];
    } else if ([notificationName isEqualToString:UIKeyboardWillHideNotification]) {
        _isKeyboardHidden = YES;
        [UIView animateWithDuration:animDuration animations:^{
            self.menuBar.bottom = self.view.height;
            self.textView.height = self.menuBar.top;
            self.locationView.bottom = self.menuBar.top;
        }];
    }
}

@end
