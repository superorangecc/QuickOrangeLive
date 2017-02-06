//
//  OYCategoryLeftCell.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/23.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYCategoryLeftCell.h"

@interface OYCategoryLeftCell()

/** 选中的cell */
@property (weak, nonatomic) UIView *selectedCellView;

@end

@implementation OYCategoryLeftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setModel:(OYCategoryPlatformModel *)model {
    _model = model;
    self.categoryLabel.text = model.name;
}

- (void)setUI {
    UILabel *categoryLabel = [[UILabel alloc]init];
    self.categoryLabel = categoryLabel;
    categoryLabel.font = [UIFont systemFontOfSize:14];
    categoryLabel.text = @"斗鱼";
    categoryLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:categoryLabel];
    
    UIView *selectedView = [[UIView alloc]init];
    self.selectedCellView = selectedView;
    self.selectedBackgroundView = self.selectedCellView;
    
    UIView *orangeView = [[UIView alloc]init];
    orangeView.backgroundColor = [UIColor oy_colorWithHex:0xF06D6B alpha:1];
    [self.selectedCellView addSubview:orangeView];
    
    [categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    
    [orangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectedView);
        make.centerY.equalTo(selectedView);
        make.height.mas_equalTo(30);
        make.width.equalTo(selectedView).multipliedBy(0.03);
    }];
}

@end
