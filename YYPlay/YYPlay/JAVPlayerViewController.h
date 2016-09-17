//
//  AVPlayerViewController.h
//  YYPlay
//
//  Created by jeremy on 8/19/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface JAVPlayerViewController : UIViewController

@property (nonatomic, strong) NSURL *playUrl;
@property (nonatomic, strong) UIImageView *placeholderImageView;


+ (JAVPlayerViewController *)initWithURL:(NSString *)url;

@end
