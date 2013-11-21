//
//  WeiboView.m
//  WiiBox
//
//  Created by Hendy on 13-9-16.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "WeiboView.h"
#import "UIFactory.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"
#import "UserViewController.h"
#import "WebViewController.h"
#import "ImageViewController.h"
#import "AppDelegate.h"

#define ListFont 14.0f
#define ListRepostFont 12.5f
#define DetailFont 18
#define DetailRepostFont 16.5f

@implementation WeiboView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initViews];
        _parseText = [[NSMutableString string] retain];
    }
    return self;
}

- (void)dealloc
{
    [_textLabel release];
    [_imageView release];
    [_retweetedBackgroundView release];
    [_retweetedView release];
    [_weiboModel release];
    [_parseText release];
    [super dealloc];
}

- (void)initViews
{
    //转发视图背景
    _retweetedBackgroundView = [[UIFactory createImageView:@"timeline_retweet_background.png"] retain];
    UIEdgeInsets insets = UIEdgeInsetsMake(11, 26, 5, 4);
    _retweetedBackgroundView.image = [_retweetedBackgroundView.image resizableImageWithCapInsets:insets];
    _retweetedBackgroundView.insets = insets;
    [self addSubview:_retweetedBackgroundView];
    
    //微博内容
    _textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _textLabel.delegate = self;
    _textLabel.font = [UIFont systemFontOfSize:14.0f];
    _textLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
    _textLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"red" forKey:@"color"];
    [self addSubview:_textLabel];
    
    //微博图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.image = [UIImage imageNamed:@"page_image_loading.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
    //添加点击浏览图片
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    imageTap.numberOfTapsRequired = 1;
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:imageTap];
    
}

- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel = [weiboModel retain];
    }
    
    if (_retweetedView == nil) {
        _retweetedView = [[WeiboView alloc] initWithFrame:CGRectZero];
        _retweetedView.isRetweeted = YES;
        [self addSubview:_retweetedView];
    }
    
    [self parseLink];
}

- (void) parseLink
{
    [_parseText setString:@""];
    
    //判断是否为转发微博(是:加入@作者)
    if (self.isRetweeted) {
         NSString *authorName = _weiboModel.user.screen_name;
        [_parseText appendFormat:@"<a href='user://%@'>%@</a>: ", [authorName URLEncodedString], authorName];
    }
    
    //解析
    NSString *text = _weiboModel.text;
    NSString *regex1 = @"@\\w+";    //@人
    NSString *regex2 = @"#\\w+#";    //#话题
    NSString *regex3 = @"[a-zA-z]+://[^\\s]*"; //链接
    
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)", regex1, regex2, regex3];
    
    NSArray *matchArray = [text componentsMatchedByRegex:regex];
    for (NSString *str in matchArray) {
        //<a href='user://@用户'></a>
        //<a href='http://abc'>http://abc</a>
        //<a href='topic://#话题#'>#话题#</a>
        
        NSString *replace = nil;
        if ([str hasPrefix:@"@"]) {
            replace = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>", [str URLEncodedString], str];
        } else if ([str hasPrefix:@"http"]) {
            replace = [NSString stringWithFormat:@"<a href='%@'>%@</a>", str, str];
        } else if ([str hasPrefix:@"#"]) {
            replace = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>", [str URLEncodedString], str];
        }
        
        if (replace != nil) {
            text = [text stringByReplacingOccurrencesOfString:str withString:replace];
        }
    }
    
    [_parseText appendString:text];
    
}

- (void)layoutWeiboContent
{
    //是否为转发视图
    if (self.isRetweeted) {
        _textLabel.frame = CGRectMake(10, 10, kWeiboWidth - 20, 0);
    } else {
        _textLabel.frame = CGRectMake(10, 5, kWeiboWidth, 20);
    }
    //获取字体大小
    float fontSize = [WeiboView fontSize:self.isDetail isRepost:self.isRetweeted];
    _textLabel.font = [UIFont systemFontOfSize:fontSize];
    _textLabel.text = _parseText;
    //文本内容尺寸
    CGSize textSize = _textLabel.optimumSize;
    _textLabel.height = textSize.height;
}

- (void)layoutRetweetedWeibo
{
    
    //转发的微博
    WeiboModel *retweetedWeibo = _weiboModel.retweeted;
    if (retweetedWeibo != nil) {
        _retweetedView.isDetail = self.isDetail;
        _retweetedView.weiboModel = retweetedWeibo;
        float height = [WeiboView weiboViewHeight:retweetedWeibo isDetail:self.isDetail isRepost:YES];
        _retweetedView.frame = CGRectMake(10, _textLabel.bottom + 5, kWeiboWidth, height);
        _retweetedView.hidden = NO;
    } else {
        _retweetedView.hidden = YES;
    }
}

//-----------微博图片-------------
- (void)layoutWeiboPic
{
    if (self.isDetail) {
        NSString *thumbnailPicUrl = _weiboModel.bmiddlePic;
        if (NSStringIsEmpty(thumbnailPicUrl)) {
            _imageView.hidden = YES;
        } else {
            _imageView.hidden = NO;
            _imageView.frame = CGRectMake((self.width - 260)/2.0, _textLabel.bottom + 10, 260, kImageDetailHeight);
            
            //加载网络图片
            [_imageView setImageWithURL:[NSURL URLWithString:thumbnailPicUrl]];
        }
    } else {
        //图片浏览模式
        int scanMode = [[NSUserDefaults standardUserDefaults] integerForKey:kCurrentScanMode];
        if (scanMode == 0) {    //小图
            NSString *thumbnailPicUrl = _weiboModel.thumbnailPic;
            if (NSStringIsEmpty(thumbnailPicUrl)) {
                _imageView.hidden = YES;
            } else {
                _imageView.hidden = NO;
                _imageView.frame = CGRectMake(10, _textLabel.bottom + 10, 70, kImageHeight);
                
                //加载网络图片
                [_imageView setImageWithURL:[NSURL URLWithString:thumbnailPicUrl]];
            }
        } else {    //大图
            NSString *thumbnailPicUrl = _weiboModel.bmiddlePic;
            if (NSStringIsEmpty(thumbnailPicUrl)) {
                _imageView.hidden = YES;
            } else {
                _imageView.hidden = NO;
                _imageView.frame = CGRectMake(10, _textLabel.bottom + 10, 140, kImageBigHeight);
                
                //加载网络图片
                [_imageView setImageWithURL:[NSURL URLWithString:thumbnailPicUrl]];
            }
        }
        
        
    }
}


- (void)layoutWeiboBackground
{
    //-----------转发微博的背景-------------
    if (self.isRetweeted) {
        CGRect frame = self.bounds;
        frame.size.height += 30;
        _retweetedBackgroundView.frame = frame;
        _retweetedBackgroundView.hidden = NO;
    } else {
        _retweetedBackgroundView.hidden = YES;
    }
}

//设置布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //-----------微博内容-------------
    [self layoutWeiboContent];
    
    //-----------转发的微博视图-------------
    [self layoutRetweetedWeibo];
    
    //-----------微博图片-------------
    [self layoutWeiboPic];
    
    //-----------转发微博的背景-------------
    [self layoutWeiboBackground];
}

//计算微博视图的高度
+ (CGFloat) weiboViewHeight:(WeiboModel *) weiboModel
                   isDetail:(BOOL)isDetail
                   isRepost:(BOOL) isRepost
{
    /*
     分别计算每一个子视图的高度, 然后相加
     */
    float height = 0;
    
    //计算微博内容高度
    RTLabel *textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    float fontSize = [WeiboView fontSize:isDetail isRepost:isRepost];
    textLabel.font = [UIFont systemFontOfSize:fontSize];
    if (isRepost) {
        textLabel.width = kWeiboWidth - 20;
    } else {
        textLabel.width = kWeiboWidth;
    }
    NSMutableString *weiboText = [NSMutableString string];
    if (isRepost) {
        NSString *authorName = weiboModel.user.screen_name;
        [weiboText appendString:[NSString stringWithFormat:@"%@: ", authorName]];
    }
    [weiboText appendString:weiboModel.text];
    textLabel.text = weiboText;
    height += textLabel.optimumSize.height;
    [textLabel release];
    
    //计算微博图片的高度
    
    
    if (isDetail) {
        NSString *thumbnailImageUrl = weiboModel.bmiddlePic;
        if (!NSStringIsEmpty(thumbnailImageUrl)) {
            height += kImageDetailHeight + 10;
        }
    } else {
        //图片浏览模式
        int scanMode = [[NSUserDefaults standardUserDefaults] integerForKey:kCurrentScanMode];
        if (scanMode == 0) {    //小图
            NSString *thumbnailImageUrl = weiboModel.thumbnailPic;
            if (!NSStringIsEmpty(thumbnailImageUrl)) {
                height += kImageHeight + 10;
            }
        } else {    //大图
            NSString *thumbnailImageUrl = weiboModel.bmiddlePic;
            if (!NSStringIsEmpty(thumbnailImageUrl)) {
                height += kImageBigHeight + 10;
            }
        }

    }
    
    //计算转发微博的高度
    if (weiboModel.retweeted != nil) {
        height += [WeiboView weiboViewHeight:weiboModel.retweeted isDetail:isDetail isRepost:YES] + 20;
    }
    
    return height;
}

//获取字体
+ (float)fontSize:(BOOL)isDetail isRepost:(BOOL)isRepost
{
    float fontSize = 14;
    if (!isDetail && !isRepost) {
        return ListFont;
    } else if (!isDetail && isRepost) {
        return ListRepostFont;
    } else if (isDetail && !isRepost) {
        return DetailFont;
    } else if (isDetail && isRepost) {
        return DetailRepostFont;
    }
    
    return fontSize;
}

#pragma mark - Actions
- (void)imageTap:(UITapGestureRecognizer *)gesture
{
    ImageViewController *imageCtrl = [[ImageViewController alloc] init];
    imageCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UIImageView *imageView = (UIImageView *)gesture.view;
    imageCtrl.startImage = imageView.image;
    imageCtrl.imageUrl = _weiboModel.originalPic;
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.menu presentViewController:imageCtrl animated:YES completion:nil];
    [imageCtrl release];
}

#pragma mark - RTLabelDelegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSString *absoluteString = [url absoluteString];
    if ([absoluteString hasPrefix:@"user"]) {
        NSString *userName = [[url host] URLDecodedString];
        if ([userName hasPrefix:@"@"]) {
            userName = [userName substringFromIndex:1];
        }
        NSLog(@"用户: %@", userName);
        
        UserViewController *viewCtrl = [[UserViewController alloc] init];
        viewCtrl.userName = userName;
        [self.viewController.navigationController pushViewController:viewCtrl animated:YES];
        [viewCtrl release];
    } else if ([absoluteString hasPrefix:@"http"]) {
        NSLog(@"%@", absoluteString);
        WebViewController *webViewCtrl = [[WebViewController alloc] initWithUrl:absoluteString];
        [self.viewController.navigationController pushViewController:webViewCtrl animated:YES];
        [webViewCtrl release];
    } else if ([absoluteString hasPrefix:@"topic"]) {
        NSString *host = [[url host] URLDecodedString];
        NSLog(@"话题: %@", host);
    }
    
    
}

@end
