//
//  WebViewController.m
//  WiiBox
//
//  Created by Hendy Ou on 13-10-9.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUrl:(NSString *)url
{
    self = [self init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [self.webView loadRequest:request];
    
    //显示网络小圈圈
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_url release];
    [_webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}

#pragma mark - Actions
- (IBAction)goBack:(UIButton *)sender {
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}

- (IBAction)forward:(UIButton *)sender {
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}

- (IBAction)refresh:(UIButton *)sender {
    [_webView reload];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //隐藏网络小圈圈
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
