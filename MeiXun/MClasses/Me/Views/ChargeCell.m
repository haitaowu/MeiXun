//
//  ChargeCell.m
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "ChargeCell.h"
#import "NSString+Extension.h"
#import "ChargeModel.h"


@interface ChargeCell()
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@end

@implementation ChargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark -  setter methods 
- (void)setChargeModel:(ChargeModel *)chargeModel
{
    _chargeModel = chargeModel;
    if (chargeModel != nil) {
        //1
        NSString *cardNoStr = [NSString stringWithFormat:@"充值卡号：%@",chargeModel.cardNo];
        self.cardNoLabel.text = cardNoStr;
       //2
        NSString *sumStr = [NSString stringWithFormat:@"你成功充值了%@元",chargeModel.amount];
        self.sumLabel.text = sumStr;
    }
   
}

@end
