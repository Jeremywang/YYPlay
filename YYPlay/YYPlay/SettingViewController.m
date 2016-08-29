//
//  SettingViewController.m
//  YYPlay
//
//  Created by jeremy on 8/3/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "SettingViewController.h"
#import "FFMpegViewController.h"
#import "FFMpegDecodeViewController.h"
#import "FFMpegPushStreamViewController.h"
#import "JAVPlayerViewController.h"
#import "MPPlayerViewController.h"
#import "SystemAVPlayerViewController.h"

@interface SettingViewController (){
    UITableView *_tableView;
    NSArray *_menuItem;
}
@end


@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Settings";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftSideMenuBTN"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    
    _menuItem = @[@"FFMpeg Detail", @"FFMpeg Decoder Example", @"FFMpeg Push Stream", @"System AV Player", @"System MP Player"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setAllowsSelection:YES];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self.view addSubview:_tableView];
    [self.view setBackgroundColor:[UIColor jc_silverColor]];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, MiniPlayerViewHeight, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menuItem count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SettingCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.textLabel setText:[_menuItem objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0f;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            FFMpegViewController *ffmpegVC = [[FFMpegViewController alloc] init];
            [self.navigationController pushViewController:ffmpegVC animated:YES];
            break;
        }
        case 1:
        {
            FFMpegDecodeViewController *decodeVC = [[FFMpegDecodeViewController alloc] init];
            [self.navigationController pushViewController:decodeVC animated:YES];
            break;
        }
        case 2:
        {
            FFMpegPushStreamViewController *pushStreamVC = [[FFMpegPushStreamViewController alloc] init];
            [self.navigationController pushViewController:pushStreamVC animated:YES];
            break;
        }
        case 3:
        {
            SystemAVPlayerViewController *avVC = [[SystemAVPlayerViewController alloc] init];
            avVC.parentVc = self;
            [self presentViewController:avVC animated:YES completion:nil];
            //[self.navigationController pushViewController:avVC animated:YES];
            break;
        }
        case 4:
        {
            MPPlayerViewController *mpVC = [[MPPlayerViewController alloc] init];
            [self presentViewController:mpVC animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}


// 哪些页面支持自动转屏
- (BOOL)shouldAutorotate{
    
    UINavigationController *nav = self.navigationController;
    
    // MoviePlayerViewController 、ZFTableViewController 控制器支持自动转屏
    if ([nav.topViewController isKindOfClass:[SystemAVPlayerViewController class]]) {
        // 调用ZFPlayerSingleton单例记录播放状态是否锁定屏幕方向
        return !YYAvplayerShared.isLockScreen;
    }
    return NO;
}

// viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    UINavigationController *nav = self.navigationController;
    if ([nav.topViewController isKindOfClass:[SystemAVPlayerViewController class]]) { // MoviePlayerViewController这个页面支持转屏方向
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else if ([nav.topViewController isKindOfClass:[MPPlayerViewController class]]) { // ZFTableViewController这个页面支持转屏方向
        if (YYAvplayerShared.isAllowLandscape) {
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }else {
            return UIInterfaceOrientationMaskPortrait;
        }
    }
    // 其他页面
    return UIInterfaceOrientationMaskPortrait;
}

@end
