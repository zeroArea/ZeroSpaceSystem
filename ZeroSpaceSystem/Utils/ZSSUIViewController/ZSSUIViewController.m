//
//  ZSSUIViewController.m
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/18.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSUIViewController.h"
#import "ZSSNavigationView.h"

@interface ZSSUIViewController ()

@property (strong, nonatomic) ZSSNavigationView *navigationView;

@end

@implementation ZSSUIViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (_navigationView && _navigationView.hidden) {
        
        [self.view bringSubviewToFront:_navigationView];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    _navigationView = [[ZSSNavigationView alloc] initWithFrame:(CGRect){
        0,
        0,
        SCREEN_WIDTH,
        NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT
    }];
    _navigationView.parentViewController = self;
    [self.view addSubview:_navigationView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)bringNavigationViewToFront {
    
    if (_navigationView) {
        
        [self.view bringSubviewToFront:_navigationView];
    }
}

- (void)hideNavigationView:(BOOL)hide {
    
    if (_navigationView) {
        
        _navigationView.hidden = hide;
    }
}

- (void)setNavigationViewTitle:(NSString *)title {
    
    if (_navigationView) {
        
        [_navigationView setTitle:(ZSSNSString *)title];
    }
}

- (void)setNavigationViewLeftButton:(UIButton *)button {
    
    if (_navigationView) {
        
        [_navigationView setLeftButton:(ZSSUIButton *)button];
    }
}

- (void)setNavitationViewRightButton:(UIButton *)button {
    
    if (_navigationView) {
        
        [_navigationView setRightButton:(ZSSUIButton *)button];
    }
}

- (void)navigationViewAddCoverView:(UIView *)view {
    
    if (_navigationView && view) {
        
        [_navigationView showCoverView:(ZSSUIView *)view];
    }
}

- (void)navigationViewAddCoverViewOnTitleView:(UIView *)view {
    
    if (_navigationView && view) {
        
        [_navigationView showCoverViewOnTitleView:(ZSSUIView *)view];
    }
}

- (void)navigationViewRemoveCoverView:(UIView *)view {
    
    if (_navigationView) {
        
        [_navigationView hideCoverView:(ZSSUIView *)view];
    }
}

- (void)navigationCanDragBack:(BOOL)canDragBack {
    
    if (self.navigationController) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = canDragBack;
    }
}

@end
