//
//  YYBufferingProgressView.m
//  YYPlay
//
//  Created by jeremy on 19/09/2016.
//  Copyright © 2016 MF. All rights reserved.
//

#import "YYBufferingProgressView.h"

@interface YYBufferingProgressView()

@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIImageView *loadingImageView;

@end

@implementation YYBufferingProgressView

+ (instancetype)shareInstance
{
    static YYBufferingProgressView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YYBufferingProgressView alloc] init];
    });
    
    return _instance;
}

+ (void)showInView:(UIView *)view
{
    YYBufferingProgressView *progressView = [YYBufferingProgressView shareInstance];
    
    [view addSubview:progressView];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(view);
    }];
    
    [progressView updateUI];
    
    [progressView makeAnimation];
}

+ (void)dismiss
{
    [[YYBufferingProgressView shareInstance] removeFromSuperview];
}

- (void)updateUI
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(80);
    }];
    
    [self addSubview:self.loadingImageView];
    [self addSubview:self.progressLabel];
    
    [_loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self);
        make.height.mas_equalTo(60);
    }];
    
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(self);
        make.height.mas_equalTo(20);
    }];
}

- (void)makeAnimation
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anim.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    anim.duration = 1;
    anim.cumulative = YES;
    anim.repeatCount = MAXFLOAT;
    [_loadingImageView.layer addAnimation:anim forKey:nil];
}

- (void)setProgress:(NSInteger)progress
{
    if (progress <= 0){
        progress = 0;
    }
    if (progress >= 99) {
        progress = 99;
    }
    
    if (progress == 0) {
        self.progressLabel.text = @"正在缓冲";
    } else {
        self.progressLabel.text = [NSString stringWithFormat:@"%lu%%", progress];
    }
}

- (UILabel *)progressLabel
{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        [_progressLabel setTextAlignment:NSTextAlignmentCenter];
        [_progressLabel setTextColor:[UIColor whiteColor]];
        [_progressLabel setFont:[UIFont systemFontOfSize:8.0f]];
    }
    
    return _progressLabel;
}

- (UIImageView *)loadingImageView
{
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] initWithImage:YYAvplayerImage(@"white_loading")];
    }
    
    return _loadingImageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
@end
