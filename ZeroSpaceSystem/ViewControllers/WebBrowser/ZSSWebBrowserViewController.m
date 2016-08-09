//
//  ZSSWebBrowserViewController.m
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/21.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSWebBrowserViewController.h"

#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDTTYLogger.h>

#import <WebKit/WebKit.h>

#import "ZSSUITextField.h"
#import "ZSSWebView.h"
#import "ZSSUIProgressView.h"

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_INFO;

@interface ZSSWebBrowserViewController ()
<
UIScrollViewDelegate,
ZSSWebViewDelegate,
UITextFieldDelegate
>
{
    BOOL dragStart;
    CGFloat previousYOffset;
}

@property (nonatomic, strong) ZSSWebView                *webView;

@property (strong, nonatomic) ZSSUITextField            *addressTextField;
@property (strong, nonatomic) ZSSUIProgressView         *webViewProgressBar;

@end

@implementation ZSSWebBrowserViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    _addressTextField                           = [[ZSSUITextField alloc] initWithFrame:(CGRect){20, STATUSBAR_HEIGHT + 5, SCREEN_WIDTH - 40, NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT - 10}];
    _addressTextField.backgroundColor           = [UIColor lightTextColor];
    _addressTextField.borderStyle               = UITextBorderStyleNone;
    _addressTextField.textAlignment             = NSTextAlignmentCenter;
    _addressTextField.delegate                  = self;
    _addressTextField.returnKeyType             = UIReturnKeyGo;
    _addressTextField.keyboardType              = UIKeyboardTypeWebSearch;
    _addressTextField.font                      = [UIFont systemFontOfSize:12];
    _addressTextField.clearButtonMode           = UITextFieldViewModeWhileEditing;
    _addressTextField.rightViewMode             = UITextFieldViewModeUnlessEditing;
    _addressTextField.leftViewMode              = UITextFieldViewModeAlways;
    _addressTextField.autocapitalizationType    = UITextAutocapitalizationTypeNone;
    _addressTextField.autocorrectionType        = UITextAutocorrectionTypeNo;
    _addressTextField.adjustsFontSizeToFitWidth = YES;
    [self.navigationController.view addSubview:_addressTextField];
    
    _webView = [[ZSSWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    if ([_webView.webView isKindOfClass:[WKWebView class]])
    {
        WKWebView *webview = _webView.webView;
        
        webview.scrollView.delegate = self;
    }
    else
    {
        UIWebView *webview = _webView.webView;
        
        webview.scrollView.delegate = self;
    }
    [self.view addSubview:_webView];
    
    _webViewProgressBar = [[ZSSUIProgressView alloc] initWithFrame:(CGRect){
        0.f,
        NAVIGATIONBAR_HEIGHT - 2.f,
        SCREEN_WIDTH,
        2.f
    }];
    [self.view addSubview:_webViewProgressBar];
    
    _webViewProgressBar.alpha = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark --- private

- (NSString*)encodeString:(NSString*)unencodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)unencodedString,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8));
    
    return encodedString;
}

- (BOOL)validateURL:(NSString *)textString
{
    NSString    *regex      = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *redicate   = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [redicate evaluateWithObject:textString];
}

- (void)loadRequest
{
    if ([self validateURL:_addressTextField.text])
    {
        NSURL           *url        = [[NSURL alloc] initWithString:_addressTextField.text];
        NSURLRequest    *urlRequest = [NSURLRequest requestWithURL:url];
        
        [_webView loadRequest:urlRequest];
    }
    else
    {
        NSString        *urlString  = [[NSString alloc] initWithFormat:@"http://%@", _addressTextField.text];
        
        if ([self validateURL:urlString])
        {
            NSURL           *url        = [[NSURL alloc] initWithString:urlString];
            NSURLRequest    *urlRequest = [NSURLRequest requestWithURL:url];
            
            [_webView loadRequest:urlRequest];
        }
        else
        {
            urlString = [[NSString alloc] initWithFormat:@"http://www.baidu.com/s?wd=%@", _addressTextField.text];
            
            urlString = [self encodeString:urlString];
            
            NSURL           *url        = [[NSURL alloc] initWithString:urlString];
            NSURLRequest    *urlRequest = [NSURLRequest requestWithURL:url];
            
            [_webView loadRequest:urlRequest];
        }
    }
    
    [_addressTextField resignFirstResponder];
}

- (void)dealloc
{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    [_webView setDelegate:nil];
}

#pragma mark - WKUIDelegate

- (void)zsswebView:(ZSSWebView *)webview progress:(CGFloat)progress
{
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    if (_webViewProgressBar.alpha == 0.f && progress > 0)
    {
        _webViewProgressBar.progress = 0.f;
        
        [UIView animateWithDuration:0.2 animations:^{
            _webViewProgressBar.alpha = 1.f;
        }];
    }
    else if (_webViewProgressBar.alpha == 1.f && progress == 1.f)
    {
        [UIView animateWithDuration:0.2 animations:^{
            _webViewProgressBar.alpha = 0.f;
        } completion:^(BOOL finished) {
            _webViewProgressBar.progress = 0.f;
        }];
    }
    [_webViewProgressBar setProgress:progress animated:YES];
}

- (void)zsswebView:(ZSSWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)zsswebViewDidStartLoad:(ZSSWebView *)webview
{
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)zsswebView:(ZSSWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [_webView.webView evaluateJavaScript:@"document.getElementsByClassName('adpic')[0].style.display = 'none'" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        
    }];
}

- (void)zsswebView:(ZSSWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    textField.backgroundColor = [UIColor clearColor];
    
    [self loadRequest];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.backgroundColor = [UIColor lightTextColor];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.backgroundColor = [UIColor clearColor];
    return YES;
}

#pragma mark --- UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    dragStart = YES;
    
    previousYOffset = scrollView.contentOffset.y;
    
    NSLog(@"previousYOffset --- %lf", previousYOffset);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!dragStart)
    {
        return;
    }
    
    NSLog(@"scrollView.contentOffset.y --- %lf", scrollView.contentOffset.y);
    
    CGFloat delta = scrollView.contentOffset.y - previousYOffset;
    
    NSLog(@"delta --- %lf", delta);
    
    CGFloat threshold = 30.f;
    
    //    if (delta < threshold)
    //    {
    //        return;
    //    }
    //    if (delta > 200.f)
    //    {
    self.navigationController.navigationBar.frame = CGRectMake(0.f, 0.f, SCREEN_WIDTH, STATUSBAR_HEIGHT);
    //    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    dragStart = NO;
}

@end
