//
//  ASValuePopUpView.h
//  YYPlay
//
//  Created by jeremy on 8/24/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ASValuePopUpViewDelegate <NSObject>

- (CGFloat)currentValueOffset;  //expects value in the range 0.0 - 1.0
- (void)colorDidUpdate:(UIColor *)opaqueColor;

@end

@interface ASValuePopUpView : UIView

@property (nonatomic, weak) id <ASValuePopUpViewDelegate> delegate;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat arrowLength;
@property (nonatomic) CGFloat widthPaddingFactor;
@property (nonatomic) CGFloat heightPaddingFactor;

- (UIColor *)color;
- (void)setColor:(UIColor *)color;
- (UIColor *)opaqueColor;

- (void)setText:(NSString *)text;
- (void)setImage:(UIImage *)image;

- (void)setAnimatedColors:(NSArray *)animatedColors withKeyTimes:(NSArray *)keyTimes;

- (void)setAnimationOffset:(CGFloat)animOffset returnColor:(void (^)(UIColor *opaqueReturnColor))block;

- (void)setFrame:(CGRect)frame arrowOffset:(CGFloat)arrowOffset;

- (void)animateBlock:(void (^)(CFTimeInterval duration)) block;

- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated completionBlock:(void (^)())block;

@end
