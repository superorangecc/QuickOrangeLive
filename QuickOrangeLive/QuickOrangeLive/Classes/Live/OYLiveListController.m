//
//  OYLiveListController.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/25.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//  直播列表页

#import "OYLiveListController.h"
#import "OYLiveListCell.h"
#import "OYNetworkManager.h"
#import "OYLiveListModel.h"
#import "OYLiveRoomController.h"
#import "OYPandaLiveListModel.h"
#import "OYZhanqiLiveListModel.h"
#import "OYQuanMinLiveListModel.h"
#import <MJRefresh.h>

static NSString *liveListCollectionViewCellIdentifer = @"liveListCollectionViewCellIdentifer";
static CGFloat verticalMargin = 5;
static CGFloat horizontalMargin = 5;
@interface OYLiveListController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *liveRoomList;
@property (weak, nonatomic) UICollectionView *liveListCollectionView;

@end

@implementation OYLiveListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"列表";
    self.currentPage = 1;
    self.liveRoomList = [NSMutableArray array];
    [self loadData];
    [self setUI];
    [self configRefresh];
    
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)loadData {
    [[OYNetworkManager sharedManager]getRoomListWithPlatformId:(int)self.platFormModel.platformid andGameId:self.gameModel.gameId andPageNum:self.currentPage  andCompletionHandler:^(id response) {
        if (self.currentPage == 1) {
            [self.liveRoomList removeAllObjects];
        }
        [self.liveRoomList addObjectsFromArray:response];
        [self.liveListCollectionView.mj_header endRefreshing];
        [self.liveListCollectionView.mj_footer endRefreshing];
        [self.liveListCollectionView reloadData];
    }];
}

- (void)configRefresh {
    self.liveListCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self loadData];
    }];
    
    self.liveListCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self loadData];
    }];
}

- (void)setUI {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat liveInfoW = ([UIScreen mainScreen].bounds.size.width - 3 * horizontalMargin) / 2;
    CGFloat liveInfoH = ([UIScreen mainScreen].bounds.size.height - NavigationBarHeight - TabBarHeight - 4 * verticalMargin) / 4;
    flowLayout.itemSize = CGSizeMake(liveInfoW, liveInfoH);
    flowLayout.minimumLineSpacing = verticalMargin;
    flowLayout.minimumInteritemSpacing = horizontalMargin;
    flowLayout.sectionInset = UIEdgeInsetsMake(verticalMargin, horizontalMargin, verticalMargin, horizontalMargin);
    UICollectionView *liveListCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.liveListCollectionView = liveListCollectionView;
    liveListCollectionView.dataSource = self;
    liveListCollectionView.delegate = self;
    liveListCollectionView.backgroundColor = [UIColor whiteColor];
    [liveListCollectionView registerClass:[OYLiveListCell class] forCellWithReuseIdentifier:liveListCollectionViewCellIdentifer];
    
    [self.view addSubview:liveListCollectionView];
    
    [liveListCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

//MARK:- 数据源代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.liveRoomList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OYLiveListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:liveListCollectionViewCellIdentifer forIndexPath:indexPath];
    if ([self.liveRoomList[0] isKindOfClass:[OYPandaLiveListModel class]]) {
        cell.pandaLiveListModel = self.liveRoomList[indexPath.item];
    }else if ([self.liveRoomList[0] isKindOfClass:[OYZhanqiLiveListModel class]]) {
        cell.zhanqiLiveListModel = self.liveRoomList[indexPath.item];
    }else if ([self.liveRoomList[0] isKindOfClass:[OYQuanMinLiveListModel class]]) {
        cell.quanminLiveListModel = self.liveRoomList[indexPath.item];
    }
    return cell;
}

//MARK:- 跳转进入直播间
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger roomId = 0;
    NSString *videoId = [[NSString alloc]init];
    NSString *stream = [[NSString alloc]init];
    NSString *liveName = [[NSString alloc]init];
    if ([self.liveRoomList[0] isKindOfClass:[OYPandaLiveListModel class]]) {
        OYPandaLiveListModel *pandaLiveModel = self.liveRoomList[indexPath.item];
        liveName = pandaLiveModel.name;
        roomId = pandaLiveModel.roomId;
    }else if ([self.liveRoomList[0] isKindOfClass:[OYZhanqiLiveListModel class]]) {
        OYZhanqiLiveListModel *zhanqiLiveModel = self.liveRoomList[indexPath.item];
        liveName = zhanqiLiveModel.title;
        videoId =  zhanqiLiveModel.videoId;
    }else if ([self.liveRoomList[0] isKindOfClass:[OYQuanMinLiveListModel class]]) {
        OYQuanMinLiveListModel *quanminLiveModel = self.liveRoomList[indexPath.item];
        liveName = quanminLiveModel.title;
        stream = quanminLiveModel.stream;
    }
    [self loadLiveDataWithRoomId:roomId andVideoId:videoId andStream:stream andLiveName:liveName];
}

- (void)loadLiveDataWithRoomId:(NSInteger)roomId andVideoId:(NSString *)videoId andStream:(NSString *)stream andLiveName:(NSString *)liveName {
    [[OYNetworkManager sharedManager]getRoomWithPlatformId:(int)self.platFormModel.platformid andRoomId:(int)roomId andVideoId:videoId andStreamUrl:stream andCompletionHandler:^(NSURL *streamUrl) {
        NSString *scheme = [[streamUrl scheme] lowercaseString];
        if ([scheme isEqualToString:@"http"]
            || [scheme isEqualToString:@"https"]
            || [scheme isEqualToString:@"rtmp"]) {
            [OYLiveRoomController presentFromViewController:self withTitle:liveName URL:streamUrl completion:^{
                //            [self.navigationController popViewControllerAnimated:NO];
            }];
        }
    }];
}

@end
