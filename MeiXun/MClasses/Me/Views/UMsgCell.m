//
//  UMsgCell.m
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "UMsgCell.h"
#import "NSString+Extension.h"


@interface UMsgCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation UMsgCell


- (void)awakeFromNib {
    [super awakeFromNib];
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

#pragma mark -  setter methods 
- (void)setMsgModel:(id)msgModel
{
    _msgModel = msgModel;
    if (msgModel != nil) {
        NSString *title = [msgModel objectForKey:@"messageTitle"];
        if (title != nil) {
            self.titleLabel.text = title;
        }
        NSString *messageSummary = [msgModel objectForKey:@"messageSummary"];
        if (messageSummary != nil) {
            self.contentLabel.text = messageSummary;
        }
        
        NSString *pushDateStr = [msgModel objectForKey:@"pushDateStr"];
        if (pushDateStr != nil) {
            self.dateLabel.text = pushDateStr;
        }
    }
}

#pragma mark - selectors
- (IBAction)tapReadAllBtn:(id)sender {
    if (self.readAllBlock != nil) {
        self.readAllBlock(_msgModel);
    }
}

@end
