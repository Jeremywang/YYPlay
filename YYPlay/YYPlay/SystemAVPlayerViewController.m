//
//  SystemAVPlayerViewController.m
//  YYPlay
//
//  Created by jeremy on 8/22/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "SystemAVPlayerViewController.h"
#import "FFMpegPushStreamViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YYAvplayer.h"
#import "AppDelegate.h"

@interface SystemAVPlayerViewController ()

@property (nonatomic, strong) YYAvplayerView *playerContainer;
@property (nonatomic, strong) NSURL          *linkURL;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) UIButton       *testBTN;


@end

@implementation SystemAVPlayerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    // 调用playerView的layoutSubviews方法
    if (self.playerContainer) {
        [self.playerContainer setNeedsLayout];
    }
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerContainer && self.isPlaying) {
        self.isPlaying = NO;
        [self.playerContainer play];
    }
    
    //改变AppDelegate的appdelegete.allowRotation属性
    AppDelegate *appdelegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegete.allowRotation = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerContainer && !self.playerContainer.isPauseByUser)
    {
        self.isPlaying = YES;
        [self.playerContainer pause];
    }
    
    AppDelegate *appdelegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegete.allowRotation = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    //if use Masonry,Please open this annotation
    
     self.playerContainer = [[YYAvplayerView alloc] init];
     [self.view addSubview:self.playerContainer];
     [self.playerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
     make.top.equalTo(self.view).offset(0);
     make.left.right.equalTo(self.view);
     // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
     make.height.equalTo(self.playerContainer.mas_width).multipliedBy(9.0f/16.0f).with.priority(750);
     }];
    
    
    // 设置播放前的占位图（需要在设置视频URL之前设置）
    self.playerContainer.placeholderImageName = @"loading_bgView1";
    // 设置视频的URL
    self.playerContainer.videoURL = self.linkURL;
    // 设置标题
    self.playerContainer.title = @"可以设置视频的标题";
    //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
    self.playerContainer.playerLayerGravity = YYAvplayerLayerGravityResizeAspect;
    
    // 打开下载功能（默认没有这个功能）
    self.playerContainer.hasDownload = YES;
    // 下载按钮的回调
    self.playerContainer.downloadBlock = ^(NSString *urlStr) {
        // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
//        NSString *name = [urlStr lastPathComponent];
//        [[ZFDownloadManager sharedDownloadManager] downFileUrl:urlStr filename:name fileimage:nil];
//        // 设置最多同时下载个数（默认是3）
//        [ZFDownloadManager sharedDownloadManager].maxCount = 1;
    };
    
    // 如果想从xx秒开始播放视频
    // self.playerView.seekTime = 15;
    
    // 是否自动播放，默认不自动播放
    [self.playerContainer autoPlayTheVideo];
    __weak typeof(self) weakSelf = self;
    self.playerContainer.goBackBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        //[weakSelf.parentVc dismissViewControllerAnimated:YES completion:nil];
    };
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        //if use Masonry,Please open this annotation
        
         [self.playerContainer mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(0);
         }];
        
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        //if use Masonry,Please open this annotation
        
         [self.playerContainer mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(0);
         }];
         
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    return YES;
}

- (void)dealloc
{
    NSLog(@"%@释放了",self.class);
    [self.playerContainer cancelAutoFadeOutControlBar];
}

- (void)setupUI
{
    [self.view setBackgroundColor:[UIColor jc_silverColor]];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    _testBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_testBTN setTitle:@"Next Page" forState:UIControlStateNormal];
    [_testBTN setBackgroundColor:[UIColor jc_tomatoColor]];
    [_testBTN setTitleColor:[UIColor jc_whiteColor] forState:UIControlStateNormal];
    [_testBTN addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_testBTN];
    [_testBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view).with.offset(-MiniPlayerViewHeight);
    }];
}

- (IBAction)nextPage:(id)sender
{
    FFMpegPushStreamViewController *pushStreamVC = [[FFMpegPushStreamViewController alloc] init];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:pushStreamVC animated:YES];
    
}

- (NSURL *)linkURL
{
    if (!_linkURL) {
        NSString *urlStr = [NSString stringWithFormat:@"%@", TestVedioURL];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        _linkURL = [NSURL URLWithString:urlStr];
    }
    return _linkURL;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
