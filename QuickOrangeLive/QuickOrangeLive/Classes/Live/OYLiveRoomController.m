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
    [self.view addSubview:playerControl];
    
    [playerControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self installMovieNotificationObservers];
    [self.player prepareToPlay];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player shutdown];
//    [self removeMovieNotificationObservers];
}

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void (^)())completion {
    [viewController presentViewController:[[self alloc] initWithURL:url andTitle:title] animated:YES completion:completion];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (instancetype)initWithURL:(NSURL *)url andTitle:(NSString *)title{
    self = [super init];
    if (self) {
        self.url = url;
        self.liveName = title;
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

- (void)onClickNext {
    NSLog(@"点击了next")
}

- (void)onClickBack {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.allowRotation = 0;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
