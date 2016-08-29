//
//  YYPlayer.hpp
//  YYPlay
//
//  Created by jeremy on 8/2/16.
//  Copyright © 2016 MF. All rights reserved.
//

#ifndef YYPlayer_hpp
#define YYPlayer_hpp

#include <stdio.h>
extern "C" {
#include "avformat.h"
}

class YYPlayer {
    YYPlayer();
    
    virtual ~YYPlayer();
    
public:
    int time;
};

#endif /* YYPlayer_hpp */
