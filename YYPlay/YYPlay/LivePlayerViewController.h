//
//  LivePlayerViewController.h
//  YYPlay
//
//  Created by jeremy on 8/31/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface LivePlayerViewController : UIViewController

@property (nonatomic, strong) NSURL *liveURL;
@property (nonatomic, strong) IJKFFMoviePlayerController *player;

/** 直播开始前的占位图片 */
@property(nonatomic, strong) UIImageView *placeHolderView;

+ (instancetype)initWithURL:(NSString *)urlStr;

@end
