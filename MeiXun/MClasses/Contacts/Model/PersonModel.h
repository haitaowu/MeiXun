//
//  PersonModel.h
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject<NSMutableCopying>
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *firstName;
@property (nonatomic,copy) NSString *lastName;
@property (nonatomic,copy) NSString *pinYinName;
@property (nonatomic,strong)NSMutableArray *phoneNums;
@property (nonatomic,strong)NSData *avatarData;
@property (nonatomic,copy) NSString *nameFirstChar;

@end
