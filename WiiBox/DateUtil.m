//
//  DateUtil.m
//  MyUtils
//
//  Created by Hendy Ou on 13-8-22.
//  Copyright (c) 2013年 Hendy Ou. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+ (NSString *)formatDate:(NSString *)format fromDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *dateStr = [dateFormat stringFromDate: date];
    [dateFormat release];
    return dateStr;
}

+ (NSDate *) formatDate:(NSString*)format fromString:(NSString*)string
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSDate *date = [dateFormat dateFromString:string];
    [dateFormat release];
    return date;
}

+ (NSString *) formatDate:(NSString*)format fromSina:(NSString*)sinaDate
{
    //Tue May 31 17:46:55 +0800 2011
    //from:  E MMM dd HH:mm:ss Z yyyy
    //  to:  MM-dd hh:mm
    NSDate *date = [DateUtil formatDate:@"E MMM dd HH:mm:ss Z yyyy" fromString:sinaDate];
    NSString *dateStr = [DateUtil formatDate:format fromDate:date];
    return dateStr;
}

@end
