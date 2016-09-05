//
//  UIViewController+YYExtension.h
//  YYPlay
//
//  Created by jeremy on 9/1/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YYExtension)

@property(nonatomic, weak) UIImageView *gifView;

/**
 *  显示GIF加载动画
 *
 *  @param images gif图片数组, 不传的话默认是自带的
 *  @param view   显示在哪个view上, 如果不传默认就是self.view
 */
- (void)showGifLoading:(NSArray *)images inView:(UIView *)view;

/**
 *  取消GIF加载动画
 */
- (void)hideGifLoading;

@end
