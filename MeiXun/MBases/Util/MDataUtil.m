//
//  MDataUtil.m
//  MeiXun
//
//  Created by taotao on 2017/8/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MDataUtil.h"
#import <AddressBook/AddressBook.h>
#import "PinYin4Objc.h"


#define  kLibPath               NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
#define kAccountInfoPath            [kLibPath stringByAppendingPathComponent:@"accountInfo.data"]




static MDataUtil *instance = nil;


@implementation MDataUtil
#pragma mark - override methods
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

#pragma mark - lazy methods
-(MAccModel *)accModel
{
    if (_accModel == nil) {
        return [self unArchiveUserModel];
    }else{
        return _accModel;
    }
}
-(NSMutableArray *)contacts
{
    if(_contacts== nil)
    {
        _contacts = [[NSMutableArray alloc] init];
    }
    return _contacts;
}

-(NSMutableArray *)sections
{
    if(_sections== nil)
    {
        _sections = [[NSMutableArray alloc] init];
    }
    return _sections;
}

#pragma mark - private methods
- (MAccModel*)unArchiveUserModel
{
    _accModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kAccountInfoPath];
    return _accModel;
}

- (void)loadAllContacts
{
    
}

#pragma mark - public methods
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class ] alloc] init];
    });
    return instance;
}

- (void)archiveAccModel:(MAccModel*)accModel
{
    _accModel = accModel;
    [self archiveAccModel];
}

- (void)archiveAccModel
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if (_accModel == nil) {
        [NSKeyedArchiver archiveRootObject:_accModel toFile:kAccountInfoPath];
    }else{
        dispatch_async(queue, ^{
            [NSKeyedArchiver archiveRootObject:_accModel toFile:kAccountInfoPath];
        });
    }
}

- (void)loadContactsWithBlock:(LoadContactsBlock)loadBlock
{
    ABAddressBookRef bookRef = ABAddressBookCreateWithOptions(NULL, NULL);;
    ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
        HTLog(@"addressbook authorization is = %d",granted);
    });
    
    NSString *sourceText=@"沈从文";
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:sourceText withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
    HTLog(@"pinyin = %@",outputPinyin);
}


@end
