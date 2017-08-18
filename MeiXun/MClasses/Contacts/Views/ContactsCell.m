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

@interface ContactsCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation ContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
}


@end
