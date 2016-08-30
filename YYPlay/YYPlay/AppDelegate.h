//
//  AppDelegate.h
//  YYPlay
//
//  Created by jeremy on 8/1/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu/RESideMenu.h>
#import "SideMenuContentViewController.h"
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainVC;
@property (strong, nonatomic) RESideMenu *menuController;
@property (strong, nonatomic) SideMenuContentViewController *sideMenuContentVC;

@property (nonatomic,assign)BOOL allowRotation;//这个属性标识屏幕是否允许旋转


@end

