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


/**
 return yyyy/MM/dd formate date string
 */
- (NSString*)YMDString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:self];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    return [dateFormatter stringFromDate:date];
}


/**
 return whether date String is today
 */
- (BOOL)dateStrIsToday
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *recordDate = [self dateForStr];
    NSInteger unitFlags = NSCalendarUnitDay|kCFCalendarUnitMonth|kCFCalendarUnitYear;
    NSDateComponents *cmps = [calender components:unitFlags fromDate:recordDate toDate:[NSDate date] options:0];
    if ((cmps.year == 0) && (cmps.month == 0) && (cmps.day == 0)){
        return YES;
    }else{
        return NO;
    }
}

/**
 validate the phon number format
 */
- (BOOL)rightPhoneNumFormat
{
    NSString *regex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [phonePredicate evaluateWithObject:self];
}


@end
