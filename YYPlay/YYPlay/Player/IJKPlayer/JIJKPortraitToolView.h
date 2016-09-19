//
//  JIJKPortraitToolView.h
//  YYPlay
//
//  Created by jeremy on 9/9/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JIJKPortraitToolViewCallBack)(void);

@interface JIJKPortraitToolView : UIView

@property (nonatomic, weak) id<IJKMediaPlayback> delegatePlayer;

@property (nonatomic, strong) UILabel *titleLabel;

+ (instancetype)portraitToolViewWithBackBtnDidTouchCallBack:(JIJKPortraitToolViewCallBack)backBtnCallBack fullScreenBtnDidTouchCallBack:(JIJKPortraitToolViewCallBack)fullScreenBtnCallBack;

- (void)showLoading;
- (void)dismissLoading;
- (void)setLoadingProgress:(NSUInteger)progress;

@end
