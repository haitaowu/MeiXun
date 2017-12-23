//
//  MKeyboard.h
//  MeiXun
//
//  Created by taotao on 2017/8/15.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectItem) (NSInteger itemIdx);
typedef void(^DialogNumberBlock) (NSString *phoneNum);

@interface MKeyboard : UIView
@property (nonatomic,copy) SelectItem selectItemBlock;
@property (nonatomic,copy) DialogNumberBlock dialogBlock;
+ (MKeyboard*)showMKeyboard;
- (void)showView;
- (void)disappearView;
@end
