//
//  OYHomeController.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/23.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYHomeController.h"
#import "OYNetworkManager.h"
#import "OYHomeRoomListModel.h"
#import "OYQuanMinLiveListModel.h"
#import "OYHomeCell.h"
#import "OYLiveRoomController.h"
#import "UIImage+OYImage.h"

#define headH 170
#define headMinH 64
static NSString *homeTableViewCellIdentifier = @"homeTableViewCellIdentifier";
@interface OYHomeController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray *roomList;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UIImageView *headerView;
@property (nonatomic, assign) CGFloat lastOffsetY;

@end

@implementation OYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setUI];
}

- (void)setUI {
    UIImageView *headerView = [[UIImageView alloc]init];
    self.headerView = headerView;
    headerView.image = [UIImage imageNamed:@"Home_header"];
    [self.view addSubview:headerView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"小编优选";
    [nameLabel sizeToFit];
    self.navigationItem.titleView = nameLabel;
    self.nameLabel = nameLabel;
    nameLabel.alpha = 0;
    self.lastOffsetY = -headH;
    
    UILabel *bannerLabel = [[UILabel alloc]init];
    bannerLabel.text = @"专心致志看游戏";
    bannerLabel.textColor = [UIColor whiteColor];
    bannerLabel.font = [UIFont fontWithName:@"FZLTZCHJW--GB1-0" size:20];
    bannerLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:bannerLabel];
    
    UITableView *tableView = [[UITableView alloc]init];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 200;
    tableView.contentInset = UIEdgeInsetsMake(headH, 0, 0, 0);
    [tableView registerClass:[OYHomeCell class] forCellReuseIdentifier:homeTableViewCellIdentifier];
    [self.view insertSubview:tableView atIndex:0];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(headH);
        make.top.left.right.equalTo(self.view);
    }];
    [bannerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

- (void)loadData {
//    [[OYNetworkManager sharedManager]getHomeRoomListWithCompletionHandler:^(id response) {
//        self.roomList = response;
//        [self.tableView reloadData];
//    }];
    [[OYNetworkManager sharedManager]getQuanMinRoomWithGameName:@"lol" andCompletionHandler:^(id response) {
        self.roomList = response;
        [self.tableView reloadData];
    }];
}

//MARK:- UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.roomList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OYHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:homeTableViewCellIdentifier forIndexPath:indexPath];
    cell.roomListModel = self.roomList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OYQuanMinLiveListModel *selectRoomModel = self.roomList[indexPath.row];
    NSString *liveName = selectRoomModel.title;
    NSString *streamUrl = selectRoomModel.stream;
//    [[OYNetworkManager sharedManager]getHomeRoomWithLiveType:liveType andLiveId:liveId andCompletionHandler:^(NSURL *streamUrl) {
//        [SVProgressHUD show];
//        NSString *scheme = [[streamUrl scheme] lowercaseString];
//        if ([scheme isEqualToString:@"http"]
//            || [scheme isEqualToString:@"https"]
//            || [scheme isEqualToString:@"rtmp"]) {
//            [OYLiveRoomController presentFromViewController:self withTitle:liveName URL:streamUrl andRoomList:self.roomList andIndexPath:indexPath completion:^{
//                //            [self.navigationController popViewControllerAnimated:NO];
//                [SVProgressHUD dismiss];
//            }];
//        }
//    }];
    [[OYNetworkManager sharedManager]getQuanMinRoomWithStreamUrl:streamUrl andCompletionHandler:^(NSURL *streamUrl) {
        [SVProgressHUD show];
        NSString *scheme = [[streamUrl scheme] lowercaseString];
        if ([scheme isEqualToString:@"http"]
            || [scheme isEqualToString:@"https"]
            || [scheme isEqualToString:@"rtmp"]) {
            [OYLiveRoomController presentFromViewController:self withTitle:liveName URL:streamUrl andRoomList:self.roomList andIndexPath:indexPath completion:^{
                //            [self.navigationController popViewControllerAnimated:NO];
                [SVProgressHUD dismiss];
            }];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat delta = offsetY - _lastOffsetY;
    CGFloat height = headH - delta;
    
    if (height < headMinH) {
        height = headMinH;
    }
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
    CGFloat alpha = delta / (headH - headMinH);
    if (alpha >= 1) {
        alpha = 0.99;
    }
    _nameLabel.alpha = alpha;
    UIImage *image = [UIImage oy_imageWithColor:[UIColor colorWithWhite:1 alpha:alpha]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}
@end
