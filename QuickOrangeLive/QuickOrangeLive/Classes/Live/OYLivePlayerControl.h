//
//  OYLivePlayerControl.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/2/1.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
@class OYLiveRoomController;

@interface OYLivePlayerControl : UIControl

@property (strong, nonatomic) OYLiveRoomController *liveRoomController;

@property (weak, nonatomic) id<IJKMediaPlayback> delegatePlayer;
@property (weak, nonatomic) UIView *overlayPanel;
@property (weak, nonatomic) UISlider *mediaProgressSlider;
@property (weak, nonatomic) UILabel *currentTimeLabel;
@property (weak, nonatomic) UIButton *playButton;
@property (weak, nonatomic) UIButton *pauseButton;
@property (weak, nonatomic) UILabel *liveNameLabel;


@property (copy, nonatomic) NSString *liveName;

- (instancetype)initWithLiveRoomVc:(OYLiveRoomController *)liveRoomVc;

- (void)showAndFade;
- (void)hide;
- (void)refreshMediaControl;
- (void)volumeUp;
- (void)volumeDown;

@end
