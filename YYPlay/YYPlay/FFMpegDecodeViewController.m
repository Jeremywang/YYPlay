//
//  FFMpegDecodeViewController.m
//  YYPlay
//
//  Created by jeremy on 8/5/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "FFMpegDecodeViewController.h"

@interface FFMpegDecodeViewController (){
    
    UILabel *_inputFileLabel;
    UILabel *_outputFileLabel;
    UITextView *_textView;
    UIButton *_decodeBTN;
}

@end

@implementation FFMpegDecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"FFMpeg Decode Example";
    [self.view setBackgroundColor:[UIColor jc_silverColor]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _inputFileLabel = [[UILabel alloc] init];
    [_inputFileLabel setBackgroundColor:[UIColor whiteColor]];
    [_inputFileLabel setTextAlignment:NSTextAlignmentCenter];
    [_inputFileLabel setText:@"sintel.mov"];
    [self.view addSubview:_inputFileLabel];
    
    _outputFileLabel = [UILabel new];
    [_outputFileLabel setBackgroundColor:[UIColor whiteColor]];
    [_outputFileLabel setTextAlignment:NSTextAlignmentCenter];
    [_outputFileLabel setText:@"output.yuv"];
    [self.view addSubview:_outputFileLabel];
    
    _decodeBTN = [UIButton new];
    [_decodeBTN setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_decodeBTN setBackgroundColor:[UIColor whiteColor]];
    [_decodeBTN setTitleColor:[UIColor jc_tomatoColor] forState:UIControlStateNormal];
    [_decodeBTN setTitleColor:[UIColor jc_slateGreyTwoColor] forState:UIControlStateHighlighted];
    [_decodeBTN setTitle:@"Decode" forState:UIControlStateNormal];
    [_decodeBTN addTarget:self action:@selector(decodeAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_decodeBTN];
    
    [@[_inputFileLabel, _outputFileLabel, _decodeBTN] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:5 tailSpacing:5];
    [@[_inputFileLabel, _outputFileLabel, _decodeBTN] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(5);
        make.height.equalTo(@40);
    }];
    
    _textView  = [UITextView new];
    [_textView setBackgroundColor:[UIColor jc_whiteColor]];
    [_textView setTextColor:[UIColor jc_coolGreyColor]];
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-MiniPlayerViewHeight);
        make.top.equalTo(_inputFileLabel.mas_bottom).with.offset(5);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)decodeAction
{
    AVFormatContext *pFormatCtx;
    int              i, videoindex;
    AVCodecContext  *pCodecCtx;
    AVCodecParameters *pCodecPar;
    AVCodec         *pCodec;
    AVFrame         *pFrame, *pFrameYUV;
    uint8_t         *out_buffer;
    AVPacket        *packet;
    int             y_size;
    int             ret, got_picture;
    struct SwsContext *img_convert_ctx;
    FILE            *fp_yuv;
    int             frame_cnt;
    clock_t         time_start, time_finish;
    double          time_duration = 0.0;
    
    char            input_str_full[500] = {0};
    char            output_str_full[500] = {0};
    char            info[1000] = {0};
    
    NSString *input_str = [NSString stringWithFormat:@"resource.bundle/%@", _inputFileLabel.text];
    NSString *output_str = [NSString stringWithFormat:@"resource.bundle/%@", _outputFileLabel.text];
    
    NSString *input_nsstr = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:input_str];
    NSString *output_nsstr = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:output_str];
    
    sprintf(input_str_full, "%s", [input_nsstr UTF8String]);
    sprintf(output_str_full, "%s", [output_nsstr UTF8String]);
    
    NSLog(@"Input file path:%s\n", input_str_full);
    NSLog(@"Output file path:%s\n", output_str_full);
    
    av_register_all();
    avformat_network_init();
    
    pFormatCtx = avformat_alloc_context();
    
    if(avformat_open_input(&pFormatCtx,input_str_full,NULL,NULL) !=0 ){
        printf("Couldn't open input stream.\n");
        return ;
    }
    
    if (avformat_find_stream_info(pFormatCtx, NULL) < 0) {
        printf("Couldn't find stream information.\n");
        return;
    }
    
    av_dump_format(pFormatCtx, 0, input_str_full, 0);
    
    videoindex = -1;
    for (i = 0; i < pFormatCtx->nb_streams; i++) {
        if (pFormatCtx->streams[i]->codecpar->codec_type ==  AVMEDIA_TYPE_VIDEO) {
            videoindex = i;
            break;
        }
    }
    
    if (videoindex == -1) {
        printf("Couldn't find a video stream.\n");
        return;
    }
    
    pCodecCtx = pFormatCtx->streams[videoindex]->codec;
    pCodec = avcodec_find_decoder(pFormatCtx->streams[videoindex]->codecpar->codec_id);
    if(pCodec == NULL) {
        printf("Couldn't find Codec.\n");
        return;
    }
    
    
    if (avcodec_open2(pCodecCtx, pCodec, NULL) < 0) {
        printf("Couldn't open codec.\n");
        return;
    }
    
    pFrame = av_frame_alloc();
    pFrameYUV = av_frame_alloc();
    out_buffer = (unsigned char *)av_malloc(av_image_get_buffer_size(AV_PIX_FMT_YUV420P, pCodecCtx->width, pCodecCtx->height, 1));
    
    av_image_fill_arrays(pFrameYUV->data, pFrameYUV->linesize, out_buffer, AV_PIX_FMT_YUV420P, pCodecCtx->width,
                         pCodecCtx->height, 1);
    
    packet = (AVPacket *)av_malloc(sizeof(AVPacket));
    
    img_convert_ctx = sws_getContext(pCodecCtx->width, pCodecCtx->height, pCodecCtx->pix_fmt,
                                     pCodecCtx->width, pCodecCtx->height, AV_PIX_FMT_YUV420P, SWS_BICUBIC, NULL,
                                     NULL, NULL);
    
    sprintf(info, "[Input     ]%s\n", [input_str UTF8String]);
    sprintf(info, "%s[Output    ]%s\n", info, [output_str UTF8String]);
    sprintf(info, "%s[Format    ]%s\n", info, pFormatCtx->iformat->name);
    sprintf(info, "%s[Codec     ]%s\n", info, pCodecCtx->codec->name);
    sprintf(info, "%s[Resolution]%d*%d\n", info, pCodecCtx->width, pCodecCtx->height);
    
    fp_yuv = fopen(output_str_full, "wb+");
    if (fp_yuv == NULL) {
        printf("Cann't open output file.\n");
        return;
    }
    
    frame_cnt = 0;
    time_start = clock();
    
    while (av_read_frame(pFormatCtx, packet) >= 0) {
        if (packet->stream_index == videoindex) {
            ret = avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, packet);
            if (ret < 0) {
                printf("Decode Error.\n");
                return;
            }
            if (got_picture) {
                sws_scale(img_convert_ctx, (const uint8_t* const*)pFrame->data, pFrame->linesize, 0, pCodecCtx->height,
                          pFrameYUV->data, pFrameYUV->linesize);
                
                y_size = pCodecCtx->width*pCodecCtx->height;
                fwrite(pFrameYUV->data[0], 1, y_size, fp_yuv);     //Y
                fwrite(pFrameYUV->data[1], 1, y_size/4, fp_yuv);   //U
                fwrite(pFrameYUV->data[2], 1, y_size/4, fp_yuv);   //V
                
                //ouput info
                char pictype_str[10] = {0};
                switch (pFrame->pict_type) {
                    case AV_PICTURE_TYPE_I:
                        sprintf(pictype_str, "I");
                        break;
                    case AV_PICTURE_TYPE_P:
                        sprintf(pictype_str, "P");
                        break;
                    case AV_PICTURE_TYPE_B:
                        sprintf(pictype_str, "B");
                    default:
                        sprintf(pictype_str, "Other");
                        break;
                }
                printf("Frame Index: %5d. Type:%s\n", frame_cnt, pictype_str);
                frame_cnt++;
            }
        }
        av_free_packet(packet);
    }
    //flush decoder
    //Fix: flush frames remained in codec
    while (1) {
        ret = avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, packet);
        if (ret < 0) {
            break;
        }
        if (!got_picture) {
            break;
        }
        sws_scale(img_convert_ctx, (const uint8_t* const*)pFrame->data, pFrame->linesize, 0, pCodecCtx->height, pFrameYUV->data, pFrameYUV->linesize);
        int y_size = pCodecCtx->width*pCodecCtx->height;
        fwrite(pFrameYUV->data[0], 1, y_size, fp_yuv);   //Y
        fwrite(pFrameYUV->data[1], 1, y_size/4, fp_yuv); //U
        fwrite(pFrameYUV->data[2], 1, y_size/4, fp_yuv); //V
        
        //output info
        char pictype_str[10] = {0};
        switch (pFrame->pict_type) {
            case AV_PICTURE_TYPE_I:
                sprintf(pictype_str, "I");
                break;
            case AV_PICTURE_TYPE_P:
                sprintf(pictype_str, "P");
                break;
            case AV_PICTURE_TYPE_B:
                sprintf(pictype_str, "B");
                break;
            default:
                sprintf(pictype_str, "Other");
                break;
        }
        printf("Frame Index: %5d. Type:%s\n", frame_cnt, pictype_str);
        frame_cnt++;
    }
    time_finish = clock();
    time_duration = (double)(time_finish - time_start);
    
    sprintf(info, "%s[Time     ]%fus\n", info, time_duration);
    sprintf(info, "%s[Count    ]%d\n", info, frame_cnt);
    
    sws_freeContext(img_convert_ctx);
    fclose(fp_yuv);
    
    av_frame_free(&pFrameYUV);
    av_frame_free(&pFrame);
    avcodec_close(pCodecCtx);
    avformat_close_input(&pFormatCtx);
    
    NSString *info_ns = [NSString stringWithFormat:@"%s", info];
    _textView.text = info_ns;
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
