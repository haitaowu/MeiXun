//
//  MDataUtil.h
//  MeiXun
//
//  Created by taotao on 2017/8/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAccModel.h"

@class PersonModel,RecordModel;


typedef void(^LoadContactsBlock)();
typedef void(^ReLoadContactsBlock)();

@interface MDataUtil : NSObject
@property (nonatomic,strong)MAccModel *accModel;
@property (nonatomic,strong)NSMutableArray *contacts;
@property (nonatomic,strong)NSMutableArray *sections;
@property (nonatomic,strong)NSMutableArray *records;
@property (nonatomic,copy) ReLoadContactsBlock reloadContactBlock;

+(instancetype)shareInstance;
- (void)archiveAccModel:(MAccModel*)accModel;
- (void)loadContactsWithBlock:(LoadContactsBlock)loadBlock;
//用户在联系人界面拨打，将被拨打的联系人存储到通话记录数据中。
- (void)saveRecordWithContact:(PersonModel*)personModel phone:(NSString*)phone;

//用户点击通话记录进行拨打，将被拨打的通话记录进行存储
- (void)saveRecordWithPhone:(NSString*)phone;

//删除一个通话记录之后更新本地通话记录文档
-(void)updateRecordDataAfterDeleteRecord;

//根据手机号码查询联系人模型。
- (PersonModel*)queryPersonWithPhone:(NSString*)phoneNum;

//检查用户是否登录过
- (BOOL)userIsLogin;
//对字符串进行aes加密
+ (NSString*)encryptStringWithStr:(NSString*)string;

/**
 检索通讯录中联系人数量来确定是否需要同步到本地
 */
- (void)shouldSynchronizeAddressBookToLocalContacts;

/**
 des加密
 */
+ (NSString *) encodingDES:(NSString *) desString;

/**
 uncompletion SKPaymentTransaction
 */
+ (NSMutableArray *) unCompletionTrans;

/**
 save uncompletion SKPaymentTransaction
 */
+ (void) saveunCompletionTrans:(NSArray*)trans;

/**
 submite uncompletion recipt validate
 */
+ (void)checkUnCompletionTransAndSubmit;

@end
       
