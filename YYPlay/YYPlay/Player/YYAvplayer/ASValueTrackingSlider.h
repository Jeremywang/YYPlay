//
//  ASValueTrackingSlider.h
//  YYPlay
//
//  Created by jeremy on 8/24/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASValuePopUpView.h"

@protocol ASValueTrackingSliderDelegate;

@interface ASValueTrackingSlider : UISlider

// present the popUpView manually, without touch event.
- (void)showPopUpViewAnimated:(BOOL)animated;
// the popUpView will not hide again until you call 'hidePopUpViewAnimated:'
- (void)hidePopUpViewAnimated:(BOOL)animated;

// setting the value of 'popUpViewColor' overrides 'popUpViewAnimatedColors' and vice versa
// the return value of 'popUpViewColor' is the currently displayed value
// this will vary if 'popUpViewAnimatedColors' is set (see below)
@property (strong, nonatomic) UIColor *popUpViewColor;

// pass an array of 2 or more UIColors to animate the color change as the slider moves
@property (strong, nonatomic) NSArray *popUpViewAnimatedColors;

// the above @property distributes the colors evenly across the slider
// to specify the exact position of colors on the slider scale, pass an NSArray of NSNumbers
- (void)setPopUpViewAnimatedColors:(NSArray *)popUpViewAnimatedColors withPositions:(NSArray *)positions;

@property (strong, nonatomic, readonly) ASValuePopUpView *popUpView;
// cornerRadius of the popUpView, default is 4.0
@property (nonatomic) CGFloat popUpViewCornerRadius;

// arrow height of the popUpView, default is 13.0
@property (nonatomic) CGFloat popUpViewArrowLength;
// width padding factor of the popUpView, default is 1.15
@property (nonatomic) CGFloat popUpViewWidthPaddingFactor;
// height padding factor of the popUpView, default is 1.1
@property (nonatomic) CGFloat popUpViewHeightPaddingFactor;

// changes the left handside of the UISlider track to match current popUpView color
// the track color alpha is always set to 1.0, even if popUpView color is less than 1.0
@property (nonatomic) BOOL autoAdjustTrackColor; // (default is YES)

// delegate is only needed when used with a TableView or CollectionView - see below
@property (weak, nonatomic) id<ASValueTrackingSliderDelegate> delegate;
/** 设置时间 */
- (void)setText:(NSString *)text;
/** 设置预览图 */
- (void)setImage:(UIImage *)image;

@end

@protocol ASValueTrackingSliderDelegate <NSObject>

- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider;

@optional
- (void)sliderWillHidePopUpView:(ASValueTrackingSlider *)slider;
- (void)sliderDidHidePopUpView:(ASValueTrackingSlider *)slider;

@end
