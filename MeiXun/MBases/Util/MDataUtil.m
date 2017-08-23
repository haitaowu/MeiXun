//
//  MDataUtil.m
//  MeiXun
//
//  Created by taotao on 2017/8/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MDataUtil.h"
#import "NSString+Extension.h"
#import "RecordModel.h"
#import "PersonModel.h"
#import <AddressBook/AddressBook.h>



#define  kLibPath               NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
#define kAccountInfoPath            [kLibPath stringByAppendingPathComponent:@"accountInfo.data"]
#define kRecordsInfoPath            [kLibPath stringByAppendingPathComponent:@"recordInfos.data"]




static MDataUtil *instance = nil;


@interface MDataUtil()
@property (nonatomic,strong)NSArray *sectionTitles;
@end

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
//登录用户模型
-(MAccModel *)accModel
{
    if (_accModel == nil) {
        _accModel = [self unArchiveUserModel];
    }
    return _accModel;
}
//通话记录数组
-(NSMutableArray *)records
{
    if(_records == nil)
    {
        _records = [self unArchiveRecordsData];
    }
    return _records;
}
//联系人数组
-(NSMutableArray *)contacts
{
    if(_contacts== nil)
    {
        _contacts = [[NSMutableArray alloc] init];
    }
    return _contacts;
}
//分区数组
-(NSMutableArray *)sections
{
    if(_sections== nil)
    {
        _sections = [[NSMutableArray alloc] init];
    }
    return _sections;
}

-(NSArray*)sectionTitles
{
    if(_sectionTitles == nil)
    {
        _sectionTitles = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    }
    return _sectionTitles;
}

#pragma mark - private methods
//查询该拨打号码是否已经在通话记录存在？
- (RecordModel*)recordWithNumber:(NSString*)phone
{
    for (RecordModel *recordModel in self.records) {
        if ([recordModel.phone isEqualToString:phone]) {
            return recordModel;
        }
    }
    return nil;
}

//从文件中读取已登录用户的信息
- (MAccModel*)unArchiveUserModel
{
    _accModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kAccountInfoPath];
    return _accModel;
}

//归档用户通话记录数据
- (void)archiveRecordsData
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if ([_records count] > 0) {
        dispatch_async(queue, ^{
            [NSKeyedArchiver archiveRootObject:_records toFile:kRecordsInfoPath];
        });
    }
}

//解档通话记录数据
- (NSMutableArray*)unArchiveRecordsData
{
    NSArray *recordAray = [NSKeyedUnarchiver unarchiveObjectWithFile:kRecordsInfoPath];
    if (recordAray != nil) {
        return [NSMutableArray arrayWithArray:recordAray];
    }else{
        return [NSMutableArray array];;
    }
}

- (NSMutableArray*)allRawContacts
{
    NSMutableArray *personModels = [NSMutableArray array];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex peopleCount = CFArrayGetCount(peopleArray);
    // 1.遍历所有的联系人
    for (int i = 0; i < peopleCount; i++) {
        PersonModel *personModel = [[PersonModel alloc] init];
        // 1.1.获取某一个联系人
        ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
        // 1.1.1获取联系人的姓名
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        personModel.firstName = firstName;
        personModel.lastName = lastName;
        
        // 1.2获取所有的电话号码
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        
        // 1.2.1遍历拿到每一个电话号码
        NSMutableArray *numbers = [NSMutableArray array];
        for (int i = 0; i < phoneCount; i++) {
            // 2.获取电话号码
            NSString *phoneValue = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            [numbers addObject:phoneValue];
        }
        //1.3取得联系人的头像
        bool hasIamge = ABPersonHasImageData(person);
        if (hasIamge) {
           NSData *avatarData = (__bridge NSData*) ABPersonCopyImageData(person);
            personModel.avatarData = avatarData;
        }else{
            personModel.avatarData = nil;
        }
        
        personModel.phoneNums = numbers;
        [personModels addObject:personModel];
        CFRelease(phones);
    }
//    HTLog(@"thread = %@",[NSThread currentThread]);
    
    CFRelease(addressBook);
    CFRelease(peopleArray);
    return personModels;
}

- (void)generaContactsAndSections
{
    NSMutableArray *rawContacts = [self allRawContacts];
    for (NSString *sectionTitle in self.sectionTitles) {
        NSMutableArray *sectionContacts = [NSMutableArray array];
        for (PersonModel *person in rawContacts) {
            if ([person.nameFirstChar isEqualToString:sectionTitle]) {
                [sectionContacts addObject:person];
            }
        }
        if ([sectionContacts count] > 0) {
            [self.sections addObject:sectionTitle];
            [self.contacts addObject:sectionContacts];
        }
    }
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

//归档用户信息的数据1
- (void)archiveAccModel:(MAccModel*)accModel
{
    _accModel = accModel;
    [self archiveAccModel];
}

//归档用户信息的数据2
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
    ABAddressBookRef bookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
        HTLog(@"addressbook authorization is = %d",granted);
        if (granted == YES) {
            [self generaContactsAndSections];
            dispatch_async(dispatch_get_main_queue(), ^{
                loadBlock();
            });
        }
    });
}

//用户在联系人界面拨打，将被拨打的联系人存储到通话记录数据中。
- (void)saveRecordWithContact:(PersonModel*)personModel phone:(NSString*)phone
{
    RecordModel *recordModel = [self recordWithNumber:phone];
    if(recordModel == nil){
        recordModel = [[RecordModel alloc] init];
        recordModel.phone = phone;
        recordModel.name = personModel.name;
        recordModel.avatarData = personModel.avatarData;
        recordModel.count = @(1);
        recordModel.dateStr = [NSString currentDateTime];
        [self.records insertObject:recordModel atIndex:0];
    }else{
        recordModel.dateStr = [NSString currentDateTime];
        NSInteger count = [recordModel.count integerValue];
        recordModel.count = @(count + 1);
    }
    
    if ([self.records count] >= 50) {
        NSRange range = NSMakeRange(0, 50);
        NSArray *array = [self.records subarrayWithRange:range];
        self.records = [NSMutableArray arrayWithArray:array];
    }
    [self archiveRecordsData];
}

//用户点击通话记录进行拨打，将被拨打的通话记录进行存储
- (void)saveRecordWithRecord:(RecordModel*)personModel phone:(NSString*)phone
{
    RecordModel *recordModel = [self recordWithNumber:phone];
    recordModel.dateStr = [NSString currentDateTime];
    NSInteger count = [recordModel.count integerValue];
    recordModel.count = @(count + 1);
    [self.records removeObject:recordModel];
    [self.records insertObject:recordModel atIndex:0];
    
    if ([self.records count] >= 50) {
        NSRange range = NSMakeRange(0, 50);
        NSArray *array = [self.records subarrayWithRange:range];
        self.records = [NSMutableArray arrayWithArray:array];
    }
    [self archiveRecordsData];
}

//检查用户是否登录过
- (BOOL)userIsLogin
{
    if (self.accModel == nil) {
        return NO;
    }else{
        return YES;
    }
}

@end
