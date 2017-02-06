//
//  OYZhanqiLiveListModel.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/30.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OYZhanqiLiveListModel : NSObject

/** 主播名 */
@property (copy, nonatomic) NSString *nickname;
/** 直播名称 */
@property (copy, nonatomic) NSString *title;
/** 直播截图 */
@property (copy, nonatomic) NSString *bpic;
/** 观众人数 */
@property (copy, nonatomic) NSString *online;
/** 拉流地址 */
@property (copy, nonatomic) NSString *videoId;

@end
