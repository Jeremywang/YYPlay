//
//  UIViewController+YYExtension.m
//  YYPlay
//
//  Created by jeremy on 9/1/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "UIViewController+YYExtension.h"
#import "UIImageView+YYExtension.h"
#import <objc/message.h>

static const void *GifKey = &GifKey;

@implementation UIViewController (YYExtension)

- (UIImageView *)gifView
{
    return objc_getAssociatedObject(self, GifKey);
}

- (void)setGifView:(UIImageView *)gifView
{
    objc_setAssociatedObject(self, GifKey, gifView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showGifLoading:(NSArray *)images inView:(UIView *)view
{
    if (!images.count) {
        images = @[[UIImage imageNamed:@"hold1_60x72"], [UIImage imageNamed:@"hold2_60x72"], [UIImage imageNamed:@"hold3_60x72"]];
    }
    UIImageView *gifView = [[UIImageView alloc] init];
    if (!view) {
        view = self.view;
    }
    [view addSubview:gifView];
    [gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(70);
    }];
    
    self.gifView = gifView;
    [gifView playGifAnim:images];
}

- (void)hideGifLoading
{
    [self.gifView stopGifAnim];
    self.gifView = nil;
}

@end
