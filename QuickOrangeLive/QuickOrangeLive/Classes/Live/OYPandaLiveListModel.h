//
//  OYPandaLiveListModel.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/28.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OYPandaLiveListModel : NSObject

/** 房间名 */
@property (copy, nonatomic) NSString *name;
/** 缩略图(key:img) */
@property (strong, nonatomic) NSDictionary *pictures;
/** 房间人数 */
@property (copy, nonatomic) NSString *person_num;
/** 主播名(key:nickName) */
@property (strong, nonatomic) NSDictionary *userinfo;
/** 房间id */
@property (nonatomic) NSInteger roomId;

@end
