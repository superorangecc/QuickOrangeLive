//
//  OYLiveRoomController.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/28.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "OYLivePlayerControl.h"
#import "OYPandaLiveListModel.h"
#import "OYZhanqiLiveListModel.h"
#import "OYQuanMinLiveListModel.h"

@interface OYLiveRoomController : UIViewController

@property(atomic,strong) NSURL *url;
@property(atomic, retain) id<IJKMediaPlayback> player;
@property (strong, nonatomic) OYLivePlayerControl *playerControl;
@property (copy, nonatomic) NSString *liveName;

//- (id)initWithURL:(NSURL *)url;

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void(^)())completion;

@property (strong, nonatomic) OYPandaLiveListModel *pandaLiveListModel;
@property (strong, nonatomic) OYZhanqiLiveListModel *zhanQiLiveListModel;
@property (strong, nonatomic) OYQuanMinLiveListModel *quanMinLiveListModel;

@end
