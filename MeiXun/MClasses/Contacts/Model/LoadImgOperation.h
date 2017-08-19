//
//  LoadImgOperation.h
//  MeiXun
//
//  Created by taotao on 2017/8/19.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^LoadImageFinishedBlock)(UIImage *img);
@interface LoadImgOperation : NSOperation
- (instancetype)initWithData:(NSData*)imgData finishedBlock:(LoadImageFinishedBlock)finishBlock;
@end
