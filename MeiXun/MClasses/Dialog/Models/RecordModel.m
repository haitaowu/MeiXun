//
//  RecordModel.m
//  MeiXun
//
//  Created by taotao on 2017/8/22.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "RecordModel.h"
#import <objc/runtime.h>

@implementation RecordModel

#pragma mark - override methods
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

- (id)mutableCopyWithZone:(NSZone *)zone
{
    RecordModel *model = [[RecordModel allocWithZone:zone] init];
    model.name = [self.name copy];
    model.dateStr = [self.dateStr copy];
    model.count = self.count;
    model.avatarData = [self.avatarData copy];
    model.phone = [self.phone copy];
    return model;
}

#pragma mark - private methods
- (NSString*)varKeyWithIvar:(Ivar)var
{
    const char *varType = ivar_getName(var);
    NSString *varTypeStr = [NSString stringWithFormat:@"%s",varType];
    return varTypeStr;
}

- (id)varValueFor:(Ivar)var
{
    id varValue = object_getIvar(self, var);
    return varValue;
}

#pragma mark - override methods
- (NSString*)countStr
{
    NSString *countStr = [NSString stringWithFormat:@"(%@)",self.count];
    return countStr;
}
@end
