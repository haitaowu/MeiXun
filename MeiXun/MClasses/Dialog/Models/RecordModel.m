//
//  RecordModel.m
//  MeiXun
//
//  Created by taotao on 2017/8/22.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "RecordModel.h"
#import <objc/runtime.h>
#import "NSString+Extension.h"

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
    model.name = [self.name mutableCopy];
    model.dateStr = [self.dateStr mutableCopy];
    model.count = self.count;
    model.avatarData = [self.avatarData mutableCopy];
    model.phone = [self.phone mutableCopy];
    model.locStr = [self.locStr mutableCopy];
    return model;
}

- (NSString*)dateString;
{
    if ([self.dateStr dateStrIsToday] == YES) {
        return [self.dateStr hhMMString];
    }else{
        return [self.dateStr YMDString];
    }
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
