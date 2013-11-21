//
//  DateUtil.h
//  MyUtils
//
//  Created by Hendy Ou on 13-8-22.
//  Copyright (c) 2013年 Hendy Ou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSString *) formatDate: (NSString *) format fromDate:(NSDate *) date;

+ (NSDate *) formatDate:(NSString*)format fromString:(NSString*)string;

//Format date string like this: Tue May 31 17:46:55 +0800 2011(E MMM dd HH:mm:ss Z yyyy) 
+ (NSString *) formatDate:(NSString*)format fromSina:(NSString*)sinaDate;

@end
