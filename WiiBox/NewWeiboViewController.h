//
//  NewWeiboViewController.h
//  WiiBox
//
//  Created by Hendy Ou on 13-10-10.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "BaseViewController.h"
#import "GCPlaceholderTextView.h"

@interface NewWeiboViewController : BaseViewController
{
    NSMutableArray *_menuBtns;
    BOOL _isKeyboardHidden;
}
@property (retain, nonatomic) IBOutlet GCPlaceholderTextView *textView;

@property (retain, nonatomic) IBOutlet UIView *menuBar;
@end
