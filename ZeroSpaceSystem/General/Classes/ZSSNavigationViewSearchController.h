//
//  ZSSNavigationViewSearchController.h
//  ZeroSpaceSystem
//
//  Created by NEO on 16/8/5.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSNSObject.h"

@class ZSSUIViewController;
@class ZSSNavigationViewSearchController;

@protocol ZSSNavigationViewSearchControllerDelegate <NSObject>

- (void)navigationViewSearchController:(ZSSNavigationViewSearchController *)controller searchKeyword:(NSString *)keyword;
- (void)navigationViewSearchControllerCancel:(ZSSNavigationViewSearchController *)controller;

@optional
- (void)navigationViewSearchControllerClearKeywordRecord:(ZSSNavigationViewSearchController *)controller;

@end

@interface ZSSNavigationViewSearchController : ZSSNSObject

@property (unsafe_unretained) id<ZSSNavigationViewSearchControllerDelegate> delegate;

- (id)initWithParentViewController:(ZSSUIViewController *)viewController;

- (void)resetPlaceHolder:(NSString *)message;

- (void)showTempSearchController;

- (void)showFixationSearchController;
- (void)showFixationSearchControllerOnTitleView;

- (void)startSearch;
- (void)removeSearchController;

- (void)setRecentKeyword:(NSArray *)arrayRecentKeyword;
- (void)setKeyword:(NSString *)keyword;

@end
