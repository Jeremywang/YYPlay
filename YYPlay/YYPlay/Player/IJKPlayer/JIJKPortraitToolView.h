//
//  JIJKPortraitToolView.h
//  YYPlay
//
//  Created by jeremy on 9/9/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYValueTrackingSlider.h"

typedef NS_ENUM(NSInteger, PLayerState){
    PlayerState_init,
    PlayerState_loading,   //pair with playing
    PLayerState_playing,   //pair with loading
    PLayerState_pause,     //pair with play
    PLayerState_play,      //pair with pause
    PLayerState_stop
};

typedef void(^JIJKPortraitToolViewCallBack)(void);

@interface JIJKPortraitToolView : UIView

@property (nonatomic, weak) id<IJKMediaPlayback> delegatePlayer;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *currentTimeLabel;

@property (nonatomic, strong) UILabel *totalDurationLabel;

@property (nonatomic, strong) YYValueTrackingSlider *trackingSlider;

+ (instancetype)portraitToolViewWithBackBtnDidTouchCallBack:(JIJKPortraitToolViewCallBack)backBtnCallBack fullScreenBtnDidTouchCallBack:(JIJKPortraitToolViewCallBack)fullScreenBtnCallBack;

- (void)showLoading;
- (void)dismissLoading;
- (void)setLoadingProgress:(NSUInteger)progress;

- (void)goToState:(PLayerState)state;

@end
