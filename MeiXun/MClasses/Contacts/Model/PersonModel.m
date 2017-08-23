//
//  PersonModel.m
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PersonModel.h"
#import "PinYin4Objc.h"
#import <objc/runtime.h>
#import "NSString+Extension.h"

@implementation PersonModel
#pragma mark - override methods

- (id)mutableCopyWithZone:(NSZone *)zone
{
    PersonModel *model = [[PersonModel allocWithZone:zone] init];
    model.name = [self.name mutableCopy];
    model.firstName = [self.firstName mutableCopy];
    model.lastName = [self.lastName copy];
    model.pinYinName = [self.pinYinName copy];
    model.nameFirstChar = [self.nameFirstChar copy];
    model.avatarData = [self.avatarData copy];
    model.phoneNums = [self.phoneNums copy];
    return model;
}

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

#pragma mark -  getter methods
- (NSString*)name
{
    NSString *firstNam = _firstName == nil?@"":_firstName;
    NSString *lastNam = _lastName == nil?@"":_lastName;
    _name = [NSString stringWithFormat:@"%@%@",lastNam,firstNam];
    return _name;
}

- (NSString *)nameFirstChar
{
    NSString *namePin = self.pinYinName;
    if(([namePin emptyStr]) || (namePin == nil)) {
        _nameFirstChar = @"#";
    }else{
        _nameFirstChar = [NSString stringWithFormat:@"%c",[namePin characterAtIndex:0]];
        _nameFirstChar = [_nameFirstChar uppercaseString];
    }
    return _nameFirstChar;
}

- (NSString *)pinYinName
{
    NSString *nameZh = self.name;
    _pinYinName = [self pinYinWithStr:nameZh];
    return _pinYinName;
}

#pragma mark - private methods
- (NSString*)pinYinWithStr:(NSString*)string
{
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:string withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
    return  outputPinyin;
}

#pragma mark - private methods
- (id)varValueFor:(Ivar)var
{
    id varValue = object_getIvar(self, var);
    return varValue;
}

- (NSString*)varKeyWithIvar:(Ivar)var
{
    const char *varType = ivar_getName(var);
    NSString *varTypeStr = [NSString stringWithFormat:@"%s",varType];
    return varTypeStr;
}

@end
