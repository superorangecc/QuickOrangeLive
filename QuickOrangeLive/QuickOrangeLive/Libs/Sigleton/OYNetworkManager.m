//
//  OYNetworkManager.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/25.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYNetworkManager.h"
#import "OYLiveListController.h"
#import "OYPandaLiveListModel.h"
#import "OYZhanqiLiveListModel.h"
#import "OYQuanMinLiveListModel.h"
#import "OYHomeRoomListModel.h"

static OYNetworkManager *_instance;
@implementation OYNetworkManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[OYNetworkManager alloc]init];
        _instance.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain",@"text/html",nil];
    });
    return _instance;
}

/** 获取房间列表 */
- (void)getRoomListWithPlatformId:(int)platformId andGameId:(NSString *)gameName andPageNum:(int)pageNum andCompletionHandler:(SuccessCallBack)callBack {
    switch (platformId) {
        case PlatformTypeXiongMao:
            [self getPandaRoomListWithGameName:gameName andPageNum:pageNum  andCompletionHandler:callBack];
            break;
        case PlatformTypeZhanQi:
            [self getZhanQiRoomWithGameName:gameName andPageNum:pageNum  andCompletionHandler:callBack];
            break;
        case PlatformTypeQuanMin:
            [self getQuanMinRoomWithGameName:gameName andCompletionHandler:callBack];
        default:
            break;
    }
}

/** 获取直播间 */
- (void)getRoomWithPlatformId:(int)platformId andRoomId:(int)roomId andVideoId:(NSString *)videoId andStreamUrl:(NSString *)streamUrl andCompletionHandler:(StreamCallBack)callBack{
    switch (platformId) {
        case PlatformTypeXiongMao:
            [self getPandaRoomWithRoomId:roomId andCompletionHandler:callBack];
            break;
        case PlatformTypeZhanQi:
            [self getZhanQiRoomWithVideoId:videoId andCompletionHandler:callBack];
        case PlatformTypeQuanMin:
            [self getZhanQiRoomWithStreamUrl:streamUrl andCompletionHandler:callBack];
        default:
            break;
    }
}

/** 获取首页房间列表 */
- (void)getHomeRoomListWithCompletionHandler:(SuccessCallBack)callBack {
    NSInteger currentTime = [self getCurrentTime];
    NSString *requestUrl = [NSString stringWithFormat:@"http://api.maxjia.com/api/live/list/?lang=zh-cn&os_type=iOS&os_version=10.2&_time=%zd&limit=30&offset=0",currentTime];
    [self GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *roomListArr = responseObject[@"result"];
        NSArray *roomList = [NSArray yy_modelArrayWithClass:[OYHomeRoomListModel class] json:roomListArr];
        callBack(roomList);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求首页房间列表数据错误%@",error)
    }];
}

/** 获取首页直播间 */
- (void)getHomeRoomWithLiveType:(NSString *)liveType andLiveId:(NSString *)liveId andCompletionHandler:(StreamCallBack)callBack {
    NSInteger currentTime = [self getCurrentTime];
    NSString *requestUrl = [NSString stringWithFormat:@"http://api.maxjia.com:80/api/live/detail/?live_type=%@&live_id=%@&lang=zh-cn&os_type=iOS&os_version=10.2&_time=%zd",liveType,liveId,currentTime];
    [self GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *streamArr = responseObject[@"result"][@"stream_list"];
        NSDictionary *streamDic = streamArr.firstObject;
        NSString *streamStr = streamDic[@"url"];
        NSURL *streamUrl = [NSURL URLWithString:streamStr];
        callBack(streamUrl);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"房间数据请求错误%@",error);
        }
    }];
}

/** 获取火猫房间列表 */
- (void)getHuoMaoRoomListWithGameId:(int)gameId andCompletionHandler:(RequestCallBack)callBack{
    
    NSString *requestUrl = [NSString stringWithFormat:@"https://api.huomao.com/channels/channelpage.json?time=%zd&refer=ios&page=1&gid=%d&token=236b5f646c5fe88c726ac89e2e4d19b8",[self getCurrentTime],gameId];
    [self GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(nil,error);
    }];
}

/** 获取火猫直播间 */
- (void)getHuoMaoRoomWithRoomId:(int)roomId andCompletionHandler:(RequestCallBack)callBack {
    NSString *requestUrl = [NSString stringWithFormat:@"https://api.huomao.com/channels/channelDetail?time=%zd&refer=ios&cid=%d&token=56fbb724fd342d05ef419ab83e9241ed",[self getCurrentTime],roomId];
    [self GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(nil,error);
    }];
}

- (NSInteger)getCurrentTime {
    //1.获取当前的时间
    NSDate *date = [NSDate date];
    //2.计算addTime
    return [date timeIntervalSince1970];
}

/** 获取熊猫房间列表 */
- (void)getPandaRoomListWithGameName:(NSString *)gameName andPageNum:(int)pageNum andCompletionHandler:(SuccessCallBack)callBack {
    NSString *requestUrl = [[NSString alloc]init];
    if ([gameName  isEqual: @""]) {
        requestUrl = [NSString stringWithFormat:@"https://api.m.panda.tv/ajax_live_lists?pageno=%d&pagenum=10&order=person_num&status=2&banner=1&__version=2.2.6.1582&__plat=ios&__channel=appstore",pageNum];
    }else {
        requestUrl = [NSString stringWithFormat:@"https://api.m.panda.tv/ajax_get_live_list_by_cate?cate=%@&pageno=%d&pagenum=10&order=person_num&status=2&banner=1&slider=1&__version=2.2.6.1582&__plat=ios&__channel=appstore",gameName,pageNum];
    }
    [self GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *roomListArr = responseObject[@"data"][@"items"];
        NSArray *roomList = [NSArray yy_modelArrayWithClass:[OYPandaLiveListModel class] json:roomListArr];
        callBack(roomList);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求熊猫房间列表数据错误%@",error)
    }];
}

/** 获取熊猫直播间 */
- (void)getPandaRoomWithRoomId:(int)roomId andCompletionHandler:(StreamCallBack)callBack {
    NSString *requestUrl = [NSString stringWithFormat:@"https://api.m.panda.tv/ajax_get_liveroom_baseinfo?roomid=%d&slaveflag=1&__version=2.2.6.1582&__plat=ios&__channel=appstore",roomId];
    [self GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *roomkey = responseObject[@"data"][@"info"][@"videoinfo"][@"room_key"];
        NSString *pl = responseObject[@"data"][@"info"][@"videoinfo"][@"plflag"];
        NSRange range = [pl rangeOfString:@"_"];
        NSString *plflag = [pl substringFromIndex:range.location + 1];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://pl%@.live.panda.tv/live_panda/%@.flv?sign=sign&time=ts",plflag,roomkey]];
        NSLog(@"拉流地址-------------%@",url);
        callBack(url);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"房间数据请求错误%@",error);
        }
    }];
}

/** 获取战旗房间列表 */
- (void)getZhanQiRoomWithGameName:(NSString *)gameName andPageNum:(int)pageNum andCompletionHandler:(SuccessCallBack)callBack {
    NSString *requestUrl = [[NSString alloc]init];
    if ([gameName  isEqual: @""]) {
        requestUrl = @"https://apis.zhanqi.tv/static/v2.1/live/list/20/1.json?os=1&ver=3.2.5";
    }else {
        requestUrl = [NSString stringWithFormat:@"https://apis.zhanqi.tv/static/v2.1/game/live/%@/20/%d.json?os=1&ver=3.2.5",gameName,pageNum];
    }
    [self GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *roomListArr = responseObject[@"data"][@"rooms"];
        NSArray *roomList = [NSArray yy_modelArrayWithClass:[OYZhanqiLiveListModel class] json:roomListArr];
        callBack(roomList);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求战旗房间列表数据错误%@",error)
    }];
}
/** 获取战旗直播间 */
- (void)getZhanQiRoomWithVideoId:(NSString *)videoId andCompletionHandler:(StreamCallBack)callBack {
    NSString *url = [NSString stringWithFormat:@"http://dlhls.cdn.zhanqi.tv/zqlive/%@.m3u8",videoId];
    NSURL *streamUrl = [NSURL URLWithString:url];
    callBack(streamUrl);
}

/** 获取全民房间列表 */
- (void)getQuanMinRoomWithGameName:(NSString *)gameName andCompletionHandler:(SuccessCallBack)callBack {
    NSString *requestUrl = [[NSString alloc]init];
    if ([gameName  isEqual: @""]) {
        requestUrl = @"http://www.quanmin.tv/json/play/list.json";
    }else {
        requestUrl = [NSString stringWithFormat:@"http://www.quanmin.tv/json/categories/%@/list.json?0129225854",gameName];
    }
    [self GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *roomListArr = responseObject[@"data"];
        NSArray *roomList = [NSArray yy_modelArrayWithClass:[OYQuanMinLiveListModel class] json:roomListArr];
        callBack(roomList);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求全民房间列表数据错误%@",error)
    }];
}

/** 获取全民直播间 */
- (void)getZhanQiRoomWithStreamUrl:(NSString *)url andCompletionHandler:(StreamCallBack)callBack {
    NSURL *streamUrl = [NSURL URLWithString:url];
    callBack(streamUrl);
}
@end
