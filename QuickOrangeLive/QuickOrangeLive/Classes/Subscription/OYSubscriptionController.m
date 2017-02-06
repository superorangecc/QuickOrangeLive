//
//  OYSubscriptionController.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/23.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYSubscriptionController.h"
#import "OYCollectionManager.h"
#import "OYLiveListCell.h"
#import "OYNetworkManager.h"
#import "OYLiveRoomController.h"

static NSString *liveListCollectionViewCellIdentifer = @"liveListCollectionViewCellIdentifer";
static CGFloat verticalMargin = 5;
static CGFloat horizontalMargin = 5;
@interface OYSubscriptionController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (copy, nonatomic) NSArray *collectionModelArr;

@property (strong, nonatomic) NSMutableArray *liveRoomList;
@property (weak, nonatomic) UICollectionView *liveListCollectionView;
@property (nonatomic) NSInteger platformId;

@end

@implementation OYSubscriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setUI];
}

- (void)loadData {
    [[OYCollectionManager sharedManager]getAllCollectionsWithPage:1 allCollectionsBlock:^(NSArray *collectionModelArr) {
        self.liveRoomList = collectionModelArr.mutableCopy;
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
    
    if ([self.liveRoomList[indexPath.item] isKindOfClass:[OYPandaLiveListModel class]]) {
        cell.pandaLiveListModel = self.liveRoomList[indexPath.item];
    }else if ([self.liveRoomList[indexPath.item] isKindOfClass:[OYZhanqiLiveListModel class]]) {
        cell.zhanqiLiveListModel = self.liveRoomList[indexPath.item];
    }else if ([self.liveRoomList[indexPath.item] isKindOfClass:[OYQuanMinLiveListModel class]]) {
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
    if ([self.liveRoomList[indexPath.item] isKindOfClass:[OYPandaLiveListModel class]]) {
        OYPandaLiveListModel *pandaLiveModel = self.liveRoomList[indexPath.item];
        liveName = pandaLiveModel.name;
        roomId = pandaLiveModel.roomId;
        self.platformId = 3;
    }else if ([self.liveRoomList[indexPath.item] isKindOfClass:[OYZhanqiLiveListModel class]]) {
        OYZhanqiLiveListModel *zhanqiLiveModel = self.liveRoomList[indexPath.item];
        liveName = zhanqiLiveModel.title;
        videoId =  zhanqiLiveModel.videoId;
        self.platformId = 2;
    }else if ([self.liveRoomList[indexPath.item] isKindOfClass:[OYQuanMinLiveListModel class]]) {
        OYQuanMinLiveListModel *quanminLiveModel = self.liveRoomList[indexPath.item];
        liveName = quanminLiveModel.title;
        stream = quanminLiveModel.stream;
        self.platformId = 5;
    }
    [self loadLiveDataWithRoomId:roomId andVideoId:videoId andStream:stream andLiveName:liveName andRoomList:self.liveRoomList andIndexPath:indexPath];
}

- (void)loadLiveDataWithRoomId:(NSInteger)roomId andVideoId:(NSString *)videoId andStream:(NSString *)stream andLiveName:(NSString *)liveName andRoomList:(NSArray *)roomList andIndexPath:(NSIndexPath *)indexPath {
    [[OYNetworkManager sharedManager]getRoomWithPlatformId:(int)self.platformId andRoomId:(int)roomId andVideoId:videoId andStreamUrl:stream andCompletionHandler:^(NSURL *streamUrl) {
        [SVProgressHUD show];
        NSString *scheme = [[streamUrl scheme] lowercaseString];
        if ([scheme isEqualToString:@"http"]
            || [scheme isEqualToString:@"https"]
            || [scheme isEqualToString:@"rtmp"]) {
            [OYLiveRoomController presentFromViewController:self withTitle:liveName URL:streamUrl andRoomList:roomList andIndexPath:indexPath completion:^{
                //            [self.navigationController popViewControllerAnimated:NO];
                [SVProgressHUD dismiss];
            }];
        }
    }];
}

@end
