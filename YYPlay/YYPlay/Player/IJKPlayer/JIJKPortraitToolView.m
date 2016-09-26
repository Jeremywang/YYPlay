//
//  JIJKPortraitToolView.m
//  YYPlay
//
//  Created by jeremy on 9/9/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "JIJKPortraitToolView.h"
#import "YYBufferingProgressView.h"
#import "YYValueTrackingSlider.h"

#define TopViewBgHeight    50
#define BottomViewBgHeight 40
#define TopBackgroundAlpha  0.7f
#define ButtomBackgroundAlpha 0.7f

@interface JIJKPortraitToolView()

@property (nonatomic, copy) JIJKPortraitToolViewCallBack backBtnCallBack;

@property (nonatomic, copy) JIJKPortraitToolViewCallBack fullScreenCallBack;

@property (nonatomic, strong) UIView *topBg;

@property (nonatomic, strong) UIView *buttomBg;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, strong) UIButton *bigPlayBtn;

@property (nonatomic, strong) UIButton *littlePlayBtn;

@property (nonatomic, strong) UIButton *bigPauseBtn;

@property (nonatomic, strong) UIButton *littlePauseBtn;

@property (nonatomic, strong) UIButton *repeatBtn;

@property (nonatomic, strong) UIButton *lockBtn;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, assign) BOOL      isShowPortraitTooView;

@property (nonatomic, assign) BOOL      trackingSliderIsDraging;

@property (nonatomic, strong) NSTimer *sliderRefreshTimer;

@end

@implementation JIJKPortraitToolView

+ (instancetype)portraitToolViewWithBackBtnDidTouchCallBack:(JIJKPortraitToolViewCallBack)backBtnCallBack fullScreenBtnDidTouchCallBack:(JIJKPortraitToolViewCallBack)fullScreenBtnCallBack
{
    JIJKPortraitToolView *view = [[JIJKPortraitToolView alloc] init];
    view.backgroundColor       = [UIColor clearColor];
    view.backBtnCallBack       = backBtnCallBack;
    view.fullScreenCallBack    = fullScreenBtnCallBack;
    [view initialize];
    return view;
}

- (void)initialize
{
    [self addSubview:self.topBg];
    [self.topBg addSubview:self.backBtn];
    [self.topBg addSubview:self.titleLabel];
    
    [self addSubview:self.buttomBg];
    [self.buttomBg addSubview:self.littlePlayBtn];
    [self.buttomBg addSubview:self.littlePauseBtn];
    [self.buttomBg addSubview:self.lockBtn];
    [self.buttomBg addSubview:self.fullScreenBtn];
    [self.buttomBg addSubview:self.currentTimeLabel];
    [self.buttomBg addSubview:self.totalDurationLabel];
    [self.buttomBg addSubview:self.progressView];
    [self.buttomBg addSubview:self.trackingSlider];
    
    [self addSubview:self.bigPauseBtn];
    [self addSubview:self.bigPlayBtn];
    [self addSubview:self.repeatBtn];

    
    [self setClipsToBounds:YES];
    [self setIsShowPortraitTooView:YES];
    
    
    [self makeSubViewsConstraints];
    [self addTouchAction];
    
    [self createGesture];
    [self autoFadeOutPortraitToolView];
    [self beginRefresh];
}

- (void)makeSubViewsConstraints
{
    [_topBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
        make.height.mas_equalTo(TopViewBgHeight);
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(_topBg.mas_bottom).offset(-5);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_backBtn.mas_trailing).offset(10);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(_backBtn.mas_centerY);
        make.trailing.mas_equalTo(_topBg.mas_trailing).offset(-10);
    }];
    
    [_buttomBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(BottomViewBgHeight);
        make.leading.bottom.trailing.mas_equalTo(self);
    }];
    
    [_littlePlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_buttomBg.mas_leading).offset(0);
        make.height.width.mas_equalTo(30);
        make.centerY.mas_equalTo(_buttomBg.mas_centerY);
    }];
    
    [_littlePauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_buttomBg.mas_leading).offset(0);
        make.height.width.mas_equalTo(30);
        make.centerY.mas_equalTo(_buttomBg.mas_centerY);
    }];
    
    [_fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_buttomBg.mas_trailing).offset(-5);
        make.height.with.mas_equalTo(30);
        make.centerY.mas_equalTo(_buttomBg.mas_centerY);
    }];
    
    [_currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_littlePlayBtn.mas_trailing).offset(2);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(30);
        make.centerY.mas_equalTo(_buttomBg.mas_centerY);
    }];
    
    [_totalDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_fullScreenBtn.mas_leading).offset(-5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(30);
        make.centerY.mas_equalTo(_buttomBg.mas_centerY);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_currentTimeLabel.mas_trailing).offset(5);
        make.trailing.mas_equalTo(_totalDurationLabel.mas_leading).offset(-5);
        make.centerY.mas_equalTo(_buttomBg.mas_centerY);
        make.height.mas_equalTo(2);
    }];
    
    [_trackingSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_currentTimeLabel.mas_trailing).offset(5);
        make.trailing.mas_equalTo(_totalDurationLabel.mas_leading).offset(-5);
        make.centerY.mas_equalTo(_buttomBg.mas_centerY);
        make.height.mas_equalTo(50);
    }];
}

- (void)addTouchAction
{
    [self.backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.littlePlayBtn addTarget:self action:@selector(playBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.littlePauseBtn addTarget:self action:@selector(pauseBtnAction) forControlEvents:UIControlEventTouchUpInside];
}


- (void)backBtnAction
{
    [self hiddenPortraitToolView];
    if (self.backBtnCallBack) {
        self.backBtnCallBack();
    }
}

- (void)fullScreenBtnAction
{
    if (self.fullScreenCallBack) {
        self.fullScreenCallBack();
    }
}

- (void)playBtnAction
{
    [self goToState:PLayerState_play];
}

- (void)pauseBtnAction
{
    [self goToState:PLayerState_pause];
}


- (UIView *)topBg
{
    if (!_topBg) {
        _topBg = [[UIView alloc] init];
        _topBg.backgroundColor = [UIColor blackColor];
        _topBg.alpha = TopBackgroundAlpha;
    }
    return _topBg;
}

- (UIView *)buttomBg
{
    if (!_buttomBg) {
        _buttomBg = [[UIView alloc] init];
        _buttomBg.backgroundColor = [UIColor blackColor];
        _buttomBg.alpha = ButtomBackgroundAlpha;
    }
    return _buttomBg;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:YYAvplayerImage(@"YYAvplayer_back_full") forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIButton *)fullScreenBtn
{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:YYAvplayerImage(@"YYAvplayer_fullscreen") forState:UIControlStateNormal];
    }
    return _fullScreenBtn;
}

- (UIButton *)bigPlayBtn
{
    if (!_bigPlayBtn) {
        _bigPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bigPlayBtn setImage:YYAvplayerImage(@"YYAvplayer_play_big") forState:UIControlStateNormal];
    }
    return _bigPlayBtn;
}

- (UIButton *)littlePlayBtn
{
    if (!_littlePlayBtn) {
        _littlePlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_littlePlayBtn setImage:YYAvplayerImage(@"YYAvplayer_play") forState:UIControlStateNormal];
    }
    return _littlePlayBtn;
}

- (UIButton *)bigPauseBtn
{
    if (!_bigPauseBtn) {
        _bigPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bigPauseBtn setImage:YYAvplayerImage(@"YYAvplayer_pasue_big") forState:UIControlStateNormal];
    }
    return _bigPauseBtn;
}

- (UIButton *)littlePauseBtn
{
    if (!_littlePauseBtn) {
        _littlePauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_littlePauseBtn setImage:YYAvplayerImage(@"YYAvplayer_pause") forState:UIControlStateNormal];
    }
    return _littlePauseBtn;
}

- (UIButton *)repeatBtn
{
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:YYAvplayerImage(@"YYAvplayer_repeat") forState:UIControlStateNormal];
    }
    return _repeatBtn;
}

- (UIButton *)lockBtn
{
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:YYAvplayerImage(@"YYAvplayer_lock-nor") forState:UIControlStateNormal];
    }
    return _lockBtn;
}

- (UILabel *)currentTimeLabel
{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [UILabel new];
        _currentTimeLabel.font = [UIFont systemFontOfSize:8.0f];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        [_currentTimeLabel setText:@"00:00"];
    }
    return _currentTimeLabel;
}

- (UILabel *)totalDurationLabel
{
    if (!_totalDurationLabel) {
        _totalDurationLabel = [UILabel new];
        _totalDurationLabel.font = [UIFont systemFontOfSize:8.0f];
        _totalDurationLabel.textColor = [UIColor whiteColor];
        [_totalDurationLabel setText:@"00:00"];
    }
    
    return _totalDurationLabel;
}

- (YYValueTrackingSlider *)trackingSlider
{
    if (!_trackingSlider) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        
        _trackingSlider = [YYValueTrackingSlider new];
        _trackingSlider.maximumValue = 1;
        [_trackingSlider setNumberFormatter:formatter];
        [_trackingSlider setMaxFractionDigitsDisplayed:0];
        _trackingSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
        _trackingSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
        _trackingSlider.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
        _trackingSlider.popUpViewWidthPaddingFactor = 1.7;
        [_trackingSlider setThumbImage:YYAvplayerImage(@"YYAvplayer_slider") forState:UIControlStateNormal];

        _trackingSlider.minimumTrackTintColor = [UIColor orangeColor];
        _trackingSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    }
    
    return _trackingSlider;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    
    return _progressView;
}

- (void)showPortraitToolView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.35f animations:^{
        [weakSelf.topBg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
        }];
        [weakSelf.buttomBg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        [weakSelf layoutIfNeeded];
        [weakSelf setIsShowPortraitTooView:YES];
    } completion:^(BOOL finished) {
        [weakSelf autoFadeOutPortraitToolView];
    }];
}

- (void)hiddenPortraitToolView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.35f animations:^{
        [weakSelf.topBg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(-TopViewBgHeight);
        }];
        [weakSelf.buttomBg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(BottomViewBgHeight);
        }];
        [weakSelf layoutIfNeeded];
    }];
    
    [self setIsShowPortraitTooView:NO];
}

- (void)autoFadeOutPortraitToolView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenPortraitToolView) object:nil];
    [self performSelector:@selector(hiddenPortraitToolView) withObject:nil afterDelay:4.0f];
}

- (void)createGesture
{
    //single tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateRecognized) {
        _isShowPortraitTooView ? ([self hiddenPortraitToolView]) : ([self showPortraitToolView]);
    }
}

- (void)showLoading
{
    [YYBufferingProgressView showInView:self] ;
}

- (void)dismissLoading
{
    [YYBufferingProgressView dismiss];
}

- (void)setLoadingProgress:(NSUInteger)progress
{
    [[YYBufferingProgressView shareInstance] setProgress:progress];
}

- (void)refreshMediaControl
{
    if (self.isShowPortraitTooView) {
        //duration
        NSTimeInterval duration = self.delegatePlayer.duration;
        NSInteger intDuration = duration + 0.5;
        
        NSInteger durMin = intDuration / 60;
        NSInteger durSec = intDuration % 60;
        if (intDuration > 0) {
            self.totalDurationLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
        } else {
            self.totalDurationLabel.text = @"--:--";
        }
        
        //postion
        NSTimeInterval postion;
        if (_trackingSliderIsDraging) {
            postion = self.trackingSlider.value;
        } else {
            NSInteger curMin = (NSInteger)self.delegatePlayer.currentPlaybackTime / 60;
            NSInteger curSec = (NSInteger)self.delegatePlayer.currentPlaybackTime % 60;
            self.currentTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", curMin, curSec];
        }
        
        self.trackingSlider.value = self.delegatePlayer.currentPlaybackTime / self.delegatePlayer.duration;
        
        [self.progressView setProgress:self.delegatePlayer.playableDuration / self.delegatePlayer.duration animated:NO];
    }
}

- (void)beginRefresh
{
    self.sliderRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(refreshMediaControl) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.sliderRefreshTimer forMode:NSRunLoopCommonModes];
}

- (void)goToState:(PLayerState)state
{
    switch (state) {
        case PlayerState_init:
            [self.buttomBg setHidden:YES];
            break;
        case PlayerState_loading:
            [self showLoading];
            [_littlePlayBtn setHidden:YES];
            [_littlePauseBtn setHidden:NO];
            break;
        case PLayerState_playing:
            [self dismissLoading];
            [self.buttomBg setHidden:NO];
            [_littlePlayBtn setHidden:YES];
            [_littlePauseBtn setHidden:NO];
            [self showPortraitToolView];
            break;
        case PLayerState_pause:
            [_littlePlayBtn setHidden:NO];
            [_littlePauseBtn setHidden:YES];
            [self.delegatePlayer pause];
            break;
        case PLayerState_play:
            [_littlePlayBtn setHidden:YES];
            [_littlePauseBtn setHidden:NO];
            [self.delegatePlayer play];
            break;
        case PLayerState_stop:
            break;
        default:
            break;
    }
}

@end
