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
@end
@implementation MKeyboard
#pragma mark - public methods
+ (MKeyboard*)showMKeyboard
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MKeyboard" owner:nil options:nil];
    MKeyboard *keyboard = (MKeyboard*)[nibView objectAtIndex:0];
    keyboard.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    keyboard.mTabbar.selectedItem = [keyboard.mTabbar.items firstObject];
    MNumbers  *mNumbers = [MNumbers keyboardNumbers];
    mNumbers.x = 0;
    mNumbers.y = SCREEN_HEIGHT - 49;
    keyboard.mNumbers = mNumbers;
    [keyboard insertSubview:mNumbers belowSubview:keyboard.mTabbar];
    [keyboard showView];
    return keyboard;
}


- (void)showView
{
    UIView *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.alpha = 0.0;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self showViewNumbersView];
    }];
}


- (void)showViewNumbersView
{
    CGFloat y = SCREEN_HEIGHT - 49 - self.mNumbers.height;
    [UIView animateWithDuration:0.8 animations:^{
        self.mNumbers.y = y;
    } completion:^(BOOL finished) {
    }];
}


- (void)disappearView
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)disappearNumbersView
{
    CGFloat y = SCREEN_HEIGHT - 49;
    [UIView animateWithDuration:0.4 animations:^{
        self.mNumbers.y = y;
    } completion:^(BOOL finished) {
        [self disappearView];
    }];
}

#pragma mark - selectors
- (IBAction)tapCoverBtn:(id)sender {
    [self disappearNumbersView];
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger idx = [tabBar.items indexOfObject:item];
    HTLog(@"didSelectItem index = %ld",idx);
    if(idx == 0){
        [self disappearNumbersView];
    }
}


@end
