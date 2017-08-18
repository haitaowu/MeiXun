//
//  MKeyboard.h
//  MeiXun
//
//  Created by taotao on 2017/8/15.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectItem) (NSInteger itemIdx);

@interface MKeyboard : UIView
@property (nonatomic,copy) SelectItem selectItemBlock;
+ (MKeyboard*)showMKeyboard;
- (void)showView;
@end
