//
//  ZSSNavigationView.h
//  ZeroSpaceSystem
//
//  Created by NEO on 16/8/5.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSUIView.h"
#import "ZSSUILabel.h"
#import "ZSSUIButton.h"
#import "ZSSUIColor.h"
#import "ZSSUIFont.h"
#import "ZSSNSString.h"
#import "ZSSUIViewController.h"

@interface ZSSNavigationView : ZSSUIView

/**
 *  父viewController
 */
@property (weak, nonatomic) ZSSUIViewController *parentViewController;

/**
 *  设置左按钮
 *
 *  @param button 左按钮
 */
- (void)setLeftButton:(ZSSUIButton *)button;

/**
 *  设置右按钮
 *
 *  @param button 右按钮
 */
- (void)setRightButton:(ZSSUIButton *)button;

/**
 *  设置标题
 *
 *  @param title 标题
 */
- (void)setTitle:(ZSSNSString *)title;

/**
 *  设置标题颜色
 *
 *  @param color 文字颜色
 */
- (void)setTitleColor:(ZSSUIColor *)color;

/**
 *  设置标题字体
 *
 *  @param font 文字字体
 */
- (void)setTitleFont:(ZSSUIFont *)font;

/**
 *  设置自定义视图
 *
 *  @param view 自定义视图
 */
- (void)showCoverView:(ZSSUIView *)view;

/**
 *  设置自定义导航视图
 *
 *  @param view         自定义视图
 *  @param animation    YES 有动画效果 | NO 没有动画效果
 */
- (void)showCoverView:(ZSSUIView *)view animation:(BOOL)animation;

/**
 *  设置自定义标题视图
 *
 *  @param view 自定义标题视图
 */
- (void)showCoverViewOnTitleView:(ZSSUIView *)view;

/**
 *  隐藏自定义导航视图
 *
 *  @param view 自定义视图
 */
- (void)hideCoverView:(ZSSUIView *)view;

@end
