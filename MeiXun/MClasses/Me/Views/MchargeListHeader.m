//
//  MchargeListHeader.m
//  MeiXun
//
//  Created by taotao on 2017/9/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MchargeListHeader.h"

@interface MchargeListHeader()
@property (weak, nonatomic)  UILabel *dateLabel;
@property (nonatomic,weak)UIView  *headerView;
@end

@implementation MchargeListHeader

#pragma mark - override methods
- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self != nil) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.dateLabel.frame = self.contentView.bounds;
    HTLog(@"header view height = %@",NSStringFromCGRect(self.dateLabel.frame));
    //这里设置frame 不会对view起作用，此时的view的尺寸为xib中的大小
}

#pragma mark - private methods
- (void)setupUI
{
    UILabel *label = [[UILabel alloc] init];
    self.dateLabel = label;
    [self.contentView addSubview:label];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
}

#pragma mark -  setter and getter methods 
- (void)setData:(id)data
{
    _data = data;
    self.dateLabel.text = [NSString stringWithFormat:@"%@",data];
}


@end
