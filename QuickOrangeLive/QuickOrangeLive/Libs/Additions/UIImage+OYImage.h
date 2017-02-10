//
//  UIImage+Image.h
//  
//
//  Created by Orange Yu on 15/7/6.
//  Copyright (c) 2015年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OYImage)


// 根据颜色生成一张尺寸为1*1的相同颜色图片
+ (UIImage *)oy_imageWithColor:(UIColor *)color;


@end
