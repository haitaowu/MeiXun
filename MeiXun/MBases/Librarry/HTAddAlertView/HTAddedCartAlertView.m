//
//  HTAddedCartAlertView.m
//  HTAddedCartAlertView
//  Created by 1 on 15/10/26.
//  Copyright © 2015年 HZQ. All rights reserved.
//

#import "HTAddedCartAlertView.h"

@interface HTAddedCartAlertView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightLayout;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic,copy) NSArray* subTitles;

@end


@implementation HTAddedCartAlertView

+ (HTAddedCartAlertView*)AlertView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HTAddedCartAlertView" owner:nil options:nil];
    HTAddedCartAlertView *alertView = (HTAddedCartAlertView*)[nibView objectAtIndex:0];
    alertView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return alertView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.layer.cornerRadius = 20;
    self.contentView.layer.masksToBounds = YES;
}


#pragma mark - public methods
- (void)showViewWithTxt:(NSString*)str
{
    CGFloat height = [self heightWithStr:str];
    self.contentLabel.text = str;
    self.contentViewHeightLayout.constant = height;
    UIView *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.alpha = 0.0;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}


#pragma mark - private methods
- (void)disappearView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (CGFloat)heightWithStr:(NSString*)str
{
    CGFloat widthLimit = SCREEN_WIDTH - 30 * 2 - 8 * 2;
    UIFont *font = [UIFont systemFontOfSize:14];
    CGFloat height = [self strHeightWithStr:str font:font with:widthLimit];
    return (height + 40*3);
}

/**
 *string height with assign font
 */
- (CGFloat)strHeightWithStr:(NSString*)str font:(UIFont*)font with:(CGFloat)width
{
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSDictionary *attris = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize textSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attris context:nil].size;
    return  textSize.height ;
}

#pragma mark - selectors
- (IBAction)tapBackGroundView:(id)sender {
    [self disappearView];
}




@end


