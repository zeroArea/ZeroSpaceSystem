//
//  ZSSWebView.h
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSUIView.h"

@class ZSSWebView;

@protocol ZSSWebViewDelegate <NSObject>

@optional
- (void)zsswebView:(ZSSWebView *)webview progress:(CGFloat)progress;
- (void)zsswebView:(ZSSWebView *)webview didFinishLoadingURL:(NSURL *)URL;
- (void)zsswebView:(ZSSWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error;
- (void)zsswebView:(ZSSWebView *)webview shouldStartLoadWithURL:(NSURL *)URL;
- (void)zsswebViewDidStartLoad:(ZSSWebView *)webview;

@end

@interface ZSSWebView : ZSSUIView

@property (nonatomic, weak) id <ZSSWebViewDelegate> delegate;

@property (nonatomic, strong) id webView;

#pragma mark - Public Interface

- (void)loadRequest:(NSURLRequest *)request;
- (void)loadURL:(NSURL *)URL;
- (void)loadURLString:(NSString *)URLString;
- (void)loadHTMLString:(NSString *)HTMLString;

- (void)reload;
- (void)stopLoading;
- (BOOL)isLoading;

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ __nullable)(__nullable id, NSError * __nullable error))completionHandler;

- (void)registerWebViewJavascriptBridgeWithHandler:(NSString *)handlerName handler:(void (^)(id, void (^)(id)))handler;
- (void)callWebViewJavascriptBridgeWithHandler:(NSString *)handlerName data:(id)data;

@end
