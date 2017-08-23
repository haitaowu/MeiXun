//
//  CallingViewController.h
//  MeiXun
//
//  Created by taotao on 2017/8/23.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelBlock)();

@interface CallingViewController : UIViewController
- (void)showViewWithModel:(id)model phone:(NSString*)phone cancel:(CancelBlock)cancelBlock;

@end
