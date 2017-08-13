//
//  MAccModel.m
//  MeiXun
//
//  Created by taotao on 2017/8/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MAccModel.h"
#import <objc/runtime.h>
@implementation MAccModel
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    unsigned int count = 0;
    Ivar *vars = class_copyIvarList([self class], &count);
    for (unsigned int idx = 0; idx < count; idx ++) {
        Ivar var = vars[idx];
        id varVal = [self varValueFor:var];
        NSString *varKey = [self varKeyWithIvar:var];
        [aCoder encodeObject:varVal forKey:varKey];
    }
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    unsigned int count = 0;
    Ivar *vars = class_copyIvarList([self class], &count);
    for (unsigned int idx = 0; idx < count; idx ++) {
        Ivar var = vars[idx];
        NSString *varKey = [self varKeyWithIvar:var];
        id varVal = [aDecoder decodeObjectForKey:varKey];
        object_setIvar(self, var, varVal);
    }
    return self;
}


#pragma mark - private methods
- (id)varValueFor:(Ivar)var
{
    id varValue = object_getIvar(self, var);
    return varValue;
}

- (NSString*)varKeyWithIvar:(Ivar)var
{
    const char *varType = ivar_getTypeEncoding(var);
    NSString *varTypeStr = [NSString stringWithFormat:@"%s",varType];
    return varTypeStr;
}

@end
