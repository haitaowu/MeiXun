//
//  UMsgCell.h
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ReadAllBlock) (id msgData);

@interface UMsgCell : UITableViewCell
@property (nonatomic,strong)id msgModel;
@property(nonatomic,copy) ReadAllBlock readAllBlock;
@end
