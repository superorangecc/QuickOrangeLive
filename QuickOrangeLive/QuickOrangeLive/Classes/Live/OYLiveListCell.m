//
//  OYLiveListCell.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/25.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYLiveListCell.h"
#import <UIImageView+WebCache.h>

@interface OYLiveListCell()

/** 缩略图 */
@property (weak, nonatomic) UIImageView *screenshotImageView;
/** 主播名 */
@property (weak, nonatomic) UILabel *anchorNameLabel;
/** 观众图 */
@property (weak, nonatomic) UIImageView *audienceImageView;
/** 观众人数 */
@property (weak, nonatomic) UILabel *audienceCountLabel;
/** 直播名 */
@property (weak, nonatomic) UILabel *liveNameLabel;

@end

@implementation OYLiveListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setDouyuLiveListModel:(OYDouyuLiveListModel *)douyuLiveListModel {
    _douyuLiveListModel = douyuLiveListModel;
    [self.screenshotImageView sd_setImageWithURL:[NSURL URLWithString:douyuLiveListModel.room_src]];
    self.audienceCountLabel.text = douyuLiveListModel.online;
    self.liveNameLabel.text = douyuLiveListModel.room_name;
    self.anchorNameLabel.text = douyuLiveListModel.nickname;
}

- (void)setHuoMaoLiveListModel:(OYHuoMaoLiveListModel *)huoMaoliveListModel {
    _huoMaoLiveListModel = huoMaoliveListModel;
    [self.screenshotImageView sd_setImageWithURL:[NSURL URLWithString:huoMaoliveListModel.imgName]];
    self.audienceCountLabel.text = huoMaoliveListModel.audienceCount;
    self.liveNameLabel.text = huoMaoliveListModel.roomName;
    self.anchorNameLabel.text = huoMaoliveListModel.userName;
}

- (void)setPandaLiveListModel:(OYPandaLiveListModel *)pandaLiveListModel {
    _pandaLiveListModel = pandaLiveListModel;
    [self.screenshotImageView sd_setImageWithURL:[NSURL URLWithString:pandaLiveListModel.pictures[@"img"]]];
    self.audienceCountLabel.text = pandaLiveListModel.person_num;
    self.liveNameLabel.text = pandaLiveListModel.name;
    self.anchorNameLabel.text = pandaLiveListModel.userinfo[@"nickName"];
}

- (void)setZhanqiLiveListModel:(OYZhanqiLiveListModel *)zhanqiLiveListModel {
    _zhanqiLiveListModel = zhanqiLiveListModel;
    [self.screenshotImageView sd_setImageWithURL:[NSURL URLWithString:zhanqiLiveListModel.bpic]];
    self.audienceCountLabel.text = zhanqiLiveListModel.online;
    self.liveNameLabel.text = zhanqiLiveListModel.title;
    self.anchorNameLabel.text = zhanqiLiveListModel.nickname;
}

- (void)setQuanminLiveListModel:(OYQuanMinLiveListModel *)quanminLiveListModel {
    _quanminLiveListModel = quanminLiveListModel;
    [self.screenshotImageView sd_setImageWithURL:[NSURL URLWithString:quanminLiveListModel.thumb]];
    self.audienceCountLabel.text = quanminLiveListModel.view;
    self.liveNameLabel.text = quanminLiveListModel.title;
    self.anchorNameLabel.text = quanminLiveListModel.nick;
}

- (void)setUI {
    UIImageView *screenshotImageView = [[UIImageView alloc]init];
    self.screenshotImageView = screenshotImageView;
//    screenshotImageView.backgroundColor = [UIColor whiteColor];
    screenshotImageView.layer.cornerRadius = 10;
    screenshotImageView.layer.masksToBounds = YES;
    screenshotImageView.image = [UIImage imageNamed:@"loading"];
    
    UILabel *anchorNameLabel = [[UILabel alloc]init];
    self.anchorNameLabel = anchorNameLabel;
    anchorNameLabel.font = [UIFont systemFontOfSize:10];
    anchorNameLabel.textColor = [UIColor whiteColor];
    anchorNameLabel.text = @"ZSMJ";
    
    UIImageView *audienceImageView = [[UIImageView alloc]init];
    self.audienceImageView = audienceImageView;
    audienceImageView.image = [UIImage imageNamed:@"num"];
    
    UILabel *audienceCountLabel = [[UILabel alloc]init];
    audienceCountLabel.text = @"2.01万";
    audienceCountLabel.font = [UIFont systemFontOfSize:10];
    audienceCountLabel.textColor = [UIColor whiteColor];
    self.audienceCountLabel = audienceCountLabel;
    
    UILabel *liveNameLabel = [[UILabel alloc]init];
    liveNameLabel.text = @"CDEC冲分";
    liveNameLabel.font = [UIFont systemFontOfSize:12];
    liveNameLabel.textAlignment = NSTextAlignmentCenter;
    self.liveNameLabel = liveNameLabel;
    
    [self.contentView addSubview:screenshotImageView];
    [self.screenshotImageView addSubview:anchorNameLabel];
    [self.screenshotImageView addSubview:audienceImageView];
    [self.screenshotImageView addSubview:audienceCountLabel];
    [self.contentView addSubview:liveNameLabel];
    
    [screenshotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-15);
        make.left.top.right.equalTo(self.contentView);
    }];
    
    [anchorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(screenshotImageView).offset(-3);
        make.left.equalTo(screenshotImageView).offset(8);
    }];
    
    [audienceCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(screenshotImageView).offset(-8);
        make.top.equalTo(anchorNameLabel);
    }];
    
    [audienceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(audienceCountLabel.mas_left);
        make.centerY.equalTo(anchorNameLabel);
    }];
    
    CGFloat liveNameLabelW = [UIScreen mainScreen].bounds.size.width * 0.5 - 30;
    [liveNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-5);
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(liveNameLabelW);
        make.top.equalTo(screenshotImageView.mas_bottom).offset(5);
    }];
}

@end
