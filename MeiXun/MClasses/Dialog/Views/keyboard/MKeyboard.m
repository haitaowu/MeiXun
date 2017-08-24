//
//  MKeyboard.m
//  MeiXun
//
//  Created by taotao on 2017/8/15.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MKeyboard.h"
#import "MNumbers.h"

@interface MKeyboard()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *mTabbar;
@property (nonatomic,weak)MNumbers  *mNumbers;
@property (weak, nonatomic) IBOutlet UIButton *dilogBtn;
@property (nonatomic,assign) BOOL itemEnable;
@property (nonatomic,copy) NSString *phoneNumber;
@end
@implementation MKeyboard
#pragma mark - public methods
+ (MKeyboard*)showMKeyboard
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MKeyboard" owner:nil options:nil];
    MKeyboard *keyboard = (MKeyboard*)[nibView objectAtIndex:0];
    keyboard.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    keyboard.mTabbar.selectedItem = [keyboard.mTabbar.items firstObject];
    MNumbers  *mNumbers = [MNumbers keyboardNumbers];
    mNumbers.x = 0;
    mNumbers.y = SCREEN_HEIGHT - 49;
    mNumbers.width = SCREEN_WIDTH;
    keyboard.mNumbers = mNumbers;
    keyboard.itemEnable = YES;
    [keyboard insertSubview:mNumbers belowSubview:keyboard.mTabbar];
    
    return keyboard;
}


- (void)showView
{
    self.mTabbar.selectedItem = [self.mTabbar.items firstObject];
    UIView *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.alpha = 0.0;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self showViewNumbersView];
    }];
    
    if (self.mNumbers.phoneNumbBlock == nil) {
        self.mNumbers.phoneNumbBlock = ^(NSString *phoneNum) {
//            NSLog(@"phon number dialoged = %@",phoneNum);
            self.phoneNumber = phoneNum;
            if (phoneNum.length > 0) {
                self.dilogBtn.hidden = NO;
            }else{
                self.dilogBtn.hidden = YES;
            }
        };
    }
}


- (void)showViewNumbersView
{
    CGFloat y = SCREEN_HEIGHT - 49 - self.mNumbers.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.mNumbers.y = y;
    } completion:^(BOOL finished) {
    }];
}


- (void)disappearView
{
    CGFloat y = SCREEN_HEIGHT - 49;
    self.mNumbers.y = y;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.itemEnable = NO;
    }];
}

- (void)disappearNumbersView
{
    CGFloat y = SCREEN_HEIGHT - 49;
    [UIView animateWithDuration:0.3 animations:^{
        self.mNumbers.y = y;
    } completion:^(BOOL finished) {
        [self disappearView];
    }];
}

#pragma mark - selectors
- (IBAction)tapCoverBtn:(id)sender {
    [self disappearNumbersView];
}

//点击拨打按钮
- (IBAction)tapDialogBtn:(id)sender {
    if(self.dialogBlock != nil){
        self.dialogBlock(self.phoneNumber);
    }
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger idx = [tabBar.items indexOfObject:item];
    HTLog(@"didSelectItem index = %ld",idx);
    if(idx == 0){
        self.itemEnable = NO;
        [self disappearNumbersView];
    }else{
        [self disappearView];
        if (self.selectItemBlock != nil) {
            self.selectItemBlock(idx);
        }
    }
}


@end
