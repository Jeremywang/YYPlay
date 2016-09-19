//
//  JIJKPlayerView.m
//  YYPlay
//
//  Created by jeremy on 9/7/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "JIJKPlayerView.h"

@interface JIJKPlayerView()
@property (nonatomic, strong) UIImageView *placeholderImageView;

@property (nonatomic, strong) IJKFFMoviePlayerController *player;

@property (nonatomic, copy) JIJKPlayerViewCallBack backCallBack;

@property (nonatomic, copy) JIJKPlayerViewCallBack fullScreenCallBack;

@property (nonatomic, strong) JIJKPortraitToolView *portraitToolView;

@end

@implementation JIJKPlayerView

- (UIImageView *)placeholderImageView
{
    if (!_placeholderImageView) {
        _placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultbackground"]];
        [self addSubview:_placeholderImageView];
        [_placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self);
           // make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _placeholderImageView;
}

- (void)playerViewCallBack:(JIJKPlayerViewCallBack)callBack
{
    self.backCallBack = callBack;
}

- (void)playerViewFullScreenCallBack:(JIJKPlayerViewCallBack)callBack
{
    self.fullScreenCallBack = callBack;
}

- (void)play
{
    [self.player play];
}

- (void)pause
{
    [self.player pause];
}

- (void)prepareToPlay
{
    [self.player prepareToPlay];
}

- (void)stop
{
    [self.player stop];
}

- (void)shutdown
{
    [self.player shutdown];
}

- (BOOL)isPlaying
{
    return [self.player isPlaying];
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self initialize];
    return self;
}


- (void)initialize
{
    self.scaleMode = IJKMPMovieScalingModeAspectFill;
    
    // 设置默认的屏幕方向(竖屏)
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)dealloc
{
    [self removeNotificationObservers];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.player.view.frame = self.bounds;
    self.portraitToolView.frame = self.bounds;
    
    // 4s，屏幕宽高比不是16：9的问题,player加到控制器上时候
    if (iPHone4) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(DeviceScreenWidth *2 / 3);
        }];
    }
    
    [self layoutIfNeeded];
}

#pragma mark 屏幕转屏相关

/**
 *  强制屏幕转屏
 *
 *  @param orientation 屏幕方向
 */

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        // 设置横屏
        [self setOrientationLandscape];
        
    }else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        [self setOrientationPortrait];
        
    }
}

/**
 *  设置横屏的约束
 */
- (void)setOrientationLandscape
{
}

/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortrait
{
}


- (void)setVideoUrl:(NSURL *)videoUrl
{
    _videoUrl = videoUrl;
    
    [self placeholderImageView];
    
    //设置log打印信息
    [IJKFFMoviePlayerController setLogReport:YES];
    //set log level
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_SILENT];
    //check ffmpeg version
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    //IJKFFOptions configration information for IJKFFMoivePlayer
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    //config player
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.videoUrl withOptions:options];
    self.player.view.frame = self.bounds;
    self.player.scalingMode = self.scaleMode;
    self.player.shouldAutoplay = YES;
    [self.player setPauseInBackground:YES];
    [self addSubview:self.player.view];
    
    _portraitToolView = [JIJKPortraitToolView portraitToolViewWithBackBtnDidTouchCallBack:^{
        if (self.backCallBack) {
            self.backCallBack();
        }
    } fullScreenBtnDidTouchCallBack:^{
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }];

    [self addSubview:_portraitToolView];
    [_portraitToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.mas_equalTo(self);
    }];
    self.portraitToolView.delegatePlayer = self.player;
    [self bringSubviewToFront:_portraitToolView];
    
    [self addNotifications];
}

- (void)setVideoTitle:(NSString *)videoTitle
{
    _videoTitle = videoTitle;
    [self.portraitToolView.titleLabel setText:videoTitle];
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
//        [self.player play];
//        [self hideGifLoading];
//        //[self endBuffer];
//        if (_placeHolderView) {
//            [_placeHolderView removeFromSuperview];
//            _placeHolderView = nil;
//        }
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) { //缓冲开始
        YYPlayLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
//        [self showGifLoading:nil inView:self.player.view];
//        //[self beginbBuffering];
    } else {
        YYPlayLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
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
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
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
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

- (void)deviceOrientationDidChangeNotification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            // 手机倒立
            break;
        }
        case UIInterfaceOrientationPortrait:
        {
//            self.portraitToolView.hidden = NO;
//            self.landscapeToolView.hidden = YES;
            
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        {
//            self.portraitToolView.hidden = YES;
//            self.landscapeToolView.hidden = NO;
//            [YPApplication setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
//            self.portraitToolView.hidden = YES;
//            self.landscapeToolView.hidden = NO;
//            [YPApplication setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            break;
        }
        default:
            break;
    }
}



- (void)addNotifications
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChangeNotification)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}


#pragma mark remove movie notification handlers
/*Remove the movie notification observers from the movie object*/
- (void)removeNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

- (void)setScaleMode:(IJKMPMovieScalingMode)scaleMode
{
    if (!self.player) {
        return;
    }
    
    _scaleMode = scaleMode;
    self.player.scalingMode = scaleMode;
}

- (UIImage *)thumbnailImageAtCurrentTime
{
    if (!self.player) {
        return nil;
    }
    
    return [self.player thumbnailImageAtCurrentTime];
}

@end


