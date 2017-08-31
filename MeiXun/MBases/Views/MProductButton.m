//
//  MProductButton.m
//  MeiXun
//
//  Created by taotao on 2017/8/31.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MProductButton.h"
#import "UIImage+Extension.h"


#define kPriceRatio         0.3


@interface MProductButton()
@property (nonatomic,weak)UILabel  *nameLabel;
@property (nonatomic,weak)UILabel  *priceLabel;
@end


@implementation MProductButton
#pragma mark - override methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupBase];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupBase];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize viewSize = self.size;
    //name label frame
    CGFloat nameHeight = viewSize.height * (1 - kPriceRatio);
    CGRect nameF = {{0,0},{viewSize.width,nameHeight}};
    self.nameLabel.frame = nameF;
    
    CGFloat priceHeight = viewSize.height * kPriceRatio;
    CGFloat priceY = nameHeight;
    CGRect priceF = {{0,priceY},{viewSize.width,priceHeight}};
    self.priceLabel.frame = priceF;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected ==  YES) {
        [self setSelectedTitleColor];
    }else{
        [self setNormalTitleColor];
    }
}

#pragma mark -  setter methods
- (void)setProductData:(id)productData
{
    _productData = productData;
    NSString *nameStr = [NSString stringWithFormat:@"%@",productData];
    self.nameLabel.text = nameStr;
    NSString *priceStr = [NSString stringWithFormat:@"%@",productData];
    self.priceLabel.text = priceStr;
}

#pragma mark - private methods
- (void)setSelectedTitleColor
{
    self.nameLabel.textColor = [UIColor whiteColor];
    self.priceLabel.textColor = [UIColor whiteColor];
}

- (void)setNormalTitleColor
{
    self.nameLabel.textColor = MNavBarColor;
    self.priceLabel.textColor = MNavBarColor;
}

- (void)setupBase
{
    //init label
    UILabel *priceLabel = [[UILabel alloc] init];
    [self addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    self.nameLabel= nameLabel;
    
    
    self.layer.borderColor = MNavBarColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    //normal state
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor groupTableViewBackgroundColor]] forState:UIControlStateNormal];
    
    //selected state
    [self setBackgroundImage:[UIImage imageWithColor:MNavBarColor] forState:UIControlStateSelected];
}

@end
