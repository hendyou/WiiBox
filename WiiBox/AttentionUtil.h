//
//  AttentionUtil.h
//  GettingAttention
//
//  Created by Hendy Ou on 13-3-9.
//  Copyright (c) 2013年 Hendy Ou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AttentionUtil : NSObject

+ (UIAlertView *) createOKAlertWithTitle: (NSString *) title
                                 message: (NSString *) message
                       cancelButtonTitle: (NSString *) cancelButtonTitle;

+ (void) playSystemSound: (NSString *) soundFileName;

+ (void) playAlertSound: (NSString *) soundFileName;

+ (void) vibrate;

@end
