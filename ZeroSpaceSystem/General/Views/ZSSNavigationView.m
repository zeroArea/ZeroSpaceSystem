//
//  ZSSNavigationView.m
//  ZeroSpaceSystem
//
//  Created by NEO on 16/8/5.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSNavigationView.h"

#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDTTYLogger.h>


@interface ZSSNavigationView ()

@property (nonatomic, strong) ZSSUILabel  *labelTitle;
@property (nonatomic, strong) ZSSUIButton *buttonLeft;
@property (nonatomic, strong) ZSSUIButton *buttonRight;

@end

@implementation ZSSNavigationView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = NAVIGATIONBAR_COLOR;
    }
    return self;
}

- (ZSSUILabel *)labelTitle {
    
    if (!_labelTitle) {
        
        _labelTitle = [[ZSSUILabel alloc] initWithFrame:(CGRect){
            70.f,
            22.f,
            SCREEN_WIDTH - 140.f,
            40.f
        }];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labelTitle];
    }
    return _labelTitle;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    
    [super setBackgroundColor:backgroundColor];
    
    self.labelTitle.backgroundColor = backgroundColor;
}

- (void)setTitleColor:(ZSSUIColor *)color {
    
    self.labelTitle.textColor = color;
}

- (void)setTitleFont:(ZSSUIFont *)font {
    
    self.labelTitle.font = font;
}

- (void)setLeftButton:(ZSSUIButton *)button {
    
    SAFE_REMOVEVIEW(_buttonLeft);
    
    [button sizeToFit];
    
    button.frame = (CGRect) {
        10.f,
        20.f + (44.f - button.frame.size.height) / 2.f,
        button.frame.size.width,
        button.frame.size.height
    };
    [self addSubview:button];
}

- (void)setRightButton:(ZSSUIButton *)button {
    
    SAFE_REMOVEVIEW(_buttonRight);
    
    _buttonRight = button;
    
    [button sizeToFit];
    
    button.frame = (CGRect) {
        SCREEN_WIDTH - 10.f - button.frame.size.width,
        20.f + (44.f - button.frame.size.height) / 2.f,
        button.frame.size.width,
        button.frame.size.height
    };
    [self addSubview:button];
}

- (void)setTitle:(ZSSNSString *)title {
    
    self.labelTitle.text = title;
}

- (void)showCoverView:(ZSSUIView *)view {
    
    [self showCoverView:view animation:NO];
}

- (void)showCoverView:(ZSSUIView *)view animation:(BOOL)animation {
    
    if (view)
    {
        [self hideOriginalBarItem:YES];
        
        view.alpha = 0.4f;
        [self addSubview:view];
        
        if (animation) {
            
            [UIView animateWithDuration:0.2f animations:^() {
                
                view.alpha = 1.0f;
            } completion:^(BOOL f) {
                
            }];
        }
        else {
            
            view.alpha = 1.0f;
        }
    }
}

- (void)showCoverViewOnTitleView:(ZSSUIView *)view {
    
    if (view) {
        
        if (_labelTitle) {
            
            SAFE_REMOVEVIEW(_labelTitle);
        }
        
        [view removeFromSuperview];
        view.frame = (CGRect){
            70.f,
            22.f,
            SCREEN_WIDTH - 140.f,
            40.f
        };
        
        [self addSubview:view];
    }
}

- (void)hideCoverView:(ZSSUIView *)view {
    
    [self hideOriginalBarItem:NO];
    if (view && (view.superview == self)) {
        
        [view removeFromSuperview];
    }
}

- (void)hideOriginalBarItem:(BOOL)hide {
    
    if (_buttonLeft) {
        
        _buttonLeft.hidden = hide;
    }
    if (_buttonRight) {
        
        _buttonRight.hidden = hide;
    }
    if (_labelTitle) {
        
        _labelTitle.hidden = hide;
    }
}

@end
