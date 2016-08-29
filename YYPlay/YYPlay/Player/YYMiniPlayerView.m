//
//  YYMiniPlayerView.m
//  YYPlay
//
//  Created by jeremy on 8/2/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "YYMiniPlayerView.h"
#include "avformat.h"

@implementation YYMiniPlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)viewFrame
{
    av_register_all();
    AVFormatContext*pFormatCtx =avformat_alloc_context();
    self = [super initWithFrame:viewFrame];
    if (!self)
        return self;
    
    return self;
}

@end
