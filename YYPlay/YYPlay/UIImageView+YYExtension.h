//
//  UIImageView+YYExtension.h
//  YYPlay
//
//  Created by jeremy on 9/1/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (YYExtension)

//play gif
- (void)playGifAnim:(NSArray *)images;

//stop play gif
- (void)stopGifAnim;

@end
