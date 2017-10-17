//
//  MProductButton.m
//  MeiXun
//
//  Created by taotao on 2017/8/31.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MProductButton.h"
#import "UIImage+Extension.h"
#import <StoreKit/StoreKit.h>



#define kPriceRatio         0.5


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
    [self.nameLabel sizeToFit];
    CGSize nameSize = self.nameLabel.size;
    //name label frame
    CGFloat nameX = (viewSize.width - nameSize.width) * 0.5;
    CGFloat nameY = viewSize.height * 0.5 - nameSize.height;
    CGFloat nameHeight = viewSize.height * (1 - kPriceRatio);
    CGRect nameF = {{nameX,nameY},nameSize};
    self.nameLabel.frame = nameF;
    
    [self.priceLabel sizeToFit];
    CGSize priceSize = self.priceLabel.size;
    CGFloat priceHeight = viewSize.height * kPriceRatio;
    CGFloat priceX = (viewSize.width - priceSize.width) * 0.5;
    CGFloat priceY = viewSize.height * 0.5;
    CGRect priceF = {{priceX,priceY},priceSize};
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
    SKProduct *pro = (SKProduct*) productData;
    _productData = productData;
    NSString *keyStr = [self numberStrWith:[pro localizedTitle]];
    NSString *nameStr = [NSString stringWithFormat:@"%@",[pro localizedTitle]];
    NSAttributedString* attriText = [self attriStringWithStr:nameStr keyword:keyStr];
    self.nameLabel.attributedText = attriText;
    //2.price label set up
    NSString *priceStr = [NSString stringWithFormat:@"售价%@.00元",[pro price]];
    self.priceLabel.text = priceStr;
    [self setNeedsLayout];
}


- (NSString*)numberStrWith:(NSString*)string
{
//    NSString *str = @"98741235你好00";
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    return [NSString stringWithFormat:@"%d",number];
    
}

#pragma mark - private methods
- (NSAttributedString*)attriStringWithStr:(NSString*)string keyword:(NSString*)keyword
{
    NSMutableAttributedString *attriStrName = [[NSMutableAttributedString alloc] initWithString:string];
    if (keyword == nil) {
        return attriStrName;
    }else{
        NSRange range = [string rangeOfString:keyword];
        NSDictionary *attris = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:25],NSFontAttributeName, nil];
        [attriStrName setAttributes:attris range:range];
        return attriStrName;
    }
}

- (void)setSelectedTitleColor
{
    self.nameLabel.textColor = [UIColor whiteColor];
    self.priceLabel.textColor = [UIColor whiteColor];
}

- (void)setNormalTitleColor
{
    self.nameLabel.textColor = [UIColor whiteColor];
    self.priceLabel.textColor = [UIColor whiteColor];
}

- (void)setupBase
{
    //init label
    UILabel *nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    self.nameLabel= nameLabel;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:18];
//    nameLabel.backgroundColor = [UIColor grayColor];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [self addSubview:priceLabel];
    self.priceLabel = priceLabel;
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.font = [UIFont systemFontOfSize:14];
//    priceLabel.backgroundColor = [UIColor redColor];
    
    
    
    [self setNormalTitleColor];
    
//    self.layer.borderColor = MNavBarColor.CGColor;
//    self.layer.borderWidth = 1;
//    self.layer.cornerRadius = 5;
//    self.layer.masksToBounds = YES;
    //normal state
    UIImage *img = [UIImage imageNamed:@"me_cardBg"];
    [self setBackgroundImage:img forState:UIControlStateNormal];
    
    //selected state
//    [self setBackgroundImage:[UIImage imageWithColor:MNavBarColor] forState:UIControlStateSelected];
}

@end
