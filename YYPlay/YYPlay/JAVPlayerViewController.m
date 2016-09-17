//
//  AVPlayerViewController.m
//  YYPlay
//
//  Created by jeremy on 8/19/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "JAVPlayerViewController.h"
#import "JIJKPlayerView.h"
#import "AppDelegate.h"

@interface JAVPlayerViewController ()

@property (nonatomic, strong) JIJKPlayerView *playerView;

@end

@implementation JAVPlayerViewController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

+ (JAVPlayerViewController *)initWithURL:(NSString *)url
{
    JAVPlayerViewController *controller = [[self alloc] init];
    [controller setVideoURL:url];
    return controller;
}

- (void)setVideoURL:(NSString *)videoURL
{
    NSString *url = [NSString stringWithFormat:@"%@", videoURL];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    _playUrl = [NSURL URLWithString:url];
    
}

/**
 *  状态栏改变的动画，这个动画只影响状态栏的显示和隐藏
 *
 *  @return 动画效果
 */
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)createUI
{
    self.view.backgroundColor = [UIColor grayColor];
    _playerView = [[JIJKPlayerView alloc] init];
    [self.view addSubview:_playerView];
    _playerView.scaleMode = IJKMPMovieScalingModeFill;
    _playerView.videoUrl =  _playUrl;
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f / 16.0f).with.priority(750);
    }];
    
    __weak typeof(self) weakSelf = self;
    [self.playerView playerViewCallBack:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.playerView playerViewFullScreenCallBack:^{
        [weakSelf.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(DeviceScreenHeight);
        }];
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.view.autoresizesSubviews = YES;
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //改变AppDelegate的appdelegete.allowRotation属性
    AppDelegate *appdelegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegete.allowRotation = YES;
    
    [self installMovieNotificationObservers];
    
    [self.playerView prepareToPlay];
    
   // [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
   // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //改变AppDelegate的appdelegete.allowRotation属性
    AppDelegate *appdelegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegete.allowRotation = NO;
    
    [self.playerView shutdown];
    [self removeMovieNotificationObservers];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{

}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{

}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
    }
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
    }];
}


@end
