//
//  OYLivePlayerControl.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/2/1.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYLivePlayerControl.h"

@implementation OYLivePlayerControl {
    BOOL _isMediaSliderBeingDragged;
    UIProgressView *_volumeProgressView;
}

- (instancetype)initWithLiveRoomVc:(OYLiveRoomController *)liveRoomVc  {
    if (self = [super init]) {
        self.liveRoomController = liveRoomVc;
        [self setUI];
        [self refreshMediaControl];
        [self hide];
    }
    return self;
}

- (void)setLiveName:(NSString *)liveName {
    _liveName = liveName;
    self.liveNameLabel.text = self.liveName;
}

- (void)setUI {
    [self addTarget:self.liveRoomController action:@selector(onClickPlayerControl) forControlEvents:UIControlEventTouchDown];
        
    UIControl *overlayPanel = [[UIControl alloc]init];
    [overlayPanel addTarget:self.liveRoomController action:@selector(onClickOverlayPanel) forControlEvents:UIControlEventTouchDown];
    overlayPanel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.overlayPanel = overlayPanel;
    [self addSubview:overlayPanel];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton addTarget:self.liveRoomController action:@selector(onClickPlay) forControlEvents:UIControlEventTouchUpInside];
    self.playButton = playButton;
    [playButton setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    [overlayPanel addSubview:playButton];
    
    UIButton *pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pauseButton addTarget:self.liveRoomController action:@selector(onClickPause) forControlEvents:UIControlEventTouchUpInside];
    self.pauseButton = pauseButton;
    [pauseButton setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
    [overlayPanel addSubview:pauseButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton addTarget:self.liveRoomController action:@selector(onClickNext) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
    [overlayPanel addSubview:nextButton];
    
    UIProgressView *volumeProgressView = [[UIProgressView alloc]init];
    _volumeProgressView = volumeProgressView;
    volumeProgressView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [_volumeProgressView setProgress:self.delegatePlayer.playbackVolume / 12.0];
    volumeProgressView.trackTintColor = [UIColor lightGrayColor];
    volumeProgressView.progressTintColor = [UIColor whiteColor];
    [overlayPanel addSubview:volumeProgressView];
    
    UIButton *volumeUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [volumeUpButton addTarget:self.liveRoomController action:@selector(onClickVolumnUp) forControlEvents:UIControlEventTouchUpInside];
    [volumeUpButton setImage:[UIImage imageNamed:@"Action_Volume+_44x44_"] forState:UIControlStateNormal];
    [overlayPanel addSubview:volumeUpButton];
    
    UIButton *volumeDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [volumeDownButton addTarget:self.liveRoomController action:@selector(onClickVolumnDown) forControlEvents:UIControlEventTouchUpInside];
    [volumeDownButton setImage:[UIImage imageNamed:@"Action_Volume-_44x44_"] forState:UIControlStateNormal];
    [overlayPanel addSubview:volumeDownButton];
    
    UILabel *currentTimeLabel = [[UILabel alloc]init];
    currentTimeLabel.font = [UIFont systemFontOfSize:12];
    currentTimeLabel.text = @"正在直播";
    currentTimeLabel.textColor = [UIColor whiteColor];
    [overlayPanel addSubview:currentTimeLabel];
    
    UILabel *totalTimeLabel = [[UILabel alloc]init];
    self.currentTimeLabel = totalTimeLabel;
    totalTimeLabel.font = [UIFont systemFontOfSize:12];
    totalTimeLabel.textColor = [UIColor whiteColor];
    totalTimeLabel.text = @"01:02";
    [overlayPanel addSubview:totalTimeLabel];
    
    UISlider *mediaProgressSlider = [[UISlider alloc]init];
    self.mediaProgressSlider = mediaProgressSlider;
    [mediaProgressSlider setThumbImage:[UIImage imageNamed:@"ic_slider_thumb_30x30_"] forState:UIControlStateNormal];
    [overlayPanel addSubview:mediaProgressSlider];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self.liveRoomController action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"Action_backward_white_44x44_"] forState:UIControlStateNormal];
    [overlayPanel addSubview:backButton];
    
    UILabel *liveNameLabel = [[UILabel alloc]init];
    self.liveNameLabel = liveNameLabel;
    liveNameLabel.font = [UIFont systemFontOfSize:14];
    liveNameLabel.textColor = [UIColor whiteColor];
    [overlayPanel addSubview:liveNameLabel];
    
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeButton = likeButton;
    [likeButton addTarget:self.liveRoomController action:@selector(onClickLike) forControlEvents:UIControlEventTouchUpInside];
    [likeButton setImage:[UIImage imageNamed:@"action_ic_like_27x24_"] forState:UIControlStateNormal];
    [likeButton setImage:[UIImage imageNamed:@"action_ic_liked_27x24_"] forState:UIControlStateSelected];
    [overlayPanel addSubview:likeButton];
    
    UIButton *screenShotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [screenShotButton setImage:[UIImage imageNamed:@"Action_Screenshots_44x44_"] forState:UIControlStateNormal];
    [overlayPanel addSubview:screenShotButton];
    
    UIButton *sharpnessSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sharpnessSelectedButton setImage:[UIImage imageNamed:@"Action_HD_44x44_"] forState:UIControlStateNormal];
    [overlayPanel addSubview:sharpnessSelectedButton];
    
    //MARK:- autoLayout
    [overlayPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(overlayPanel);
    }];
    
    [pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(overlayPanel);
    }];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(playButton);
        make.right.equalTo(overlayPanel).offset(-8);
    }];
    
    [volumeProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(overlayPanel);
        make.left.equalTo(overlayPanel).offset(-25);
        make.size.mas_equalTo(CGSizeMake(100, 3));
    }];
    
    [volumeUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(volumeProgressView.mas_top).offset(-45);
        make.centerX.equalTo(volumeProgressView);
    }];
    
    [volumeDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(volumeProgressView.mas_bottom).offset(45);
        make.centerX.equalTo(volumeProgressView);
    }];
    
    [currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(overlayPanel).offset(8);
        make.bottom.equalTo(overlayPanel).offset(-10);
    }];
    
    [totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(overlayPanel).offset(-8);
        make.bottom.equalTo(overlayPanel).offset(-10);
    }];
    
    [mediaProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentTimeLabel.mas_right).offset(3);
        make.right.equalTo(totalTimeLabel.mas_left).offset(-3);
        make.centerY.equalTo(totalTimeLabel);
    }];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(overlayPanel).offset(8);
        make.top.equalTo(overlayPanel).offset(5);
    }];
    
    [liveNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backButton.mas_right).offset(5);
        make.centerY.equalTo(backButton);
    }];
    
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(overlayPanel).offset(-16);
        make.centerY.equalTo(liveNameLabel);
        make.size.mas_equalTo(CGSizeMake(18, 16));
    }];
    
    [screenShotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(likeButton.mas_left).offset(-8);
        make.centerY.equalTo(likeButton);
    }];
    
    [sharpnessSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(screenShotButton.mas_left).offset(-5);
        make.centerY.equalTo(screenShotButton);
    }];
}

//MARK:- apis of controlPanel
- (void)showNoFade
{
    self.overlayPanel.hidden = NO;
    [self cancelDelayedHide];
    [self refreshMediaControl];
}

// 显示然后延迟隐藏
- (void)showAndFade
{
    [self showNoFade];
    [self performSelector:@selector(hide) withObject:nil afterDelay:5];
}

- (void)hide
{
    self.overlayPanel.hidden = YES;
    [self cancelDelayedHide];
}

- (void)cancelDelayedHide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
}

- (void)volumeUp {
    if (self.delegatePlayer.playbackVolume > 12.0f) {
        return;
    }
    self.delegatePlayer.playbackVolume += 0.1;
    float currentVolume = self.delegatePlayer.playbackVolume;
    [_volumeProgressView setProgress:currentVolume / 12.0 animated:YES];
}

- (void)volumeDown {
    if (self.delegatePlayer.playbackVolume< 0.0f) {
        return;
    }
    self.delegatePlayer.playbackVolume -= 0.1;
    [_volumeProgressView setProgress:self.delegatePlayer.playbackVolume / 12.0 animated:YES];
}

- (void)beginDragMediaSlider
{
    _isMediaSliderBeingDragged = YES;
}

- (void)endDragMediaSlider
{
    _isMediaSliderBeingDragged = NO;
}

- (void)continueDragMediaSlider
{
    [self refreshMediaControl];
}

- (void)refreshMediaControl
{
    // duration
    NSTimeInterval duration = self.delegatePlayer.duration;
    NSInteger intDuration = duration + 0.5;
    if (intDuration > 0) {
        self.mediaProgressSlider.maximumValue = duration;
//        self.totalDurationLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
    } else {
//        self.totalDurationLabel.text = @"--:--";
        self.mediaProgressSlider.maximumValue = 1.0f;
    }
    
    
    // position
    NSTimeInterval position;
    if (_isMediaSliderBeingDragged) {
        position = self.mediaProgressSlider.value;
    } else {
        position = self.delegatePlayer.currentPlaybackTime;
    }
    NSInteger intPosition = position + 0.5;
    if (intDuration > 0) {
        self.mediaProgressSlider.value = position;
    } else {
        self.mediaProgressSlider.value = 0.0f;
    }
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intPosition / 60), (int)(intPosition % 60)];
    
    // status
    BOOL isPlaying = [self.delegatePlayer isPlaying];
    self.playButton.hidden = isPlaying;
    self.pauseButton.hidden = !isPlaying;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    if (!self.overlayPanel.hidden) {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
    }
}


- (void)onClickPlayerControl{}
- (void)onClickBack{}
- (void)onClickPlay{}
- (void)onClickPause{}
- (void)onClickNext{}
- (void)onClickOverlayPanel{}
- (void)onClickVolumnUp{}
- (void)onClickVolumnDown{}
- (void)onClickLike{}

@end
