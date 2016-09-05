//
//  UIImageView+YYExtension.m
//  YYPlay
//
//  Created by jeremy on 9/1/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "UIImageView+YYExtension.h"

@implementation UIImageView (YYExtension)

- (void)playGifAnim:(NSArray *)images
{
    if (!images.count) {
        return;
    }
    
    self.animationImages = images;
    self.animationDuration = 0.5;
    self.animationRepeatCount = 0;
    [self startAnimating];
}

- (void)stopGifAnim
{
    if (self.isAnimating) {
        [self stopAnimating];
    }
    
    [self removeFromSuperview];
}

@end
