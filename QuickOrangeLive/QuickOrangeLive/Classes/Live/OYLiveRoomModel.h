//
//  OYLiveRoomModel.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/28.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//  直播间

#import <Foundation/Foundation.h>
#import "OYLiveStreamModel.h"

@interface OYLiveRoomModel : NSObject

/** 拉流地址数组 */
@property (strong, nonatomic) NSArray<OYLiveStreamModel *> *liveStreamList;

@end
