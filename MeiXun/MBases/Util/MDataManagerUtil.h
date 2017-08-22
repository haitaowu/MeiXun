//
//  MDataManagerUtil.h
//  MeiXun
//
//  Created by taotao on 2017/8/22.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDataManagerUtil : NSObject
+(instancetype)shareInstance;
//所属运营商查寻
- (NSString*)carrierForPrefix:(NSString*)prefixStr;

//归属地查寻
- (NSString*)locationForNumber:(NSString*)numStr;
@end
