//
//  LivePlayerViewController.m
//  YYPlay
//
//  Created by jeremy on 8/31/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "LivePlayerViewController.h"
#import "UIViewController+YYExtension.h"

@interface LivePlayerViewController()

// 缓冲timer
@property (nonatomic, strong) NSTimer *bufferingTimer;

@end

@implementation LivePlayerViewController

+ (instancetype)initWithURL:(NSString *)urlStr
{
    LivePlayerViewController* controller = [[self alloc] init];
    [controller setLiveStringForLiveURL:urlStr];
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self CreateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self installPlayerNotificationObservers];
    
    [self.player prepareToPlay];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeMovieNotificationObservers];
    [self.player shutdown];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)CreateUI
{
    _placeHolderView = [[UIImageView alloc] init];
    _placeHolderView.frame = self.view.bounds;
    _placeHolderView.image = [UIImage imageNamed:@"defaultbackground"];
    [self.view addSubview:_placeHolderView];
    [self showGifLoading:nil inView:self.placeHolderView];
    // 强制布局
    [_placeHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.leading.top.trailing.bottom.mas_equalTo(self.view);
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_SILENT];
    [IJKFFMoviePlayerController setLogReport:YES];
#else
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
    [IJKFFMoviePlayerController setLogReport:NO];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
    
    // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
    // -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:_liveURL withOptions:options];
//    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    self.player.view.frame = self.view.bounds;

    self.player.scalingMode = IJKMPMovieScalingModeAspectFill;
    self.player.shouldAutoplay = NO;
    self.player.shouldShowHudView = NO;
        
    self.view.autoresizesSubviews = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view insertSubview:self.player.view atIndex:0];
    
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.mas_equalTo(self.view);
    }];
}


- (void)setLiveStringForLiveURL:(NSString *)urlStr
{
    NSString *liveStr = [NSString stringWithFormat:@"%@", urlStr];
    liveStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    _liveURL = [NSURL URLWithString:liveStr];
}


- (void)installPlayerNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

#pragma mark Remove Movie Notification Handlers
- (void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
}



- (void)loadStateDidChange:(NSNotification *)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK || loadState & IJKMPMovieLoadStatePlayable) != 0) { //缓冲结束
        YYPlayLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
        [self.player play];
        [self hideGifLoading];
        //[self endBuffer];
        if (_placeHolderView) {
            [_placeHolderView removeFromSuperview];
            _placeHolderView = nil;
        }
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) { //缓冲开始
        YYPlayLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        [self showGifLoading:nil inView:self.player.view];
        //[self beginbBuffering];
    } else {
        YYPlayLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)beginbBuffering
{
    self.bufferingTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(buffering) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.bufferingTimer forMode:NSRunLoopCommonModes];
}

- (void)buffering
{
    YYPlayLog(@"当前缓冲进度为 %zd",[self.player bufferingProgress]);
    [self showGifLoading:nil inView:self.view];
    [self beginbBuffering];
}

- (void)endBuffer
{
    [self.bufferingTimer invalidate];
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            YYPlayLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            YYPlayLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            YYPlayLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            YYPlayLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    YYPlayLog(@"mediaIsPreparedToPlayDidChange\n");
    
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            YYPlayLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            YYPlayLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            YYPlayLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            YYPlayLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            YYPlayLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            YYPlayLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

@end
