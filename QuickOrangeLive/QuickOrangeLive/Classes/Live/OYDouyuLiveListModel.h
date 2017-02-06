//
//  OYDouyuLiveListModel.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/2/6.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OYDouyuLiveListModel : NSObject

/** 主播名 */
@property (copy, nonatomic) NSString *nickname;
/** 直播名称 */
@property (copy, nonatomic) NSString *room_name;
/** 直播截图 */
@property (copy, nonatomic) NSString *room_src;
/** 观众人数 */
@property (copy, nonatomic) NSString *online;

@end
