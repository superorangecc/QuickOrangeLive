//
//  OYLiveListCell.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/25.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYLiveListModel.h"
#import "OYPandaLiveListModel.h"
#import "OYZhanqiLiveListModel.h"
#import "OYQuanMinLiveListModel.h"

@interface OYLiveListCell : UICollectionViewCell

@property (strong, nonatomic) OYLiveListModel *liveListModel;
@property (strong, nonatomic) OYPandaLiveListModel *pandaLiveListModel;
@property (strong, nonatomic) OYZhanqiLiveListModel *zhanqiLiveListModel;
@property (strong, nonatomic) OYQuanMinLiveListModel *quanminLiveListModel;

@end
