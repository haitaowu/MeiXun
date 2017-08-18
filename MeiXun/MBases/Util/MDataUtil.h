//
//  MDataUtil.h
//  MeiXun
//
//  Created by taotao on 2017/8/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAccModel.h"

typedef void(^LoadContactsBlock)();

@interface MDataUtil : NSObject
@property (nonatomic,strong)MAccModel *accModel;
@property (nonatomic,strong)NSMutableArray *contacts;
@property (nonatomic,strong)NSMutableArray *sections;
+(instancetype)shareInstance;
- (void)archiveAccModel:(MAccModel*)accModel;
- (void)archiveAccModel;
- (void)loadContactsWithBlock:(LoadContactsBlock)loadBlock;
@end
