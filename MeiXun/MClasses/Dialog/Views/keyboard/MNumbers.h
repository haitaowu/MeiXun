//
//  MNumbers.h
//  MeiXun
//
//  Created by taotao on 2017/8/15.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PhoneChangeBlock)(NSString *phoneNum);

@interface MNumbers : UIView
@property (nonatomic,copy) PhoneChangeBlock phoneNumbBlock;
+ (MNumbers*)keyboardNumbers;
@end
