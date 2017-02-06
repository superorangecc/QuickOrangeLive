//
//  OYLiveStreamModel.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/28.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//  拉流地址

#import <Foundation/Foundation.h>

@interface OYLiveStreamModel : NSObject

/** 超清流 */
@property (copy, nonatomic) NSString *tdStream;
/** 高清流 */
@property (copy, nonatomic) NSString *hdStream;
/** 标清流 */
@property (copy, nonatomic) NSString *sdStream;
/** 普清流 */
@property (copy, nonatomic) NSString *bdStream;

@end
