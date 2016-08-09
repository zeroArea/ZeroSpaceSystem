//
//  ZSSAppManagerController.h
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/18.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSNSObject.h"

@interface ZSSAppManagerController : ZSSNSObject

+ (instancetype)shareInstance;

- (void)loadRootViewController;

- (void)openIndexViewController;
- (void)openMainViewController;
- (void)openShareViewController;
- (void)openWebBrowserViewController;
- (void)openFileManagerViewController;

@end
