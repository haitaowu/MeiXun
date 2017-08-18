//
//  MNumbers.m
//  MeiXun
//
//  Created by taotao on 2017/8/15.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MNumbers.h"

@interface MNumbers()
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@end

@implementation MNumbers
#pragma mark - override methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.numberLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightUltraLight];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDelete)];
    [self.deleteBtn addGestureRecognizer:longPressGesture];
    [self.numberLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSString *numbers = [change objectForKey:NSKeyValueChangeNewKey];
    if (self.phoneNumbBlock != nil) {
        self.phoneNumbBlock(numbers);
    }
}

#pragma mark - public methods
+ (MNumbers*)keyboardNumbers
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MNumbers" owner:nil options:nil];
    MNumbers *keyNumbers = (MNumbers*)[nibView objectAtIndex:0];

    return keyNumbers;
}

#pragma mark - selectors
- (IBAction)tapNumberItem:(UIButton *)sender {
    NSInteger tag = sender.tag;
    NSString *numberStr = self.numberLabel.text;
    if (tag < 10) {
        numberStr = [NSString stringWithFormat:@"%@%ld",numberStr,tag];
    }else if (tag < 11){
        numberStr = [NSString stringWithFormat:@"%@*",numberStr];
    }else{
        numberStr = [NSString stringWithFormat:@"%@#",numberStr];
    }
    self.numberLabel.text = numberStr;
}


- (IBAction)tapDeleteNumBtn:(UIButton *)sender {
    NSString *numberStr = self.numberLabel.text;
    if(numberStr.length <= 0){
        return;
    }else{
        NSRange range = NSMakeRange(0, (numberStr.length - 1));
        numberStr = [numberStr substringWithRange:range];
        self.numberLabel.text = numberStr;
    }
}

//长按删除键
- (void)longPressDelete
{
    self.numberLabel.text = @"";
}




@end
