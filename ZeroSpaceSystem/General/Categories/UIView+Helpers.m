//
//  UIView+Helpers.m
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/18.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "UIView+Helpers.h"

@implementation UIView (Helpers)

- (void)removeAllSubViews
{
    for (UIView *subViews in self.subviews)
    {
        [subViews removeFromSuperview];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
