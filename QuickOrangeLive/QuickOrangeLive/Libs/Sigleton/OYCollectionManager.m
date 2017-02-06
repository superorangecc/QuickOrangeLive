//
//  OYCollectionManagers.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/2/6.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYCollectionManager.h"
#import <FMDB.h>
#import "OYZhanqiLiveListModel.h"
#import "OYQuanMinLiveListModel.h"
#import "OYPandaLiveListModel.h"

@interface OYCollectionManager()

@property (strong, nonatomic) FMDatabaseQueue *queue;

@end

@implementation OYCollectionManager

static id _instance;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self createTable];
    }
    return self;
}

- (void)createTable {
    NSString *dbPath = [[NSBundle mainBundle]pathForResource:@"db.sql" ofType:nil];
    NSString *createSql = [NSString stringWithContentsOfFile:dbPath encoding:NSUTF8StringEncoding error:nil];
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:createSql]) {
            NSLog(@"创表成功");
        }else {
            NSLog(@"创表失败");
        }
    }];
}

- (void)addCollection:(id)liveModel {
    NSString *addSql = @"INSERT into t_collect (collection_model,live_id) VALUES (?,?);";
    [self.queue inDatabase:^(FMDatabase *db) {
        NSData *dealsModelData = [[NSData alloc]init];
        NSString *live_id = [[NSString alloc]init];
        if ([liveModel isKindOfClass:[OYZhanqiLiveListModel class]]) {
            OYZhanqiLiveListModel *zhanqiLiveModel = liveModel;
            live_id = zhanqiLiveModel.title;
            dealsModelData = [NSKeyedArchiver archivedDataWithRootObject:zhanqiLiveModel];
        }else if ([liveModel isKindOfClass:[OYPandaLiveListModel class]]) {
            OYPandaLiveListModel *pandaLiveModel = liveModel;
            live_id = pandaLiveModel.userinfo[@"nickName"];
            dealsModelData = [NSKeyedArchiver archivedDataWithRootObject:pandaLiveModel];
        }else if ([liveModel isKindOfClass:[OYQuanMinLiveListModel class]]){
            OYQuanMinLiveListModel *quanMinLiveModel = liveModel;
            live_id = quanMinLiveModel.title;
            dealsModelData = [NSKeyedArchiver archivedDataWithRootObject:quanMinLiveModel];
        }
        if ([db executeUpdate:addSql withArgumentsInArray:@[dealsModelData,live_id]]) {
            NSLog(@"收藏成功");
        }else {
            NSLog(@"收藏失败");
        }
    }];
}

- (void)cancleCollection:(NSString *)liveId {
    NSString *deleteSql = @"DELETE FROM t_collect WHERE live_id=?;";
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:deleteSql withArgumentsInArray:@[liveId]]) {
            NSLog(@"取消收藏成功");
        }else {
            NSLog(@"取消收藏失败");
        }
    }];
}

- (void)getAllCollectionsWithPage:(NSInteger)page allCollectionsBlock:(void (^)(NSArray *collectionModelArr))block {
    NSInteger countOfPage = 20;
//    NSString *selectSql = @"SELECT * FROM t_collect ORDER BY id DESC LIMIT ?,?;";
    NSString *selectSql = @"SELECT * FROM t_collect;";
    NSMutableArray *collectionList = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:selectSql withArgumentsInArray:@[@((page - 1) * countOfPage),@(countOfPage)]];
        while ([resultSet next]) {
            NSData *modelData = [resultSet dataForColumn:@"collection_model"];
            id liveModel = [NSKeyedUnarchiver unarchiveObjectWithData:modelData];
            [collectionList addObject:liveModel];
        }
        block(collectionList.copy);
    }];
}

- (void)isCollected:(id)liveModel resultBlock:(void (^)(BOOL isCollected))resultBlock {
    NSString *live_id = [[NSString alloc]init];
    if ([liveModel isKindOfClass:[OYZhanqiLiveListModel class]]) {
        OYZhanqiLiveListModel *zhanqiLiveModel = liveModel;
        live_id = zhanqiLiveModel.title;
    }else if ([liveModel isKindOfClass:[OYPandaLiveListModel class]]) {
        OYPandaLiveListModel *pandaLiveModel = liveModel;
        live_id = pandaLiveModel.userinfo[@"nickName"];
    }else if ([liveModel isKindOfClass:[OYQuanMinLiveListModel class]]){
        OYQuanMinLiveListModel *quanMinLiveModel = liveModel;
        live_id = quanMinLiveModel.title;
    }
    NSString *selectSql = @"SELECT * FROM t_collect WHERE live_id=?;";
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:selectSql withArgumentsInArray:@[live_id]];
        [resultSet next];
        resultBlock(resultSet.columnCount == 3);
    }];
}

//MARK:- 懒加载
- (FMDatabaseQueue *)queue {
    if (!_queue) {
        NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)lastObject] stringByAppendingPathComponent:@"collection.sqlite"];
        NSLog(@"%@",dbPath);
        _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return _queue;
}

@end
