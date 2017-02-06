//
//  OYLiveRoomController.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/28.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYLiveRoomController.h"
#import "OYNetworkManager.h"
#import "AppDelegate.h"
#import "OYCollectionManager.h"

@interface OYLiveRoomController ()

@end

@implementation OYLiveRoomController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.allowRotation = 1;

#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    // [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
    
    OYLivePlayerControl *playerControl = [[OYLivePlayerControl alloc]initWithLiveRoomVc:self];
    self.playerControl = playerControl;
    playerControl.delegatePlayer = self.player;
    playerControl.liveName = self.liveName;
    [[OYCollectionManager sharedManager]isCollected:self.roomList[self.indexPath.item] resultBlock:^(BOOL isCollected) {
        playerControl.likeButton.selected = isCollected;
    }];
    [self.view addSubview:playerControl];
    
    [playerControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self installMovieNotificationObservers];
    [self.player prepareToPlay];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player shutdown];
    [self removeMovieNotificationObservers];
}

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url  andRoomList:(NSArray *)roomList andIndexPath:(NSIndexPath *)indexPath completion:(void (^)())completion {
    [viewController presentViewController:[[self alloc] initWithURL:url andTitle:title andRoomList:roomList andIndexPath:indexPath] animated:YES completion:completion];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (instancetype)initWithURL:(NSURL *)url andTitle:(NSString *)title andRoomList:(NSArray *)roomList andIndexPath:(NSIndexPath *)indexPath {
    self = [super init];
    if (self) {
        self.url = url;
        self.liveName = title;
        self.roomList = roomList;
        self.indexPath = indexPath;
    }
    return self;
}

//MARK:- IBAction
- (void)onClickPlayerControl {
    [self.playerControl showAndFade];
}

- (void)onClickOverlayPanel {
    [self.playerControl hide];
}

- (void)onClickPlay {
    [self.player play];
    [self.playerControl refreshMediaControl];
}

- (void)onClickPause {
    [self.player pause];
    [self.playerControl refreshMediaControl];
}

- (void)onClickVolumnUp {
    [self.playerControl volumeUp];
}

- (void)onClickVolumnDown{
    [self.playerControl volumeDown];
}

- (void)onClickLike {
    self.playerControl.likeButton.selected = !self.playerControl.likeButton.selected;
    id liveModel = self.roomList[self.indexPath.item];
    NSString *live_id = [[NSString alloc]init];
    if ([liveModel isKindOfClass:[OYZhanqiLiveListModel class]]) {
        OYZhanqiLiveListModel *zhanqiLiveModel = liveModel;
        live_id = zhanqiLiveModel.title;
    }else if ([liveModel isKindOfClass:[OYPandaLiveListModel class]]) {
        OYPandaLiveListModel *pandaLiveModel = liveModel;
        live_id = pandaLiveModel.userinfo[@"nickName"];
    }else if ([liveModel isKindOfClass:[OYQuanMinLiveListModel class]]){
        OYQuanMinLiveListModel *quanMinLiveModel = liveModel;
        live_id = quanMinLiveModel.title;
    }
    if (self.playerControl.likeButton.selected) {
        [[OYCollectionManager sharedManager]addCollection:liveModel];
    }else {
        [[OYCollectionManager sharedManager]cancleCollection:live_id];
    }
}

- (void)onClickNext {
    NSLog(@"点击了next")
}

- (void)onClickBack {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.allowRotation = 0;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//MARK:- observe loadState
- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            [SVProgressHUD showWithStatus:@"该视频流暂时无法播放，正在加紧抓取中..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self onClickBack];
                [SVProgressHUD dismiss];
            });
            break;
    }
}

//MARK:- Register observers for the various movie object notifications.
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
}

//MARK:- Remove the movie notification observers from the movie object.
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
}
@end
