//
//  MsgHeader.m
//  MeiXun
//
//  Created by taotao on 2017/9/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MsgHeader.h"

@interface MsgHeader()
@property (weak, nonatomic)  UILabel *dateLabel;
@property (nonatomic,weak)UIView  *headerView;
@end

@implementation MsgHeader

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
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
}


/**
 "id": "2",
 "userId": "5bff5689-2732-11e7-aa66-00163e1aa2b0",
 "messageId": "2",
 "messageTitle": "测试标题2",
 "messageSummary": "测试概述2",
 "messageContent": "测试内容2",
 "mobile": "13961770764",
 "isRead": "1",
 "pushDate": 1513688726000,
 "isDelete": "0",
 "pushState": "0",
 "isReadString": "已读",
 "pushDateStr": "2017-12-19 21:05:26"
 */

#pragma mark -  setter and getter methods
- (void)setData:(id)data
{
    _data = data;
    if (data != nil) {
        NSString *pushDateStr = [data objectForKey:@"pushDateStr"];
        if (pushDateStr != nil) {
            self.dateLabel.text = pushDateStr;
        }
    }else{
        self.dateLabel.text = @"";
    }
}


@end
