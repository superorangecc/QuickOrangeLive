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
#import "OYHomeCell.h"
#import "OYLiveRoomController.h"

static NSString *homeTableViewCellIdentifier = @"homeTableViewCellIdentifier";
@interface OYHomeController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray<OYHomeRoomListModel *> *roomList;
@property (weak, nonatomic) UITableView *tableView;


@end

@implementation OYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setUI];
}

- (void)setUI {
    UITableView *tableView = [[UITableView alloc]init];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 200;
    [tableView registerClass:[OYHomeCell class] forCellReuseIdentifier:homeTableViewCellIdentifier];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadData {
    [[OYNetworkManager sharedManager]getHomeRoomListWithCompletionHandler:^(id response) {
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
    OYHomeRoomListModel *selectRoomModel = self.roomList[indexPath.row];
    NSString *liveType = selectRoomModel.live_type;
    NSString *liveId = selectRoomModel.live_id;
    NSString *liveName = selectRoomModel.live_title;
    [[OYNetworkManager sharedManager]getHomeRoomWithLiveType:liveType andLiveId:liveId andCompletionHandler:^(NSURL *streamUrl) {
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
