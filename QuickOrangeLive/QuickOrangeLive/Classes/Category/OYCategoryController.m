//
//  OYCategoryController.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/23.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYCategoryController.h"
#import "OYCategoryLeftCell.h"
#import "OYCategoryRightCell.h"
#import "OYCategoryPlatformModel.h"
#import "OYLiveListController.h"


static NSString *lefttableviewCellIdentifier = @"leftTableviewCellIdentifier";
static NSString *rightCollectionViewCellIdentifier = @"rightCollectionViewCellIdentifier";
static float marginBetweenLeftAndRight = 0.5;
static float widthMagnificationOfLeftTableView = 0.2;

@interface OYCategoryController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,OYCategoryRightCellDelegate>

/** 左侧tableview选中cell的label */
@property (strong, nonatomic) UILabel *selectedCategoryLabel;
/** 模型数组 */
@property (strong, nonatomic) NSArray<OYCategoryPlatformModel *> *platformList;
/** 左侧tableView */
@property (weak, nonatomic) UITableView *leftTableView;
/** 右侧collectionView */
@property (weak, nonatomic) UICollectionView *rightCollectionView;
/** 当前选中的indexPath */
@property (strong, nonatomic) NSIndexPath *currentSelectedIndexPath;

@end

@implementation OYCategoryController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if ([self.leftTableView indexPathForSelectedRow] == nil) {
        [self.leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self changeSelectedCellColor:[self.leftTableView cellForRowAtIndexPath:indexPath]];
    }
    
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self loadCategoryData];
    [self setUI];
}

//MARK:- 加载数据
- (void)loadCategoryData {
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"category.plist" ofType:nil];
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:plistPath];
    NSArray *modelArr = [NSArray yy_modelArrayWithClass:[OYCategoryPlatformModel class] json:plistArr];
    self.platformList = modelArr;
}

//MARK:- UI布局
- (void)setUI {
    UITableView *leftTableView = [[UITableView alloc]init];
    self.leftTableView = leftTableView;
    [leftTableView registerClass:[OYCategoryLeftCell class] forCellReuseIdentifier:lefttableviewCellIdentifier];
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    leftTableView.rowHeight = 55;
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionViewFlowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.8 - marginBetweenLeftAndRight, [UIScreen mainScreen].bounds.size.height - NavigationBarHeight);
    collectionViewFlowLayout.minimumLineSpacing = 0;
    
    UICollectionView *rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
    self.rightCollectionView = rightCollectionView;
    [rightCollectionView registerClass:[OYCategoryRightCell class] forCellWithReuseIdentifier:rightCollectionViewCellIdentifier];
    rightCollectionView.pagingEnabled = YES;
    rightCollectionView.bounces = NO;
    rightCollectionView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:leftTableView];
    [self.view addSubview:rightCollectionView];
    
    leftTableView.dataSource = self;
    leftTableView.delegate = self;
    rightCollectionView.dataSource = self;
    rightCollectionView.delegate = self;
    
    [leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationBarHeight);
        make.left.bottom.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(widthMagnificationOfLeftTableView);
    }];
    
    [rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftTableView.mas_right).offset(marginBetweenLeftAndRight);
        make.top.equalTo(self.view).offset(NavigationBarHeight);
        make.right.bottom.equalTo(self.view);
    }];
    
}

//MARK:- 数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.platformList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OYCategoryLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:lefttableviewCellIdentifier forIndexPath:indexPath];
    cell.model = self.platformList[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.platformList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OYCategoryRightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:rightCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.platformList[indexPath.item];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    [self changeSelectedCellColor:[tableView cellForRowAtIndexPath:indexPath]];
    
    self.currentSelectedIndexPath = indexPath;
    
    // 右侧连动
    [self.rightCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 左侧连动
    if (scrollView == self.rightCollectionView) {
        // 将collectionView在控制器view的中心点转化成collectionView上的坐标
        CGPoint pInCollectionView = [self.view convertPoint:self.rightCollectionView.center toView:self.rightCollectionView];
        NSIndexPath *currentIndexPath = [self.rightCollectionView indexPathForItemAtPoint:pInCollectionView];
        
        self.currentSelectedIndexPath = currentIndexPath;
        
        [self.leftTableView selectRowAtIndexPath:currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self changeSelectedCellColor:[self.leftTableView cellForRowAtIndexPath:currentIndexPath]];
        [self.rightCollectionView reloadData];
    }
}

- (void)oyCategoryRightCell:(OYCategoryRightCell *)categoryRightCell didSelectGameCellAtIndexPath:(NSIndexPath *)indexPath {
    // 点击了游戏的cell
    OYLiveListController *liveListController = [[OYLiveListController alloc]init];
    [self.navigationController pushViewController:liveListController animated:YES];
    // 将模型传值给列表控制器
    liveListController.platFormModel = self.platformList[self.currentSelectedIndexPath.row];
    liveListController.gameModel = self.platformList[self.currentSelectedIndexPath.row].categories[indexPath.item];
}

//MARK:- 将当前的indexPath传递给cell
- (void)sendPatformInfoToRightCellWithCurrentIndexPath:(NSIndexPath *)currentIndexPath {
    OYCategoryRightCell *currentCollectionViewCell = (OYCategoryRightCell *)[self.rightCollectionView cellForItemAtIndexPath:currentIndexPath];
    currentCollectionViewCell.currentPlatFormIndexPath = currentIndexPath;
}
//MARK:- 设置选中文字改变
- (void)changeSelectedCellColor:(OYCategoryLeftCell *)cell {

    self.selectedCategoryLabel.font = [UIFont systemFontOfSize:14];
    self.selectedCategoryLabel.textColor = [UIColor darkGrayColor];
    
    self.selectedCategoryLabel = cell.categoryLabel;
    self.selectedCategoryLabel.font = [UIFont systemFontOfSize:18];
    self.selectedCategoryLabel.textColor = [UIColor oy_colorWithHex:0xF06D6B alpha:1];
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
