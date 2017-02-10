//
//  OYHomeCell.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/2/4.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYHomeRoomListModel.h"
#import "OYQuanMinLiveListModel.h"

@interface OYHomeCell : UITableViewCell

@property (strong, nonatomic) OYQuanMinLiveListModel *roomListModel;

@end
