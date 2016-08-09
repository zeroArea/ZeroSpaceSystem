//
//  ZSSNavigationViewSearchController.m
//  ZeroSpaceSystem
//
//  Created by NEO on 16/8/5.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSNavigationViewSearchController.h"

#import "ZSSUIViewController.h"
#import "ZSSUISearchBar.h"
#import "ZSSUIImageView.h"
#import "ZSSUIImage.h"
#import "ZSSUIButton.h"
#import "ZSSUIView.h"
#import "ZSSUITableView.h"
#import "ZSSNSArray.h"

@interface ZSSNavigationViewSearchController ()
<
UISearchBarDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, readonly, weak)   ZSSUIViewController *parentViewController;
@property (nonatomic, readonly)         ZSSUIView           *navigationView;
@property (nonatomic, readonly)         ZSSUISearchBar      *searchBar;
@property (nonatomic, readonly)         ZSSUIImageView      *viewBlackCover;
@property (nonatomic, readonly)         ZSSUIButton         *buttonCancel;
@property (nonatomic, readonly)         ZSSUITableView      *tableView;

@property (nonatomic, readonly)         BOOL                fixation;
@property (nonatomic, readonly)         BOOL                coverTitleView;
@property (nonatomic, readonly)         BOOL                working;
@property (nonatomic, readonly)         ZSSNSArray          *arrayRecent;

@property (nonatomic, readonly)         ZSSUIImage          *imageBlurBackground;

@end

@implementation ZSSNavigationViewSearchController

- (id)initWithParentViewController:(ZSSUIViewController *)viewController {
    
    self = [super init];
    if (self) {
        
        _parentViewController = viewController;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    _navigationView = [[ZSSUIView alloc] initWithFrame:(CGRect){
        0,
        STATUSBAR_HEIGHT,
        SCREEN_WIDTH,
        NAVIGATIONBAR_HEIGHT
    }];
    
    _searchBar = [[ZSSUISearchBar alloc] initWithFrame:(CGRect){
        0.f,
        0.f,
        SCREEN_WIDTH,
        NAVIGATIONBAR_HEIGHT
    }];
    _searchBar.placeholder = @"请输入";
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.backgroundImage = [UIImage imageNamed:@"Transparent"];
    _searchBar.delegate = self;
    
    _buttonCancel = [[ZSSUIButton alloc] init];
    [_buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
    [_buttonCancel addTarget:self action:@selector(cancelOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _buttonCancel.hidden = YES;
}

- (void)cancelOnClicked:(id)sender {
    
}

@end
