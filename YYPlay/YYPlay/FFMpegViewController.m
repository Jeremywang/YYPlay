//
//  FFMpegViewController.m
//  YYPlay
//
//  Created by jeremy on 8/4/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "FFMpegViewController.h"

@interface FFMpegViewController () {
    
    UIButton *_configBTN;
    UIButton *_protocolBTN;
    UIButton *_avformatBTN;
    UIButton *_avcodecBTN;
    UIButton *_avfilterBTN;
    UITextView *_textView;
}

@end

@implementation FFMpegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"FFMpeg detail";
    [self.view setBackgroundColor:[UIColor jc_silverColor]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _configBTN = [[UIButton alloc] init];
    [_configBTN setTitle:@"Config" forState:UIControlStateNormal];
    [_configBTN setBackgroundColor:[UIColor jc_slateGreyTwoColor]];
    [_configBTN setUserInteractionEnabled:YES];
    [_configBTN addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_configBTN];

    
    _protocolBTN = [[UIButton alloc] init];
    [_protocolBTN setTitle:@"protocol" forState:UIControlStateNormal];
    [_protocolBTN setBackgroundColor:[UIColor jc_slateGreyTwoColor]];
    [_protocolBTN addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_protocolBTN];
    
    
    _avformatBTN = [[UIButton alloc] init];
    [_avformatBTN setBackgroundColor:[UIColor jc_slateGreyTwoColor]];
    [_avformatBTN setTitle:@"avformat" forState:UIControlStateNormal];
    [_avformatBTN addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_avformatBTN];
    
    _avcodecBTN = [[UIButton alloc] init];
    [_avcodecBTN setBackgroundColor:[UIColor jc_slateGreyTwoColor]];
    [_avcodecBTN setTitle:@"avcodec" forState:UIControlStateNormal];
    [_avcodecBTN addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_avcodecBTN];
    
    _avfilterBTN = [[UIButton alloc] init];
    [_avfilterBTN setBackgroundColor:[UIColor jc_slateGreyTwoColor]];
    [_avfilterBTN setTitle:@"avfilter" forState:UIControlStateNormal];
    [_avfilterBTN addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_avfilterBTN];
    
    [@[_configBTN, _protocolBTN, _avformatBTN, _avcodecBTN, _avfilterBTN] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:70 leadSpacing:5 tailSpacing:5];
    [@[_configBTN, _protocolBTN, _avformatBTN, _avcodecBTN, _avfilterBTN] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.height.equalTo(@40);
    }];
    
    _textView = [[UITextView alloc] init];
    [_textView setTextColor:[UIColor jc_tomatoColor]];
    [_textView setText:@"Wait for button action"];
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-MiniPlayerViewHeight);
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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


- (IBAction)buttonAction:(id)sender
{
    if (sender == _configBTN) {
        NSLog(@"----------------------config button pressed----------------------\n");
        
    } else if (sender == _protocolBTN) {
        NSLog(@"----------------------protocol button pressed----------------------\n");
    } else if (sender == _avformatBTN) {
        NSLog(@"----------------------avformat button pressed----------------------\n");
    
    } else if (sender == _avfilterBTN) {
        NSLog(@"----------------------avfilter button pressed----------------------\n");
    } else if (sender == _avcodecBTN) {
        NSLog(@"----------------------avcodec button pressed----------------------\n");
    }
}
@end
