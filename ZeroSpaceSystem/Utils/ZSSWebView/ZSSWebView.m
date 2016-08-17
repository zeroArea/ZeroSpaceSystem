//
//  ZSSWebView.m
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSWebView.h"
#import <WebKit/WebKit.h>
#import "ZSSUIWebView.h"
#import "ZSSWKWebView.h"

#import <WKWebViewJavascriptBridge.h>

#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDTTYLogger.h>

static void *ZSSWebBrowserContext = &ZSSWebBrowserContext;

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_INFO;

@interface ZSSWebView ()
<
UIAlertViewDelegate,
WKNavigationDelegate,
ZSSUIWebViewProgressDelegate,
UIWebViewDelegate,
WKUIDelegate
>

@property (nonatomic, strong) WKWebViewJavascriptBridge *javascriptBridge;

@end


@implementation ZSSWebView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //            
        //            _webView = [[ZSSWKWebView alloc] init];
        //        }
        //        else {
        //            
        _webView = [[ZSSUIWebView alloc] init];
        //        }
        
        if([_webView isKindOfClass:[WKWebView class]]) {
            
            ZSSWKWebView *webView = _webView;
            
            [webView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [webView setNavigationDelegate:self];
            [webView setUIDelegate:self];
            [webView setMultipleTouchEnabled:YES];
            [webView setAutoresizesSubviews:YES];
            [webView.scrollView setAlwaysBounceVertical:YES];
            
            [webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:ZSSWebBrowserContext];
            
            [self addSubview:webView];
        }
        else {
            
            ZSSUIWebView *webView = _webView;
            
            [webView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [webView setDelegate:self];
            [webView setProgressDelegate:self];
            [webView setMultipleTouchEnabled:YES];
            [webView setAutoresizesSubviews:YES];
            [webView setScalesPageToFit:YES];
            [webView.scrollView setAlwaysBounceVertical:YES];
            [webView.scrollView setAlwaysBounceHorizontal:YES];
            
            [self addSubview:webView];
        }
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (BOOL)canGoForward {
    
    if([_webView isKindOfClass:[WKWebView class]]) {
        
        ZSSWKWebView *webView = _webView;
        
        return [webView canGoForward];
    }
    else {
        
        ZSSUIWebView *webView = _webView;
        
        return [webView canGoForward];
    }
}

- (BOOL)canGoBack {
    
    if([_webView isKindOfClass:[WKWebView class]]) {
        
        ZSSWKWebView *webView = _webView;
        
        return [webView canGoBack];
    }
    else {
        
        ZSSUIWebView *webView = _webView;
        
        return [webView canGoBack];
    }
}

- (void)goForward {
    
    if([_webView isKindOfClass:[WKWebView class]]) {
        
        ZSSWKWebView *webView = _webView;
        
        if ([webView canGoForward]) {
            [webView goForward];
        }
    }
    else {
        
        ZSSUIWebView *webView = _webView;
        
        if ([webView canGoForward]) {
            [webView goForward];
        }
    }
}

- (void)goBack {
    
    if([_webView isKindOfClass:[WKWebView class]]) {
        
        ZSSWKWebView *webView = _webView;
        
        if ([webView canGoBack]) {
            [webView goBack];
        }
    }
    else {
        
        ZSSUIWebView *webView = _webView;
        
        if ([webView canGoBack]) {
            [webView goBack];
        }
    }
}

- (BOOL)isLoading {
    
    if([_webView isKindOfClass:[WKWebView class]]) {
        
        ZSSWKWebView *webView = _webView;
        
        return [webView isLoading];
    }
    else {
        
        ZSSUIWebView *webView = _webView;
        
        return [webView isLoading];
    }
}

- (void)reload {
    
    if([_webView isKindOfClass:[WKWebView class]]) {
        
        ZSSWKWebView *webView = _webView;
        
        [webView reload];
    }
    else {
        
        ZSSUIWebView *webView = _webView;
        
        [webView reload];
    }
}

- (void)stopLoading {
    
    if([_webView isKindOfClass:[WKWebView class]]) {
        
        ZSSWKWebView *webView = _webView;
        
        [webView stopLoading];
    }
    else {
        
        ZSSUIWebView *webView = _webView;
        
        [webView stopLoading];
    }
}

- (void)evaluateJavaScript:(NSString *)javaScriptString
         completionHandler:(void (^ __nullable)(__nullable id, NSError * __nullable error))completionHandler {
    
    if ([_webView isKindOfClass:[WKWebView class]]) {
        
        ZSSWKWebView *webview = _webView;
        
        [webview evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    }
    else {
        
        ZSSUIWebView *webview = _webView;
        
        NSString *value = [webview stringByEvaluatingJavaScriptFromString:javaScriptString];
        
        if (completionHandler) {
            
            completionHandler(value, nil);
        }
    }
}

- (void)registerWebViewJavascriptBridgeWithHandler:(NSString *)handlerName
                                           handler:(void (^)(id, void (^)(id)))handler {
    
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    [_javascriptBridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (handler) {
            
            handler(data, responseCallback);
        }
    }];
}

- (void)callWebViewJavascriptBridgeWithHandler:(NSString *)handlerName
                                          data:(id)data {
    
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    [_javascriptBridge callHandler:handlerName data:data];
}

#pragma mark - Public Interface

- (void)loadRequest:(NSURLRequest *)request {
    
    if([_webView isKindOfClass:[WKWebView class]]) {
        
        WKWebView *webView = _webView;
        
        [webView loadRequest:request];
    }
    else {
        
        UIWebView *webView = _webView;
        
        [webView loadRequest:request];
    }
}

- (void)loadURL:(NSURL *)URL {
    
    [self loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)loadURLString:(NSString *)URLString {
    
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}

- (void)loadHTMLString:(NSString *)HTMLString {
    
    if([_webView isKindOfClass:[WKWebView class]]) {
        
        WKWebView *webView = _webView;
        
        [webView loadHTMLString:HTMLString baseURL:nil];
    }
    else {
        
        UIWebView *webView = _webView;
        
        [webView loadHTMLString:HTMLString baseURL:nil];
    }
}

#pragma mark - External App Support

- (BOOL)externalAppRequiredToOpenURL:(NSURL *)URL {
    
    //若需要限制只允许某些前缀的scheme通过请求，则取消下述注释，并在数组内添加自己需要放行的前缀
    NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https", @"file", @"ftp"]];
    return ![validSchemes containsObject:URL.scheme];
}

#pragma mark --- ZSSUIWebViewProgressDelegate

- (void)webView:(ZSSUIWebView*)webView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources {
    
    //Set progress value
    CGFloat estimatedProgress = ((float)resourceNumber) / ((float)totalResources);
    
    [self.delegate zsswebView:self progress:estimatedProgress];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self.delegate zsswebViewDidStartLoad:self];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if(![self externalAppRequiredToOpenURL:request.URL]) {
        
        //back delegate
        [self.delegate zsswebView:self shouldStartLoadWithURL:request.URL];
        
        return YES;
    }
    
    return NO;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //back delegate
    [self.delegate zsswebView:self didFinishLoadingURL:webView.request.URL];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    //back delegate
    [self.delegate zsswebView:self didFailToLoadURL:webView.request.URL error:error];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    //back delegate
    [self.delegate zsswebViewDidStartLoad:self];
    
    /*
     WKNavigationActionPolicy(WKNavigationActionPolicyAllow);
     */
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //back delegate
    [self.delegate zsswebView:self didFinishLoadingURL:webView.URL];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    //back delegate
    [self.delegate zsswebView:self didFailToLoadURL:webView.URL error:error];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    //back delegate
    [self.delegate zsswebView:self didFailToLoadURL:webView.URL error:error];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *URL = navigationAction.request.URL;
    if(![self externalAppRequiredToOpenURL:URL]) {
        
        if(!navigationAction.targetFrame) {
            
            [self loadURL:URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        [self callback_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
    }
    else if([[UIApplication sharedApplication] canOpenURL:URL]) {
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType {
    
    //back delegate
    [self.delegate zsswebView:self shouldStartLoadWithURL:request.URL];
    return YES;
}

#pragma mark - WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    if (!navigationAction.targetFrame.isMainFrame) {
        
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    WKWebView *webView = _webView;
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == _webView) {
        
        [self.delegate zsswebView:self progress:webView.estimatedProgress];
    }
    else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Dealloc

- (void)dealloc {
    
    if ([_webView isKindOfClass:[WKWebView class]]) {
        
        [_webView setNavigationDelegate:nil];
        [_webView setUIDelegate:nil];
        
        [_webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    else {
        
        [_webView setDelegate:nil];
        [_webView setProgressDelegate:nil];
    }
}

@end
