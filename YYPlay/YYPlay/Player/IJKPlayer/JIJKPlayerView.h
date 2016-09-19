//
//  JIJKPlayerView.h
//  YYPlay
//
//  Created by jeremy on 9/7/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JIJKPortraitToolView.h"

typedef void(^JIJKPlayerViewCallBack)(void);

@interface JIJKPlayerView : UIView

@property (nonatomic, strong) NSURL *videoUrl;

@property (nonatomic, strong) NSString *videoTitle;

@property (nonatomic, assign) IJKMPMovieScalingMode scaleMode;

@property (nonatomic, strong) UIImage *thumbnailImageAtCurrentTime;



- (void)play;
- (void)pause;
- (void)prepareToPlay;
- (void)stop;
- (BOOL)isPlaying;
- (void)shutdown;

- (void)playerViewCallBack:(JIJKPlayerViewCallBack)callBack;
- (void)playerViewFullScreenCallBack:(JIJKPlayerViewCallBack)callBack;

@end
