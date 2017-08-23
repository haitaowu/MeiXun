//
//  NSString+Extension.m
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
#pragma mark - public methods
- (BOOL)emptyStr
{
    if (self.length <= 0) {
        return YES;
    }else{
        return NO;
    }
}

/**
 当前时间的字符串格式 yyyy-MM-dd hh:mm:ss
 */
+ (NSString*)currentDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}


/**
 return NSDate object by date string
 */
- (NSDate*)dateForStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:self];
}

/**
 return hh:mm formate date string
 */
- (NSString*)hhMMString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:self];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:date];
}


@end
