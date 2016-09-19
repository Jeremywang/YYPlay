//
//  YYBufferingProgressView.h
//  YYPlay
//
//  Created by jeremy on 19/09/2016.
//  Copyright © 2016 MF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBufferingProgressView : UIView

+ (instancetype)shareInstance;

+ (void)showInView:(UIView *)view;

+ (void)dismiss;

@property (nonatomic, assign) NSInteger progress;

@end
