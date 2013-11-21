//
//  ImageViewController.h
//  WiiBox
//
//  Created by Hendy Ou on 13-10-15.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import "BaseViewController.h"
#import "SDWebImageManagerDelegate.h"

@interface ImageViewController : BaseViewController<UIScrollViewDelegate,SDWebImageManagerDelegate>

@property (copy, nonatomic) NSString *imageUrl; //大图url
@property (retain, nonatomic) UIImage *startImage;   //小图

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;

@end
