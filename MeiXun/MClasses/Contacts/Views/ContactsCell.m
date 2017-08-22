//
//  ContactsCell.m
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "ContactsCell.h"
#import "NSString+Extension.h"
#import "PersonModel.h"
#import "LoadImgOperation.h"


@interface ContactsCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong)NSOperationQueue *loadQueue;
@end

@implementation ContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.loadQueue = [[NSOperationQueue alloc] init];
    self.loadQueue.maxConcurrentOperationCount = 1;
}

#pragma mark -  setter methods 
- (void)setPersonModel:(PersonModel *)personModel
{
    _personModel = personModel;
    if ([personModel.name emptyStr]) {
        NSString *firstNum = [personModel.phoneNums firstObject];
        self.nameLabel.text = firstNum;
    }else{
        self.nameLabel.text = personModel.name;
    }
    [self.loadQueue cancelAllOperations];
    
    //加载图片
    __block typeof(self) blockSelf = self;
    if (personModel.avatarData != nil) {
        LoadImgOperation *imgOperation = [[LoadImgOperation alloc] initWithData:personModel.avatarData finishedBlock:^(UIImage *img) {
            dispatch_async(dispatch_get_main_queue(), ^{
                blockSelf.avatarView.image = img;
            });
        }];
        [self.loadQueue addOperation:imgOperation];
    }
    
    UIImage *img;
    if (personModel.avatarData == nil) {
        img = [UIImage imageNamed:@"icon_user_hd"];
    }
    self.avatarView.image = img;
}


@end
