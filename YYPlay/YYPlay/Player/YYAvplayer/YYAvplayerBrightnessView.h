//
//  YYAvplayerBrightnessView.h
//  YYPlay
//
//  Created by jeremy on 8/23/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYAvplayerBrightnessView : UIView

@property (nonatomic, assign) BOOL      isLockScreen;

@property (nonatomic, assign) BOOL      isAllowLandscape;

+ (instancetype)sharedBrightnessView;

@end
