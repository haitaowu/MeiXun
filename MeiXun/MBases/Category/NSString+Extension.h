//
//  NSString+Extension.h
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (BOOL)emptyStr;
/**
 当前时间的字符串格式 yyyy-MM-dd hh:mm:ss
 */
+ (NSString*)currentDateTime;
@end
