//
//  ZSSUIViewController.h
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/18.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSSUIViewController : UIViewController

/**
 *  最上层显示导航条
 */
- (void)bringNavigationViewToFront;

/**
 *  隐藏导航条或显示导航条
 *
 *  @param hide YES 隐藏 | NO 显示
 */
- (void)hideNavigationView:(BOOL)hide;

/**
 *  设置导航条Frame
 *
 *  @param frame 导航条Frame
 */
- (void)setNavigationViewFrame:(CGRect)frame;

/**
 *  设置导航条标题
 *
 *  @param title 导航条标题
 */
- (void)setNavigationViewTitle:(NSString *)title;

/**
 *  设置导航条左按钮
 *
 *  @param button 左按钮
 */
- (void)setNavigationViewLeftButton:(UIButton *)button;

/**
 *  设置导航条右按钮
 *
 *  @param button 右按钮
 */
- (void)setNavigationViewRightButton:(UIButton *)button;

/**
 *  自定义导航条
 *
 *  @param view 自定义导航视图
 */
- (void)navigationViewAddCoverView:(UIView *)view;

/**
 *  自定义导航条标题视图
 *
 *  @param view 导航条标题视图
 */
- (void)navigationViewAddCoverViewOnTitleView:(UIView *)view;

/**
 *  移除自定义导航视图
 *
 *  @param view 自定义导航视图
 */
- (void)navigationViewRemoveCoverView:(UIView *)view;

/**
 *  设置右滑返回
 *
 *  @param canDragBack YES 可右滑返回 | NO 不可以
 */
- (void)navigationCanDragBack:(BOOL)canDragBack;

@end
