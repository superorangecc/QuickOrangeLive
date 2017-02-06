//
//  UIColor+OYAddition.h
//
//  Created by Orange Yu on 2016/11/3.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//
//  十六进制颜色 & RGB颜色 & 随机色

#import <UIKit/UIKit.h>

@interface UIColor (OYAddition)
+ (instancetype)oy_colorWithHex:(uint32_t)hex alpha:(CGFloat)alpha;
+ (instancetype)oy_colorWithR:(int)red G:(int)green B:(int)blue alpha:(CGFloat)alpha;
+ (instancetype)oy_colorRandom;
@end
