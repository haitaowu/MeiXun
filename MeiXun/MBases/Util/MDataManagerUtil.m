//
//  MDataManagerUtil.m
//  MeiXun
//
//  Created by taotao on 2017/8/22.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MDataManagerUtil.h"
#import <FMDatabase.h>

static MDataManagerUtil *instance = nil;

@interface MDataManagerUtil()
@property (nonatomic,strong)FMDatabase *locationDB;
@end

@implementation MDataManagerUtil

#pragma mark - override methods
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
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
//所属运营商查寻
- (NSString*)carrierForPrefix:(NSString*)prefixStr;
{
    if ([self.locationDB open] == YES) {
        NSString *sql = [NSString stringWithFormat:@"SELECT carrier from carrier_info where prefix = %@",prefixStr];
        FMResultSet *s = [self.locationDB executeQuery:sql];
        if ([s next]) {
            NSString *carrier = [s stringForColumn:@"carrier"];
            [self.locationDB close];
            return carrier;
        }else{
            return @"";
        }
    }else{
        return @"";
    }
}

//归属地查寻
- (NSString*)locationForNumber:(NSString*)numStr;
{
    if ([self.locationDB open] == YES) {
        NSString *sql = [NSString stringWithFormat:@"SELECT loca_code FROM caller_loc where number = %@",numStr];
        FMResultSet *s = [self.locationDB executeQuery:sql];
        if ([s next]) {
            id code = [s objectForColumnName:@"loca_code"];
            NSString *locStr = [self locationForCode:code db:self.locationDB];
            [self.locationDB close];
            return locStr;
        }else{
            return @"本地";
        }
    }else{
        return @"本地";
    }
}

#pragma mark -  LazyInit  Methods
-(FMDatabase *)locationDB
{
    if(_locationDB == nil)
    {
        NSString *locDbPath = [[NSBundle mainBundle] pathForResource:@"callHomeDB" ofType:@"db"];
        _locationDB = [FMDatabase databaseWithPath:locDbPath];
    }
    return _locationDB;
}

#pragma mark - private methods
- (NSString*)locationForCode:(id)code db:(FMDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"SELECT location FROM locat_info where code = %@",code];
    FMResultSet *s = [db executeQuery:sql];
    if ([s next]) {
        NSString *locationStr = [s stringForColumn:@"location"];
        return locationStr;
    }else{
        return @"";
    }
}

@end
