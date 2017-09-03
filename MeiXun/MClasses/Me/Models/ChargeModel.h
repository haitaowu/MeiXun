//
//  ChargeModel.h
//  MeiXun
//
//  Created by taotao on 2017/9/3.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChargeModel : NSObject
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *cardNo;
@property (nonatomic,copy) NSString *rechargeMode;
@property (nonatomic,copy) NSString *usedDate;

/*
 minute = "<null>";
 */

@end
