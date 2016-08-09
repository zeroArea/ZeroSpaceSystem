//
//  ZSSUIWebView.h
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/21.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSSUIWebView;

@protocol ZSSUIWebViewProgressDelegate <NSObject>

@optional
- (void)webView:(ZSSUIWebView*)webView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources;

@end

@interface ZSSUIWebView : UIWebView

@property (nonatomic, assign) IBOutlet id<ZSSUIWebViewProgressDelegate> progressDelegate;

@end
