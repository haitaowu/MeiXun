//
//  RecordModel.h
//  MeiXun
//
//  Created by taotao on 2017/8/22.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject<NSMutableCopying>
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *dateStr;
@property (nonatomic,copy) NSString *locStr;
@property (nonatomic,assign) NSNumber *count;
@property (nonatomic,strong) NSData *avatarData;

//拨打次数显示字符
- (NSString*)countStr;
//返回对应格式日期的字符串
- (NSString*)dateString;
@end
