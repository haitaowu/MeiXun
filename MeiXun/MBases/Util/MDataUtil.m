//
//  MDataUtil.m
//  MeiXun
//
//  Created by taotao on 2017/8/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MDataUtil.h"


#define  kLibPath               NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
#define kAccountInfoPath            [kLibPath stringByAppendingPathComponent:@"accountInfo.data"]




static MDataUtil *instance = nil;


@implementation MDataUtil
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class ] alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

#pragma mark - lazy methods
-(MAccModel *)accModel
{
    if (_accModel == nil) {
        return [self unArchiveUserModel];
    }else{
        return _accModel;
    }
}

#pragma mark - private methods
- (MAccModel*)unArchiveUserModel
{
    _accModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kAccountInfoPath];
    return _accModel;
}

#pragma mark - public methods
- (void)archiveAccModel:(MAccModel*)accModel
{
    _accModel = accModel;
    [self archiveAccModel];
}

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

@end
