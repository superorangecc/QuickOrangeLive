//
//  OYCategoryGameCell.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/24.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYCategoryGameCell.h"

@interface OYCategoryGameCell()

/** 游戏图标 */
@property (weak, nonatomic) UIImageView *iconView;
/** 游戏名 */
@property (weak, nonatomic) UILabel *nameLabel;

@end

@implementation OYCategoryGameCell

- (void)setModel:(OYCategoryGameModel *)model {
    _model = model;
    self.iconView.image = [UIImage imageNamed:model.icon];
    self.nameLabel.text = model.name;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.layer.cornerRadius = 30;
    iconView.layer.masksToBounds = YES;
    self.iconView = iconView;
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textColor = [UIColor darkGrayColor];
    self.nameLabel = nameLabel;
    
    [self.contentView addSubview:iconView];
    [self.contentView addSubview:nameLabel];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_bottom).offset(5);
        make.centerX.equalTo(iconView);
    }];
    
}

@end
