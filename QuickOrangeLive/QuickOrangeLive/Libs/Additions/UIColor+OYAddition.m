//
//  UIColor+OYAddition.m
//
//  Created by Orange Yu on 2016/11/3.
//  Copyright © 2016年 Orange Yu. All rights reserved.
//
//  十六进制颜色 & RGB颜色 & 随机色

#import "UIColor+OYAddition.h"

@implementation UIColor (OYAddition)
+ (instancetype)oy_colorWithHex:(uint32_t)hex alpha:(CGFloat)alpha{
    int red = (hex & 0xFF0000) >> 16;
    int green = (hex & 0x00FF00) >> 8;
    int blue = (hex & 0x0000FF);
    
    return [UIColor oy_colorWithR:red G:green B:blue alpha:alpha];
}
+ (instancetype)oy_colorWithR:(int)red G:(int)green B:(int)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}
+ (instancetype)oy_colorRandom
{
    return [UIColor oy_colorWithR:arc4random_uniform(256) G:arc4random_uniform(256) B:arc4random_uniform(256) alpha:1];
}

@end
