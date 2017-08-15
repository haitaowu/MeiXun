//
//  MColor.h
//  MeiXun
//
//  Created by taotao on 2017/8/12.
//  Copyright © 2017年 taotao. All rights reserved.
//
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


#ifdef DEBUG
#define HTLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define HTLog(format, ...)
#endif


