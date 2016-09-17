//
//  YYAvplayer.h
//  YYPlay
//
//  Created by jeremy on 8/23/16.
//  Copyright © 2016 MF. All rights reserved.
//

#ifndef YYAvplayer_h
#define YYAvplayer_h

#import "YYAvplayerView.h"
#import "YYAvplayerControlView.h"
#import "YYAvplayerBrightnessView.h"


#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define kYYAvplayerViewContentOffset                @"contentOffset"

#define YYAvplayerShared                           [YYAvplayerBrightnessView sharedBrightnessView]

#define DeviceScreenWidth                           [[UIScreen mainScreen] bounds].size.width
#define DeviceScreenHeight                          [[UIScreen mainScreen] bounds].size.height
#define DeviceScreenSize                            [[UIScreen mainScreen] bounds].size

#define iPHone6Plus ([UIScreen mainScreen].bounds.size.height == 736) ? YES : NO

#define iPHone6 ([UIScreen mainScreen].bounds.size.height == 667) ? YES : NO

#define iPHone5 ([UIScreen mainScreen].bounds.size.height == 568) ? YES : NO

#define iPHone4 ([UIScreen mainScreen].bounds.size.height == 480) ? YES : NO


// 颜色值RGB
#define RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//Image path
#define YYAvplayerImageName(file)                    [@"YYAvplayer.bundle" stringByAppendingPathComponent:file]

#define YYAvplayerFrameworkImageName(file)           [@"Frameworks/YYAvplayer.framework/YYAvplayer.bundle" stringByAppendingPathComponent:file]

#define YYAvplayerImage(file)                        [UIImage imageNamed:YYAvplayerImageName(file)] ? : [UIImage imageNamed:YYAvplayerFrameworkImageName(file)]

#if RELEASE
#define YYAvplayerLog(fmt, ...)
#else
#define YYAvplayerLog(fmt, ...) NSLog((@"[%s Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif


#endif /* YYAvplayer_h */
