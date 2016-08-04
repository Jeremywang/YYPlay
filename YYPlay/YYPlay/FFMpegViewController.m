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
    [_textView setTextColor:[UIColor jc_coolGreyColor]];
    [_textView setText:@"Wait for button action"];
    [_textView setBackgroundColor:[UIColor jc_whiteColor]];
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-MiniPlayerViewHeight);
        make.top.equalTo(_configBTN.mas_bottom).with.offset(10);
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    av_register_all();
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
        [self printFFmpegConfig];
        
    } else if (sender == _protocolBTN) {
        NSLog(@"----------------------protocol button pressed----------------------\n");
        [self printFFMpegProtocol];
    } else if (sender == _avformatBTN) {
        NSLog(@"----------------------avformat button pressed----------------------\n");
        [self printFFMpegAvformat];
    } else if (sender == _avfilterBTN) {
        NSLog(@"----------------------avfilter button pressed----------------------\n");
        [self printFFMpegAvfilter];
    } else if (sender == _avcodecBTN) {
        NSLog(@"----------------------avcodec button pressed----------------------\n");
        [self printFFMpegAvcodec];
    }
}

- (void)printFFmpegConfig
{
    
    NSString *configStr = [NSString stringWithFormat:@"FFMpeg config = %s", avformat_configuration()];
    
    [_textView setText:configStr];
}

- (void)printFFMpegProtocol
{
    NSMutableString *mutableStr = [NSMutableString new];
    char info[40000] = {0};
    struct URLProtocol *pup = NULL;
    //input
    struct URLProtocol **p_temp = &pup;
    NSString *returnProtocol = [NSString stringWithFormat:@"%10s", avio_enum_protocols((void **)p_temp, 0)];
    NSLog(@"print return input Protocol = %@", returnProtocol);
    while ((*p_temp) != NULL) {
         //sprintf(info, "%s[In ][%10s]\n", info, avio_enum_protocols((void **)p_temp, 0));
        [mutableStr appendFormat:@"[In ][%10s]\n", avio_enum_protocols((void **)p_temp, 0)];
    }
    
    //output
    
    avio_enum_protocols((void **)p_temp, 1);
    while ((*p_temp) != NULL) {
        [mutableStr appendFormat:@"[Out][%10s]\n", avio_enum_protocols((void **)p_temp, 1)];
    }
    
    [_textView setText:mutableStr];
}

- (void)printFFMpegAvformat
{
    AVInputFormat *if_temp = av_iformat_next(NULL);
    AVOutputFormat *of_temp = av_oformat_next(NULL);
    
    NSMutableString *avFormatStr = [NSMutableString new];
    //input
    while (if_temp != NULL) {
        [avFormatStr appendFormat:@"[In ]%10s\n", if_temp->name];
        if_temp = if_temp->next;
    }
    
    //out put
    while (of_temp) {
        [avFormatStr appendFormat:@"[Out]%10s\n", of_temp->name];
        of_temp = of_temp->next;
    }
    
    [_textView setText:avFormatStr];
}

- (void)printFFMpegAvfilter
{
    AVFilter *f_temp = (AVFilter *)avfilter_next(NULL);
    NSMutableString *avfilterStr = [NSMutableString new];
    while (f_temp != NULL) {
        [avfilterStr appendFormat:@"[%10s]\n", f_temp->name];
        f_temp = f_temp->next;
    }
    
    [_textView setText:avfilterStr];
}

- (void)printFFMpegAvcodec
{
    AVCodec *c_temp = av_codec_next(NULL);
    NSMutableString *avcodecStr = [NSMutableString new];
    
    while (c_temp != NULL) {
        if (c_temp->decode != NULL) {
            [avcodecStr appendFormat:@"[Dec]"];
        }
        if (c_temp->encode2 != NULL){
            [avcodecStr appendFormat:@"[Enc]"];
        }
        switch (c_temp->type) {
            case AVMEDIA_TYPE_VIDEO:
                [avcodecStr appendFormat:@"[Video]"];
                break;
            case AVMEDIA_TYPE_AUDIO:
                [avcodecStr appendFormat:@"[Audio]"];
                break;
            default:
                [avcodecStr appendFormat:@"[Other]"];
                break;
        }
        [avcodecStr appendFormat:@"%10s\n", c_temp->name];
        
        c_temp = c_temp->next;
    }
    
    [_textView setText:avcodecStr];
}
@end
