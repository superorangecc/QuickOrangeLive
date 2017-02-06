//
//  OYCategoryRightCell.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/24.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//  右侧CollectionView的cell

#import "OYCategoryRightCell.h"
#import "OYCategoryGameCell.h"

static CGFloat seperatorLineWidth = 30;
static CGFloat seperatorLineHeight = 1;
static CGFloat magnificationOfBannerButton = 0.2;
static NSString *gameCategoryCellIdentifier = @"gameCategoryCellIdentifier";
@interface OYCategoryRightCell()<UICollectionViewDataSource,UICollectionViewDelegate>

/** button */
@property (weak, nonatomic) UIButton *topBannerButton;
/** 左侧分隔线 */
@property (weak, nonatomic) UIView *leftSeperatorLine;
/** 右侧分隔线 */
@property (weak, nonatomic) UIView *rightSeperatorLine;
/** 分隔label */
@property (weak, nonatomic) UILabel *seperatorLabel;
/** 游戏分类的CollectionView */
@property (weak, nonatomic) UICollectionView *gameCategoryCollectionView;

@end

@implementation OYCategoryRightCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setModel:(OYCategoryPlatformModel *)model {
    _model = model;
    [self.topBannerButton setImage:[UIImage imageNamed:model.bannerpic] forState:UIControlStateNormal];
    [self.gameCategoryCollectionView reloadData];
}

- (void)setUI {
    UIButton *topBannerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBannerButton setImage:[UIImage imageNamed:@"douyu"] forState:UIControlStateNormal];
    [topBannerButton addTarget:self action:@selector(topBannerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.topBannerButton = topBannerButton;
    
    UIView *leftSeperatorLine = [[UIView alloc]init];
    leftSeperatorLine.backgroundColor = [UIColor oy_colorWithHex:0xd9d9d9 alpha:1];
    self.leftSeperatorLine = leftSeperatorLine;
    
    UIView *rightSeperatorLine = [[UIView alloc]init];
    rightSeperatorLine.backgroundColor = [UIColor oy_colorWithHex:0xd9d9d9 alpha:1];
    self.rightSeperatorLine = rightSeperatorLine;
    
    UILabel *seperatorLabel = [[UILabel alloc]init];
    seperatorLabel.text = @"游戏分类";
    seperatorLabel.font = [UIFont systemFontOfSize:12];
    seperatorLabel.textColor = [UIColor darkGrayColor];
    self.seperatorLabel = seperatorLabel;
    
    CGFloat gameCategoryCellMargin = 10;
    CGFloat gameCategoryCellW = (self.contentView.bounds.size.width - 4 * gameCategoryCellMargin) / 3;
    CGFloat gameCategoryCellH = gameCategoryCellW;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(gameCategoryCellW, gameCategoryCellH);
    layout.minimumLineSpacing = 25;
    layout.minimumInteritemSpacing = gameCategoryCellMargin;
    layout.sectionInset = UIEdgeInsetsMake(30, 0, 0, 0);
    
    UICollectionView *gameCategoryCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    gameCategoryCollectionView.backgroundColor = [UIColor whiteColor];
    gameCategoryCollectionView.dataSource = self;
    gameCategoryCollectionView.delegate = self;
    [gameCategoryCollectionView registerClass:[OYCategoryGameCell class] forCellWithReuseIdentifier:gameCategoryCellIdentifier];
    self.gameCategoryCollectionView = gameCategoryCollectionView;
    
    [self.contentView addSubview:topBannerButton];
    [self.contentView addSubview:leftSeperatorLine];
    [self.contentView addSubview:rightSeperatorLine];
    [self.contentView addSubview:seperatorLabel];
    [self.contentView addSubview:gameCategoryCollectionView];
    
    //MARK:- 在这里修改banner图的约束
    [self.topBannerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-8);
        make.height.equalTo(self.contentView).multipliedBy(magnificationOfBannerButton);
    }];
    
    [self.seperatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBannerButton.mas_bottom).offset(8);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.leftSeperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.seperatorLabel.mas_left).offset(-8);
        make.centerY.equalTo(self.seperatorLabel);
        make.height.mas_equalTo(seperatorLineHeight);
        make.width.mas_equalTo(seperatorLineWidth);
    }];
    
    [self.rightSeperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.seperatorLabel.mas_right).offset(8);
        make.centerY.equalTo(self.seperatorLabel);
        make.height.mas_equalTo(seperatorLineHeight);
        make.width.mas_equalTo(seperatorLineWidth);
    }];
    
    [self.gameCategoryCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seperatorLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-58);
    }];

    
}

//MARK:- topbannerButton 点击事件
- (void)topBannerButtonAction {
    NSLog(@"点击了banner");
}

//MARK:- 数据源、代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OYCategoryGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gameCategoryCellIdentifier forIndexPath:indexPath];
    cell.model = self.model.categories[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(oyCategoryRightCell:didSelectGameCellAtIndexPath:)]) {
        [self.delegate oyCategoryRightCell:self didSelectGameCellAtIndexPath:indexPath];
    }
}

@end
