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
#import "MDataManagerUtil.h"
#import <AddressBook/AddressBook.h>
#import "SecurityUtil.h"



#define  kLibPath               NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
#define kAccountInfoPath            [kLibPath stringByAppendingPathComponent:@"accountInfo.data"]
#define kRecordsInfoPath            [kLibPath stringByAppendingPathComponent:@"recordInfos.data"]
#define kContactsInfoPath            [kLibPath stringByAppendingPathComponent:@"contacts.data"]

#define kSectionTitleKey            @"sectionTitleKey"



static MDataUtil *instance = nil;


@interface MDataUtil()
@property (nonatomic,strong)NSArray *sectionTitles;
@property (nonatomic,assign) BOOL granted;
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

//添加记录之后归档用户通话记录数据
- (void)archiveRecordsData
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if ([_records count] > 0) {
        dispatch_async(queue, ^{
            NSArray *deepCopiedRecords = [self deepMutableArray:_records];
            [NSKeyedArchiver archiveRootObject:deepCopiedRecords toFile:kRecordsInfoPath];
        });
    }
}

//删除记录之后归档用户通话记录数据
- (void)archiveRecordsDataAfterDelete
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [NSKeyedArchiver archiveRootObject:_records toFile:kRecordsInfoPath];
    });
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
//除去 包含+86 、- 格式的手机号码，统一处理为11位的手机号码
- (NSString*)elevenPhoneNumWithStr:(NSString*)phoneValue
{
    phoneValue = [phoneValue stringByReplacingOccurrencesOfString:@"+" withString:@""];
    phoneValue = [phoneValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (phoneValue.length == 13) {
        NSInteger len = 11;
        NSInteger loc = phoneValue.length - len;
        NSRange range = NSMakeRange(loc, len);
        phoneValue = [phoneValue substringWithRange:range];
    }
    return phoneValue;
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
            phoneValue = [self elevenPhoneNumWithStr:phoneValue];
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
        
        //1.4加载联系人公司名称。
        NSString *organization = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        personModel.organization = organization;
        
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
    [self.sections removeAllObjects];
    [self.contacts removeAllObjects];
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

//加载已经归档的联系人数据。
- (NSMutableArray*)loadArchivedContacts
{
   NSArray *contacts = [NSKeyedUnarchiver unarchiveObjectWithFile:kContactsInfoPath];
    if (contacts == nil) {
        return nil;
    }else{
        return [NSMutableArray arrayWithArray:contacts];
    }
}

//section title 的数据 A B C D.....
- (NSMutableArray*)loadArchivedSectionTitles
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefault objectForKey:kSectionTitleKey];
    return [NSMutableArray arrayWithArray:array];
}


//将联系人与section title 归档到本地。
- (void)archiveToLocalForContacts:(NSMutableArray*) contacts titles:(NSMutableArray*) titles
{
    if (contacts != nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        dispatch_async(queue, ^{
            NSArray *sections = [titles mutableCopy];
            [userDefault setObject:sections forKey:kSectionTitleKey];
            NSArray *deepCopiedContacts = [self deepMutableArray:_contacts];
            [NSKeyedArchiver archiveRootObject:deepCopiedContacts toFile:kContactsInfoPath];
        });
    }
}

//深拷贝容器类中的自定义类。
- (NSMutableArray*)deepMutableArray:(NSArray*)array
{
    NSMutableArray *deepArray = [NSMutableArray array];
    for (id obj in array) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *mutableArray = [self deepMutableArray:obj];
            [deepArray addObject:mutableArray];
        }else{
            [deepArray addObject:[obj mutableCopy]];
        }
    }
    return deepArray;
}

//相同号码此次拨打距上次拨打的时间是否超出24小时。
- (BOOL)shouldAddRecordFor:(RecordModel*)recordModel
{
    NSDate *recordDate = [recordModel.dateStr dateForStr];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:recordDate];
    NSTimeInterval maxInterval = 60 * 60 * 24;
    if (interval < maxInterval) {
        return NO;
    }else{
        return YES;
    }
}

//根据record model 更新当前 通话记录 数组。
- (void)recordsDataUpdateWith:(RecordModel*)recordModel
{
    if ([self shouldAddRecordFor:recordModel] == YES) {
        RecordModel *recordNew = [recordModel mutableCopy];
        recordNew.count = @1;
        recordNew.dateStr = [NSString currentDateTime];
        [self.records insertObject:recordNew atIndex:0];
    }else{
        NSInteger count = [recordModel.count integerValue];
        recordModel.count = @(count + 1);
        recordModel.dateStr = [NSString currentDateTime];
        [self.records removeObject:recordModel];
        [self.records insertObject:recordModel atIndex:0];
    }
}

//添加服务号
- (void)addMeiServicePhoneNum
{
    NSString *name = @"美讯服务号";
    NSString *num = @"028-69514101";
    NSString *label = @"服务号";
    // 创建一条空的联系人
    ABRecordRef record = ABPersonCreate();
    CFErrorRef error;
    // 设置联系人的名字
    ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)name, &error);
    // 添加联系人电话号码以及该号码对应的标签名
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)num, (__bridge CFTypeRef)label, NULL);
    ABRecordSetValue(record, kABPersonPhoneProperty, multi, &error);
    UIImage *image = [UIImage imageNamed:@"aboutusIcon"];
    NSData *avatarData = UIImagePNGRepresentation(image);
    ABPersonSetImageData(record, (__bridge CFDataRef)(avatarData), &error);
    ABAddressBookRef addressBook = ABAddressBookCreate();
    // 将新建联系人记录添加如通讯录中
    ABAddressBookAddRecord(addressBook, record, &error);
    // 如果添加记录成功，保存更新到通讯录数据库中
    ABAddressBookSave(addressBook, &error);
    CFRelease(addressBook);
    CFRelease(record);
}

//统计本地存储的联系人 数量。
- (NSInteger)localContactsCount
{
    NSInteger count = 0;
    for (NSArray *array in self.contacts) {
        count = count + [array count];
    }
    return count;
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
    [self archiveAccModelToLocal];
}

//归档用户信息的数据2
- (void)archiveAccModelToLocal
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

//加载联系人
- (void)loadContactsWithBlock:(LoadContactsBlock)loadBlock
{
    ABAddressBookRef bookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
        HTLog(@"addressbook authorization is = %d",granted);
        self.granted = granted;
        if (granted == YES) {
            NSMutableArray *contacts = [self loadArchivedContacts];
            if (contacts == nil) {
                [self addMeiServicePhoneNum];
                //第一次加载通讯录里的联系人
                [self generaContactsAndSections];
//                [self archiveContactsTitlesToLocal];
                [self archiveToLocalForContacts:_contacts titles:_sections];
            }else{
                _contacts = contacts;
                _sections = [self loadArchivedSectionTitles];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            loadBlock();
        });
        [self shouldSynchronizeAddressBookToLocalContacts];
    });
}

//用户在联系人界面拨打，将被拨打的联系人存储到通话记录数据中。
- (void)saveRecordWithContact:(PersonModel*)personModel phone:(NSString*)phone
{
    RecordModel *recordModel = [self recordWithNumber:phone];
    if(recordModel == nil){
        recordModel = [[RecordModel alloc] init];
        recordModel.phone = phone;
        if (personModel != nil) {
            recordModel.name = personModel.name;
            recordModel.avatarData = personModel.avatarData;
        }else{
            recordModel.name = phone;
        }
        recordModel.count = @(1);
        recordModel.dateStr = [NSString currentDateTime];
        NSString *locNumber = phone;
        if (phone.length > 7) {
            NSInteger len = 7;
            NSInteger loc = 0;
            NSRange range = NSMakeRange(loc, len);
            locNumber = [phone substringWithRange:range];
        }
        recordModel.locStr = [[MDataManagerUtil shareInstance] locationForNumber:locNumber];
        
        [self.records insertObject:recordModel atIndex:0];
    }else{
        [self recordsDataUpdateWith:recordModel];
    }
    if ([self.records count] >= 50) {
        NSRange range = NSMakeRange(0, 50);
        NSArray *array = [self.records subarrayWithRange:range];
        self.records = [NSMutableArray arrayWithArray:array];
    }
    [self archiveRecordsData];
}




//用户点击通话记录进行拨打，将被拨打的通话记录进行存储
- (void)saveRecordWithPhone:(NSString*)phone
{
    RecordModel *recordModel = [self recordWithNumber:phone];
    [self recordsDataUpdateWith:recordModel];
    if ([self.records count] >= 50) {
        NSRange range = NSMakeRange(0, 50);
        NSArray *array = [self.records subarrayWithRange:range];
        self.records = [NSMutableArray arrayWithArray:array];
    }
    [self archiveRecordsData];
}

//删除一个通话记录之后更新本地通话记录文档
-(void)updateRecordDataAfterDeleteRecord
{
    [self archiveRecordsDataAfterDelete];
}

//根据手机号码查询联系人模型。
- (PersonModel*)queryPersonWithPhone:(NSString*)phoneNum
{
    for (NSArray *contactArray in self.contacts) {
        for (PersonModel *model in contactArray) {
            for (NSString *phone in model.phoneNums) {
                if ([phoneNum isEqualToString:phone]) {
                    return model;
                }
            }
        }
    }
    return  nil;
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

//对字符串进行aes加密
+ (NSString*)encryptStringWithStr:(NSString*)string
{
    NSString *leKey = @"20160520";
    NSString *encryptedStr128 = [SecurityUtil encryptAESBase64:string key:leKey];
    NSString *encryptedStr256 = [SecurityUtil encryptAESData:string];
    HTLog(@"128 = %@ , 256 = %@",encryptedStr128,encryptedStr256);
    NSString *str = @"3f66299552658aa6";
    
    return str;
}

//在通讯录联系人添加、删除之后重新读取通讯录并存储到本地。
- (void)reloadAfterContactsModified
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSMutableArray *contactsArray = [NSMutableArray array];
        NSMutableArray *sectionsArray = [NSMutableArray array];
        NSMutableArray *rawContacts = [self allRawContacts];
        for (NSString *sectionTitle in self.sectionTitles) {
            NSMutableArray *sectionContacts = [NSMutableArray array];
            for (PersonModel *person in rawContacts) {
                if ([person.nameFirstChar isEqualToString:sectionTitle]) {
                    [sectionContacts addObject:person];
                }
            }
            if ([sectionContacts count] > 0) {
                [sectionsArray addObject:sectionTitle];
                [contactsArray addObject:sectionContacts];
            }
        }
        _sections = sectionsArray;
        _contacts = contactsArray;
        [self archiveToLocalForContacts:contactsArray titles:sectionsArray];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self.reloadContactBlock != nil) {
                self.reloadContactBlock();
            }
        });
    });
}


/**
 检索通讯录中联系人数量来确定是否需要同步到本地
 */
- (void)shouldSynchronizeAddressBookToLocalContacts
{
    if (self.granted == YES) {
        ABAddressBookRef bookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        CFIndex count = ABAddressBookGetPersonCount(bookRef);
        NSInteger personCount = count;
        if (personCount != [self localContactsCount]) {
            HTLog(@"联系人数量不不一致");
            [self reloadAfterContactsModified];
//            [self generaContactsAndSections];
//            [self archiveContactsTitlesToLocal];
        }else{
            HTLog(@"联系人数量没有变化");
        }
    }
}

@end
