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

@interface MDataUtil : NSObject
@property (nonatomic,strong)MAccModel *accModel;
@property (nonatomic,strong)NSMutableArray *contacts;
@property (nonatomic,strong)NSMutableArray *sections;
@property (nonatomic,strong)NSMutableArray *records;
+(instancetype)shareInstance;
- (void)archiveAccModel:(MAccModel*)accModel;
- (void)archiveAccModel;
- (void)loadContactsWithBlock:(LoadContactsBlock)loadBlock;
//用户在联系人界面拨打，将被拨打的联系人存储到通话记录数据中。
- (void)saveRecordWithContact:(PersonModel*)personModel phone:(NSString*)phone;

//用户点击通话记录进行拨打，将被拨打的通话记录进行存储
- (void)saveRecordWithPhone:(NSString*)phone;

//检查用户是否登录过
- (BOOL)userIsLogin;
@end
       
