//
//  RecordCell.m
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "RecordCell.h"
#import "NSString+Extension.h"
#import "RecordModel.h"
#import "LoadImgOperation.h"


@interface RecordCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong)NSOperationQueue *loadQueue;
@end

@implementation RecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.loadQueue = [[NSOperationQueue alloc] init];
    self.loadQueue.maxConcurrentOperationCount = 1;
}

#pragma mark -  setter methods 
- (void)setRecordModel:(RecordModel *)recordModel
{
    _recordModel = recordModel;
    if ([recordModel.name emptyStr]) {
        self.nameLabel.text = recordModel.phone;
    }else{
        self.nameLabel.text = recordModel.name;
    }
    [self.loadQueue cancelAllOperations];
    
    //加载图片
    __block typeof(self) blockSelf = self;
    if (recordModel.avatarData != nil) {
        LoadImgOperation *imgOperation = [[LoadImgOperation alloc] initWithData:recordModel.avatarData finishedBlock:^(UIImage *img) {
            dispatch_async(dispatch_get_main_queue(), ^{
                blockSelf.avatarView.image = img;
            });
        }];
        [self.loadQueue addOperation:imgOperation];
    }
    
    UIImage *img;
    if (recordModel.avatarData == nil) {
        img = [UIImage imageNamed:@"icon_user_hd"];
    }
    self.avatarView.image = img;
}


@end
