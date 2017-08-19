//
//  LoadImgOperation.m
//  MeiXun
//
//  Created by taotao on 2017/8/19.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "LoadImgOperation.h"

@interface LoadImgOperation()
@property (nonatomic,copy)LoadImageFinishedBlock finishBlock;
@property (nonatomic,strong)NSData *imgData;
@end

@implementation LoadImgOperation

- (instancetype)initWithData:(NSData*)imgData finishedBlock:(LoadImageFinishedBlock)finishBlock
{
    self = [super init];
    if (self != nil) {
        self.finishBlock = finishBlock;
        self.imgData = imgData;
    }
    return self;
}

- (void)main
{
    UIImage *image = [UIImage imageWithData:self.imgData];
    if (self.finishBlock != nil) {
        self.finishBlock(image);
    }
}

@end

