//
//  YYPlayerView.h
//  YYPlay
//
//  Created by jeremy on 8/29/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYAvplayerControlView.h"

//back button block
typedef void (^YYAvplayerBackCallBack)(void);
//download button call back block
typedef void (^YYAvplayerDownloadCallBack)(NSString *urlStr);

typedef NS_ENUM(NSInteger, YYAvplayerLayerGravity) {
    YYAvplayerLayerGravityResize,           // 非均匀模式。两个维度完全填充至整个视图区域
    YYAvplayerLayerGravityResizeAspect,     // 等比例填充，直到一个维度到达区域边界
    YYAvplayerLayerGravityResizeAspectFill  // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
};

@interface YYAvplayerView : UIView

/** 视频URL */
@property (nonatomic, strong          ) NSURL                    *videoURL;
/** 视频标题 */
@property (nonatomic, strong          ) NSString                 *title;
/** 视频URL的数组 */
@property (nonatomic, strong          ) NSArray                  *videoURLArray;
/** 返回按钮Block */
@property (nonatomic, copy            ) YYAvplayerBackCallBack     goBackBlock;
@property (nonatomic, copy            ) YYAvplayerDownloadCallBack downloadBlock;
/** 设置playerLayer的填充模式 */
@property (nonatomic, assign          ) YYAvplayerLayerGravity     playerLayerGravity;
/** 是否有下载功能(默认是关闭) */
@property (nonatomic, assign          ) BOOL                     hasDownload;
/** 切换分辨率传的字典(key:分辨率名称，value：分辨率url) */
@property (nonatomic, strong          ) NSDictionary             *resolutionDic;
/** 从xx秒开始播放视频跳转 */
@property (nonatomic, assign          ) NSInteger                seekTime;
/** 播放前占位图片的名称，不设置就显示默认占位图（需要在设置视频URL之前设置） */
@property (nonatomic, copy            ) NSString                 *placeholderImageName;
/** 是否被用户暂停 */
@property (nonatomic, assign, readonly) BOOL                     isPauseByUser;

/**
 *  自动播放，默认不自动播放
 */
- (void)autoPlayTheVideo;

/**
 *  取消延时隐藏controlView的方法,在ViewController的delloc方法中调用
 *  用于解决：刚打开视频播放器，就关闭该页面，maskView的延时隐藏还未执行。
 */
- (void)cancelAutoFadeOutControlBar;

/**
 *  单例，用于列表cell上多个视频
 *
 *  @return ZFPlayer
 */
+ (instancetype)sharedPlayerView;

/**
 *  player添加到cell上
 *
 *  @param cell 添加player的cellImageView
 */
- (void)addPlayerToCellImageView:(UIImageView *)imageView;

/**
 *  重置player
 */
- (void)resetPlayer;

/**
 *  在当前页面，设置新的Player的URL调用此方法
 */
- (void)resetToPlayNewURL;

/**
 *  播放
 */
- (void)play;

/**
 * 暂停
 */
- (void)pause;

/** 设置URL的setter方法 */
- (void)setVideoURL:(NSURL *)videoURL;

/**
 *  用于cell上播放player
 *
 *  @param videoURL  视频的URL
 *  @param tableView tableView
 *  @param indexPath indexPath
 *  @param ImageViewTag ImageViewTag
 */
- (void)setVideoURL:(NSURL *)videoURL
      withTableView:(UITableView *)tableView
        AtIndexPath:(NSIndexPath *)indexPath
   withImageViewTag:(NSInteger)tag;

@end
