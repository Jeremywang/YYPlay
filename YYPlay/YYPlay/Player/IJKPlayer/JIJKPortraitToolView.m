//
//  JIJKPortraitToolView.m
//  YYPlay
//
//  Created by jeremy on 9/9/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "JIJKPortraitToolView.h"
#import "YYBufferingProgressView.h"

#define TopViewBgHeight    50
#define BottomViewBgHeight 40

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

@property (nonatomic, assign) BOOL      isShowPortraitTooView;

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
    
    [self addSubview:self.bigPauseBtn];
    [self addSubview:self.bigPlayBtn];
    [self addSubview:self.repeatBtn];

    
    [self setClipsToBounds:YES];
    [self setIsShowPortraitTooView:YES];
    
    
    [self makeSubViewsConstraints];
    [self addTouchAction];
    
    [self createGesture];
    [self autoFadeOutPortraitToolView];
}

- (void)makeSubViewsConstraints
{
    [_topBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
        make.height.mas_equalTo(TopViewBgHeight);
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(_topBg.mas_bottom).offset(0);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_backBtn.mas_trailing).offset(10);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(_backBtn.mas_centerY);
        make.trailing.mas_equalTo(_topBg.mas_trailing).offset(-10);
    }];
    
    [_buttomBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(BottomViewBgHeight);
        make.leading.bottom.trailing.mas_equalTo(self);
    }];
    
    [_littlePlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_buttomBg.mas_leading).offset(12);
        make.height.width.mas_equalTo(30);
        make.centerY.mas_equalTo(_buttomBg.mas_centerY);
    }];
    
    [_fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_buttomBg.mas_trailing).offset(-5);
        make.height.with.mas_equalTo(30);
        make.centerY.mas_equalTo(_buttomBg.mas_centerY);
    }];
}

- (void)addTouchAction
{
    [self.backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenBtnAction) forControlEvents:UIControlEventTouchUpInside];
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


- (UIView *)topBg
{
    if (!_topBg) {
        _topBg = [[UIView alloc] init];
        _topBg.backgroundColor = [UIColor blackColor];
        _topBg.alpha = 0.4f;
    }
    return _topBg;
}

- (UIView *)buttomBg
{
    if (!_buttomBg) {
        _buttomBg = [[UIView alloc] init];
        _buttomBg.backgroundColor = [UIColor blackColor];
        _buttomBg.alpha = 0.4f;
    }
    return _buttomBg;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
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
@end
