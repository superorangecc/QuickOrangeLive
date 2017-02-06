//
//  OYLiveListModel.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/27.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYLiveListModel.h"

@implementation OYLiveListModel

// 返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
// key:propertyName value:JsonKey
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"roomName" : @[@"channel"],
             @"imgName" : @[@"img"],
             @"userName" : @[@"username"],
             @"audienceCount" : @[@"views"],
             @"roomId" : @[@"cid"]};
}

@end
