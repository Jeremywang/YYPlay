//
//  ViewController.h
//  YYPlay
//
//  Created by jeremy on 8/1/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu.h>

@interface MainViewController : UIViewController<RESideMenuDelegate>

@property (nonatomic, strong) UIViewController *childViewController;


@end

