//
//  WebViewController.h
//  WiiBox
//
//  Created by Hendy Ou on 13-10-9.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController<UIWebViewDelegate>

@property (copy, nonatomic) NSString *url;

@property (retain, nonatomic) IBOutlet UIWebView *webView;

- (id)initWithUrl:(NSString *)url;

- (IBAction)goBack:(UIButton *)sender;
- (IBAction)forward:(UIButton *)sender;
- (IBAction)refresh:(UIButton *)sender;

@end
