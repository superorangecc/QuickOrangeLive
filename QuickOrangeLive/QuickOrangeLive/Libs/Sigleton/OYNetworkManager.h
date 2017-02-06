//
//  OYNetworkManager.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/25.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestCallBack)(id respose,NSError *error);
typedef void(^SuccessCallBack)(id response);
typedef void(^StreamCallBack)(NSURL* streamUrl);
@interface OYNetworkManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

/** 获取房间列表 */
- (void)getRoomListWithPlatformId:(int)platformId andGameId:(NSString *)gameName andPageNum:(int)pageNum andOffset:(int)offset andCompletionHandler:(SuccessCallBack)callBack;
/** 获取直播间 */
- (void)getRoomWithPlatformId:(int)platformId andRoomId:(int)roomId andVideoId:(NSString *)videoId andStreamUrl:(NSString *)streamUrl andCompletionHandler:(StreamCallBack)callBack;

/** 获取首页房间列表 */
- (void)getHomeRoomListWithCompletionHandler:(SuccessCallBack)callBack;
/** 获取首页直播间 */
- (void)getHomeRoomWithLiveType:(NSString *)liveType andLiveId:(NSString *)liveId andCompletionHandler:(StreamCallBack)callBack;

@end
