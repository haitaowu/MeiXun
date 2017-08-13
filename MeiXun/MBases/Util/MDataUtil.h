//
//  MDataUtil.h
//  MeiXun
//
//  Created by taotao on 2017/8/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAccModel.h"

@interface MDataUtil : NSObject
@property (nonatomic,strong)MAccModel *accModel;
+(instancetype)shareInstance;
- (void)archiveAccModel:(MAccModel*)accModel;
- (void)archiveAccModel;
@end
