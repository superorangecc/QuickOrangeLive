//
//  OYCollectionManagers.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/2/6.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OYCollectionManager : NSObject

+ (instancetype)sharedManager;

- (void)addCollection:(id)liveModel;
- (void)cancleCollection:(NSString *)liveId;
- (void)getAllCollectionsWithPage:(NSInteger)page allCollectionsBlock:(void (^)(NSArray *collectionModelArr))block;
- (void)isCollected:(id)liveModel resultBlock:(void (^)(BOOL isCollected))resultBlock;

@end
