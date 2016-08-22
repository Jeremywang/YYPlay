//
//  SystemAVPlayerViewController.m
//  YYPlay
//
//  Created by jeremy on 8/22/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "SystemAVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SystemAVPlayerViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIButton *playOrPause;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UIButton *backBTN;

@end

@implementation SystemAVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
//    [self.player play];
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
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self removeNotifycation];
}

- (void)setupUI
{
    [self.view setBackgroundColor:[UIColor jc_silverColor]];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    _container = [UIView new];
    [self.view addSubview:_container];
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@VEDIOSCREEN_HEIGHT);
    }];
    
    
    _playOrPause = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playOrPause setImage:[UIImage imageNamed:@"playback_play"] forState:UIControlStateNormal];
    [_playOrPause addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_playOrPause];
    [_playOrPause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.view addSubview:_progress];
    [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playOrPause.mas_right).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.centerY.equalTo(_playOrPause.mas_centerY);
    }];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame=CGRectMake(0, 0, SCREEN_WIDTH, VEDIOSCREEN_HEIGHT);
    playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
 
    [self.container.layer addSublayer:playerLayer];
    
    _backBTN =[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBTN setImage:[UIImage imageNamed:@"back_arrow_icon"] forState:UIControlStateNormal];
    [_backBTN addTarget:self action:@selector(backBTNAction) forControlEvents:UIControlEventTouchDown];
    [_container addSubview:_backBTN];
    [_backBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_container.mas_left).with.offset(10);
        make.top.equalTo(_container.mas_top).with.offset(10);
        make.width.equalTo(@10);
        make.right.equalTo(@10);
    }];
}

- (AVPlayer *)player
{
    if (!_player) {
        NSString *urlStr = [NSString stringWithFormat:@"%@", TestVedioURL];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:urlStr];
        _player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:url]];
        [self addProgressObserver];
        [self addNotifyCation];
        [self addObserverToPlayItem:self.player.currentItem];
    }
    return _player;
}

- (void)addNotifyCation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)removeNotifycation
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playbackFinished
{
    NSLog(@"视频播放完成");
}

- (IBAction)playBtnClick:(UIButton *)sender
{
    if (self.player.rate == 0) { //Pause
        [sender setImage:[UIImage imageNamed:@"playback_pause"] forState:UIControlStateNormal];
        [self.player play];
    } else if (self.player.rate == 1){ //playing
        [sender setImage:[UIImage imageNamed:@"playback_play"] forState:UIControlStateNormal];
        [self.player pause];
    }
}

- (IBAction)backBTNAction
{
    [_parentVc dismissViewControllerAnimated:YES completion:nil];
}

- (void)addProgressObserver
{
    AVPlayerItem *playerItem = self.player.currentItem;
    UIProgressView *progress = self.progress;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
        NSLog(@"当前已经播放%.2fs.",current);
        
        if (current) {
            [progress setProgress:(current/total) animated:YES];
        }
    }];
}

- (void)addObserverToPlayItem:(AVPlayerItem *)playerItem
{
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem
{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

- (void)updateThumbailImage
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", TestVedioURL];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    CMTime time = CMTimeMake(5, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];

    CGImageRelease(imageRef);
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
