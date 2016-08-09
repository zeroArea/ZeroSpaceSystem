//
//  ZSSAppManagerController.m
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/18.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSAppManagerController.h"

#import "ZSSIndexViewController.h"
#import "ZSSMainViewController.h"
#import "ZSSWebBrowserViewController.h"
#import "ZSSShareViewController.h"
#import "ZSSFileManagerViewController.h"

#import <UIKit/UIKit.h>
#import "ZSSUINavigationController.h"

@interface ZSSAppManagerController ()

@property (strong, nonatomic) UIWindow *window;

@end

@implementation ZSSAppManagerController

+ (instancetype)shareInstance
{
    static ZSSAppManagerController *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZSSAppManagerController alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _window = [[UIApplication sharedApplication] keyWindow];
    }
    return self;
}

- (void)loadRootViewController
{
    [self openWebBrowserViewController];
}

- (void)openIndexViewController
{
    ZSSIndexViewController *viewController = [[ZSSIndexViewController alloc] init];
    _window.rootViewController = viewController;
}

- (void)openMainViewController
{
    ZSSMainViewController *mainViewController = [[ZSSMainViewController alloc] init];
    ZSSUINavigationController *navigationController = [[ZSSUINavigationController alloc] initWithRootViewController:mainViewController];
    _window.rootViewController = navigationController;
}

- (void)openShareViewController
{
    ZSSShareViewController *shareViewController = [[ZSSShareViewController alloc] init];
    ZSSUINavigationController *navigationController = [[ZSSUINavigationController alloc] initWithRootViewController:shareViewController];
    _window.rootViewController = navigationController;
}

- (void)openWebBrowserViewController
{
    ZSSWebBrowserViewController *webBrowserViewController = [[ZSSWebBrowserViewController alloc] init];
    ZSSUINavigationController *navigationController = [[ZSSUINavigationController alloc] initWithRootViewController:webBrowserViewController];
    _window.rootViewController = navigationController;
}

- (void)openFileManagerViewController
{
    ZSSFileManagerViewController *fileManagerViewController = [[ZSSFileManagerViewController alloc] init];
    ZSSUINavigationController *navigationController = [[ZSSUINavigationController alloc] initWithRootViewController:fileManagerViewController];
    _window.rootViewController = navigationController;
}

@end
