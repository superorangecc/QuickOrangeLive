//
//  OYHomeCell.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/2/4.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYHomeCell.h"
#import <UIImageView+WebCache.h>

@interface OYHomeCell()

@property (weak, nonatomic) UIImageView *liveImageView;
@property (weak, nonatomic) UILabel *liveNameLabel;
@property (weak, nonatomic) UIImageView *iconView;
@property (weak, nonatomic) UILabel *userNameLabel;

@end

@implementation OYHomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setRoomListModel:(OYQuanMinLiveListModel *)roomListModel {
    _roomListModel = roomListModel;
    [self.liveImageView sd_setImageWithURL:[NSURL URLWithString:roomListModel.thumb]];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:roomListModel.avatar]];
    self.liveNameLabel.text = roomListModel.title;
    self.userNameLabel.text = roomListModel.nick;
}

- (void)setUI {
    UIImageView *liveImageView = [[UIImageView alloc]init];
    self.liveImageView = liveImageView;
    liveImageView.image = [UIImage imageNamed:@"loading"];
    [self.contentView addSubview:liveImageView];
    
    UIView *overLayView = [[UIView alloc]init];
    overLayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.contentView addSubview:overLayView];
    
    UILabel *liveNameLabel = [[UILabel alloc]init];
    self.liveNameLabel = liveNameLabel;
    liveNameLabel.font = [UIFont fontWithName:@"FZLTZCHJW--GB1-0" size:16];
    liveNameLabel.text = @"暴雨将至的山间骑行";
    liveNameLabel.textColor = [UIColor whiteColor];
    liveNameLabel.textAlignment = NSTextAlignmentCenter;
    [overLayView addSubview:liveNameLabel];
    
    UIImageView *iconView = [[UIImageView alloc]init];
    self.iconView = iconView;
    iconView.image = [UIImage imageNamed:@"dota2"];
    iconView.layer.cornerRadius = 10;
    iconView.layer.masksToBounds = YES;
    [overLayView addSubview:iconView];
    
    UILabel *separateLabel = [[UILabel alloc]init];
    separateLabel.text = @"/";
    separateLabel.textColor = [UIColor whiteColor];
    [overLayView addSubview:separateLabel];
    
    UILabel *userNameLabel = [[UILabel alloc]init];
    self.userNameLabel = userNameLabel;
    userNameLabel.text = @"小满";
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.font = [UIFont systemFontOfSize:10];
    [overLayView addSubview:userNameLabel];
    
    //MARK:- autoLayout
    [liveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [overLayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [liveNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-20);
        make.centerX.equalTo(self.contentView);
    }];
    
    [separateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(10);
        make.centerX.equalTo(self.contentView);
    }];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(separateLabel);
        make.right.equalTo(separateLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(separateLabel);
        make.left.equalTo(separateLabel.mas_right).offset(5);
    }];
}

@end
