//
//  OYLiveRoomModel.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/28.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYLiveRoomModel.h"

@implementation OYLiveRoomModel

// 返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
// key:propertyName value:JsonKey
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"liveStreamList" : @[@"streamList"]};
}

@end
