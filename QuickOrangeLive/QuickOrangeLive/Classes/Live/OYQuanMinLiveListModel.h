//
//  OYQuanMinLiveListModel.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/31.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OYQuanMinLiveListModel : NSObject

/** 主播名 */
@property (copy, nonatomic) NSString *nick;
/** 缩略图 */
@property (copy, nonatomic) NSString *thumb;
/** 观众人数 */
@property (copy, nonatomic) NSString *view;
/** 直播名称 */
@property (copy, nonatomic) NSString *title;
/** 拉流地址 */
@property (copy, nonatomic) NSString *stream;
/** 头像 */
@property (copy, nonatomic) NSString *avatar;

@end
