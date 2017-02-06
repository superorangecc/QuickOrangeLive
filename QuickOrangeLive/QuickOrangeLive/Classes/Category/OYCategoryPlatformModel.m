//
//  OYCategoryPlatformModel.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/24.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYCategoryPlatformModel.h"

@implementation OYCategoryPlatformModel

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"categories" : [OYCategoryGameModel class],};
}

@end
