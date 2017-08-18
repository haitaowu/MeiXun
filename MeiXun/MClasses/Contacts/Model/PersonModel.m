//
//  PersonModel.m
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PersonModel.h"
#import "PinYin4Objc.h"
#import "NSString+Extension.h"

@implementation PersonModel
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
@end
