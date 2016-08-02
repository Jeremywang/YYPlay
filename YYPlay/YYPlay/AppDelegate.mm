//
//  AppDelegate.m
//  YYPlay
//
//  Created by jeremy on 8/1/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftSideMenuViewController.h"
#include "avformat.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
    
    av_register_all();
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _sideMenuContentVC = [[SideMenuContentViewController alloc] init];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:_sideMenuContentVC];
    
    LeftSideMenuViewController *leftMenuViewController = [[LeftSideMenuViewController alloc] init];
    
    _menuController = [[RESideMenu alloc] initWithContentViewController:navCon leftMenuViewController:leftMenuViewController rightMenuViewController:nil];
                       
    _menuController.backgroundImage = [UIImage imageNamed:@"Stars"];
    _menuController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    _menuController.contentViewShadowColor = [UIColor blackColor];
    _menuController.contentViewShadowOffset = CGSizeMake(0, 0);
    _menuController.contentViewShadowOpacity = 0.6;
    _menuController.contentViewShadowRadius = 12;
    _menuController.contentViewShadowEnabled = YES;
    
    _mainVC = [[MainViewController alloc] init];
    _mainVC.childViewController = self.menuController;
    
    _menuController.delegate = _mainVC;
    
    self.window.rootViewController = _mainVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
