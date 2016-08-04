//
//  LeftSideMenuViewController.m
//  YYPlay
//
//  Created by jeremy on 8/1/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "LeftSideMenuViewController.h"
#import "DEMOFirstViewController.h"
#import "DEMOSecondViewController.h"
#import "YYNavigationController.h"
#import "SettingViewController.h"

typedef enum : NSUInteger {
    MenuItemHome = 0,
    MenuItemCalendar,
    MenuItemProfile,
    MenuItemSettings,
    MenuItemCount
} MenuItem;



@interface LeftSideMenuViewController () <UITableViewDelegate, UITableViewDataSource>
{
     NSArray *_menuItemTitles;
     NSArray *_menuItemIcons;

}
@end

@implementation LeftSideMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _menuItemTitles = @[@"Home", @"Calendar", @"Profile", @"Settings"];
    _menuItemIcons = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings"];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case MenuItemHome:
            [self.sideMenuViewController setContentViewController:[[YYNavigationController alloc] initWithRootViewController:[[DEMOFirstViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case MenuItemCalendar:
            [self.sideMenuViewController setContentViewController:[[YYNavigationController alloc] initWithRootViewController:[[DEMOSecondViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case MenuItemProfile:
            break;
        case MenuItemSettings:
            [self.sideMenuViewController setContentViewController:[[YYNavigationController alloc] initWithRootViewController:[[SettingViewController alloc] init]]
                                                         animated:YES];
            
            [self.sideMenuViewController hideMenuViewController];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [_menuItemTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }

    cell.textLabel.text = _menuItemTitles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_menuItemIcons[indexPath.row]];
    
    return cell;
}


@end
