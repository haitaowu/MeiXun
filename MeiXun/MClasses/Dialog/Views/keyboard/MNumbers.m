//
//  MNumbers.m
//  MeiXun
//
//  Created by taotao on 2017/8/15.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MNumbers.h"

@interface MNumbers()
@end
@implementation MNumbers
#pragma mark - public methods
+ (MNumbers*)keyboardNumbers
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MNumbers" owner:nil options:nil];
    MNumbers *keyNumbers = (MNumbers*)[nibView objectAtIndex:0];
    return keyNumbers;
}








@end
