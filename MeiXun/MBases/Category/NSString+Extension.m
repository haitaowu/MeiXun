//
//  NSString+Extension.m
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
- (BOOL)emptyStr
{
    if (self.length <= 0) {
        return YES;
    }else{
        return NO;
    }
}

@end
