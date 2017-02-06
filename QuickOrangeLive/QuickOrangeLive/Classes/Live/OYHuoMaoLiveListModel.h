//
//  OYLiveListModel.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/27.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//  直播间列表

#import <Foundation/Foundation.h>

@interface OYHuoMaoLiveListModel : NSObject

/** 房间名 */
@property (copy, nonatomic) NSString *roomName;
/** 房间缩略图 */
@property (copy, nonatomic) NSString *imgName;
/** 主播名 */
@property (copy, nonatomic) NSString *userName;
/** 观众人数 */
@property (copy, nonatomic) NSString *audienceCount;
/** 房间id */
@property (nonatomic) NSInteger roomId;

@end
