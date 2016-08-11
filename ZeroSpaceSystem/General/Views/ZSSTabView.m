//
//  ZSSTabView.m
//  ZeroSpaceSystem
//
//  Created by NEO on 16/8/10.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSTabView.h"

#import "ZSSUIButton.h"

#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDTTYLogger.h>

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ZSSTabView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = NAVIGATIONBAR_COLOR;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)setButtonItems:(NSArray *)items {
    
    for (int i = 0; i < items.count; i++) {
        
        ZSSUIButton *button = items[i];
        button.frame = (CGRect){
            (self.frame.size.width / items.count) * i + (self.frame.size.width / items.count - button.frame.size.width) / 2,
            (self.frame.size.height - button.frame.size.height) / 2,
            button.frame.size.width,
            button.frame.size.height
        };
        [self addSubview:button];
    }
}

@end
