//
//  HeaderImageView.h
//  WiiBox
//
//  Created by Hendy Ou on 13-10-8.
//  Copyright (c) 2013年 Hendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderImageView : UIImageView

@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *imageUrl;

- (void)goToUser;

@end
