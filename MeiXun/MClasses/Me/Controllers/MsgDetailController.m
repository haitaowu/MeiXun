//
//  MsgDetailController.m
//  MeiXun
//
//  Created by taotao on 2017/9/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MsgDetailController.h"


@interface MsgDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic,strong)NSArray *dataArray;

@end

@implementation MsgDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - private methods
/**
 *string height with assign font
 */
- (CGFloat)strHeightWith:(UIFont*)font with:(CGFloat)width str:(NSString*)str
{
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSDictionary *attris = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize textSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attris context:nil].size;
    return  textSize.height ;
}


#pragma mark - setup ui
- (void)setupUI
{
    if (self.msgInfo != nil) {
        NSString *title = [self.msgInfo objectForKey:@"messageTitle"];
        if (title != nil) {
            self.titleLabel.text = title;
        }
        
        NSString *messageContent = [self.msgInfo objectForKey:@"messageContent"];
        if (messageContent != nil) {
            self.contentLabel.text = messageContent;
        }
        
        NSString *pushDateStr = [self.msgInfo objectForKey:@"pushDateStr"];
        if (pushDateStr != nil) {
            self.dateLabel.text = pushDateStr;
        }
    }
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        NSString *messageContent = [self.msgInfo objectForKey:@"messageContent"];
        if (messageContent != nil) {
            CGFloat widthLimit = SCREEN_WIDTH - 8 * 2;
            CGFloat height = [self strHeightWith:self.contentLabel.font with:(CGFloat)widthLimit str:messageContent];
            return height;
        }else{
            return 130;
        }
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
@end
