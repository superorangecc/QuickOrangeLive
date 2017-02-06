//
//  OYHomeRoomListModel.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/2/4.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYHomeRoomListModel.h"

@implementation OYHomeRoomListModel

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }

@end
