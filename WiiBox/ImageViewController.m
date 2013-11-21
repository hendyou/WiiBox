//
//  ImageViewController.m
//  WiiBox
//
//  Created by Hendy Ou on 13-10-15.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "ImageViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

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
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.image = _startImage;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    tap.numberOfTapsRequired = 1;
    _scrollView.delegate = self;
    [_scrollView addGestureRecognizer:tap];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self centerImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self downloadImage];
}

- (void)dealloc {
    [_imageUrl release];
    [_startImage release];
    [_scrollView release];
    [_imageView release];
    [super dealloc];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UI
- (void)setupImage:(UIImage *)image
{
    self.imageView.contentMode = UIViewContentModeCenter;
    
    CGRect rect = CGRectZero;
    rect.size = image.size;
    self.imageView.frame = rect;
    self.imageView.image = image;
    
    self.scrollView.contentSize = rect.size;
    float scaleX = self.scrollView.bounds.size.width / rect.size.width;
    float scaleY = self.scrollView.bounds.size.height / rect.size.height;
    float scale = MIN(scaleX, scaleY);
    
    if (scaleX > 1.0 && scaleY > 1.0) {
        scale = 1.0;
    }
    
    self.scrollView.minimumZoomScale = scale;
    self.scrollView.maximumZoomScale = scale * 3;
    self.scrollView.zoomScale = scale;
}

- (void)centerImage
{
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect frameToCenter = _imageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
	} else {
        frameToCenter.origin.x = 0;
	}
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
	} else {
        frameToCenter.origin.y = 0;
	}
    
	// Center
	if (!CGRectEqualToRect(_imageView.frame, frameToCenter))
		_imageView.frame = frameToCenter;
}

#pragma mark - Private methods
- (void)downloadImage
{
    if (!NSStringIsEmpty(_imageUrl)) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *url = [NSURL URLWithString:_imageUrl];
        if (url)
        {
            [manager downloadWithURL:url delegate:self];
        }
    }
}

#pragma mark - SDWebImageManagerDelegate
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self setupImage:image];
    
    [self centerImage];
    
}

#pragma mark - Actions
- (void)dismiss:(UITapGestureRecognizer *)gesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerImage];
}
@end
