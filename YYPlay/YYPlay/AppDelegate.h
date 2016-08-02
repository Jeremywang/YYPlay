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


@end

