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
#import "ZSSTabView.h"
#import "ZSSUIImageView.h"
#import "ZSSUIImage.h"
#import "ZSSUIButton.h"

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

@property (strong, nonatomic) NSString                  *addressURLString;
@property (strong, nonatomic) NSString                  *addressTitleString;

@property (strong, nonatomic) ZSSWebView                *webView;

@property (strong, nonatomic) ZSSUITextField            *addressTextField;

@property (strong, nonatomic) ZSSUIView                 *addressRightView;
@property (strong, nonatomic) ZSSUIButton               *reloadButton;
@property (strong, nonatomic) ZSSUIView                 *addressLeftView;
@property (strong, nonatomic) ZSSUIButton               *leftButton;

@property (strong, nonatomic) ZSSUIProgressView         *webViewProgressBar;

@property (strong, nonatomic) ZSSTabView                *tabView;

@end

@implementation ZSSWebBrowserViewController

- (ZSSUIButton *)reloadButton {
    
    if (!_addressRightView) {
        
        _reloadButton  = [[ZSSUIButton alloc] init];
        UIImage *image1 = [UIImage imageNamed:@"ZSSNaviRefreshButton"];
        [_reloadButton setImage:image1 forState:UIControlStateNormal];
        [_reloadButton sizeToFit];
        [_reloadButton addTarget:self
                          action:@selector(reloadOnClicked:)
                forControlEvents:UIControlEventTouchUpInside];
        _addressRightView = [[ZSSUIView alloc] initWithFrame:(CGRect){
            0.f,
            0.f,
            _reloadButton.frame.size.width + 10,
            _reloadButton.frame.size.height
        }];
        [_addressRightView addSubview:_reloadButton];
        _addressTextField.rightView = _addressRightView;
    }
    
    return _reloadButton;
}

- (void)leftOnClicked:(id)sender {
    
}

- (void)reloadOnClicked:(id)sender {
    
    if ([_webView isLoading]) {
        
        [_webView stopLoading];
    }
    else {
        
        [_webView reload];
    }
}

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
    
    _addressTextField                           = [[ZSSUITextField alloc] initWithFrame:(CGRect){15, STATUSBAR_HEIGHT + 5, SCREEN_WIDTH - 30, NAVIGATIONBAR_HEIGHT - 10}];
    _addressTextField.backgroundColor           = NAVIGATIONBAR_SEARCH_COLOR;
    _addressTextField.borderStyle               = UITextBorderStyleNone;
    _addressTextField.textAlignment             = NSTextAlignmentCenter;
    _addressTextField.delegate                  = self;
    _addressTextField.returnKeyType             = UIReturnKeyGo;
    _addressTextField.keyboardType              = UIKeyboardTypeWebSearch;
    _addressTextField.font                      = [UIFont systemFontOfSize:18];
    _addressTextField.clearButtonMode           = UITextFieldViewModeWhileEditing;
    _addressTextField.rightViewMode             = UITextFieldViewModeUnlessEditing;
    _addressTextField.leftViewMode              = UITextFieldViewModeAlways;
    _addressTextField.autocapitalizationType    = UITextAutocapitalizationTypeNone;
    _addressTextField.autocorrectionType        = UITextAutocorrectionTypeNo;
    _addressTextField.layer.masksToBounds = YES;
    _addressTextField.layer.cornerRadius = 8.f;
    _addressTextField.adjustsFontSizeToFitWidth = YES;
    [self navigationViewAddCoverView:_addressTextField];
    
    _leftButton = [[ZSSUIButton alloc] init];
    UIImage *image2 = [UIImage imageNamed:@"0202-sphere"];
    [_leftButton setImage:image2 forState:UIControlStateNormal];
    _leftButton.frame = (CGRect){
        10.f,
        0.f,
        NAVIGATIONBAR_HEIGHT - 20,
        NAVIGATIONBAR_HEIGHT - 20
    };
    [_leftButton addTarget:self
                    action:@selector(leftOnClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    _addressLeftView = [[ZSSUIView alloc] initWithFrame:(CGRect){
        0.f,
        0.f,
        NAVIGATIONBAR_HEIGHT - 20 + 10,
        NAVIGATIONBAR_HEIGHT - 20
    }];
    [_addressLeftView addSubview:_leftButton];
    _addressTextField.leftView  = _addressLeftView;
    
    _webView = [[ZSSWebView alloc] initWithFrame:(CGRect){
        0,
        STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT,
        SCREEN_WIDTH,
        SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT
    }];
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
        NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT - 2.f,
        SCREEN_WIDTH,
        2.f
    }];
    [self.view addSubview:_webViewProgressBar];
    
    _webViewProgressBar.alpha = 0;
    
    _tabView = [[ZSSTabView alloc] initWithFrame:(CGRect){
        0.f,
        SCREEN_HEIGHT - TABBAR_HEIGHT,
        SCREEN_WIDTH,
        TABBAR_HEIGHT
    }];
    ZSSUIButton *backButton     = [[ZSSUIButton alloc] init];
    UIImage *image3 = [UIImage imageNamed:@"ZSSTabGoBackButton_N"];
    [backButton setImage:image3 forState:UIControlStateNormal];
    UIImage *image8 = [UIImage imageNamed:@"ZSSTabGoBackButton_H"];
    [backButton setImage:image8 forState:UIControlStateHighlighted];
    [backButton setImage:image8 forState:UIControlStateDisabled];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    ZSSUIButton *forwarkButton  = [[ZSSUIButton alloc] init];
    UIImage *image4 = [UIImage imageNamed:@"ZSSTabGoForwardButton_N"];
    [forwarkButton setImage:image4 forState:UIControlStateNormal];
    UIImage *image9 = [UIImage imageNamed:@"ZSSTabGoForwardButton_H"];
    [forwarkButton setImage:image9 forState:UIControlStateHighlighted];
    [forwarkButton setImage:image9 forState:UIControlStateDisabled];
    [forwarkButton sizeToFit];
    [forwarkButton addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    ZSSUIButton *menuButton     = [[ZSSUIButton alloc] init];
    UIImage *image5 = [UIImage imageNamed:@"ZSSTabMenuButton_N"];
    [menuButton setImage:image5 forState:UIControlStateNormal];
    UIImage *image10 = [UIImage imageNamed:@"ZSSTabMenuButton_H"];
    [menuButton setImage:image10 forState:UIControlStateHighlighted];
    [menuButton setImage:image10 forState:UIControlStateDisabled];
    [menuButton sizeToFit];
    ZSSUIButton *multiButton    = [[ZSSUIButton alloc] init];
    UIImage *image6 = [UIImage imageNamed:@"ZSSTabMultiButton_N"];
    [multiButton setImage:image6 forState:UIControlStateNormal];
    UIImage *image11 = [UIImage imageNamed:@"ZSSTabMultiButton_H"];
    [multiButton setImage:image11 forState:UIControlStateHighlighted];
    [multiButton setImage:image11 forState:UIControlStateDisabled];
    [multiButton sizeToFit];
    ZSSUIButton *homeButton     = [[ZSSUIButton alloc] init];
    UIImage *image7 = [UIImage imageNamed:@"ZSSTabHomeButton_N"];
    [homeButton setImage:image7 forState:UIControlStateNormal];
    UIImage *image12 = [UIImage imageNamed:@"ZSSTabHomeButton_H"];
    [homeButton setImage:image12 forState:UIControlStateHighlighted];
    [homeButton setImage:image12 forState:UIControlStateDisabled];
    [homeButton sizeToFit];
    
    [_tabView setButtonItems:@[backButton, forwarkButton, menuButton, multiButton, homeButton]];
    [self.view addSubview:_tabView];
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

#pragma mark --- action

- (void)goBack
{
    [_webView goBack];
}

- (void)goForward
{
    [_webView goForward];
}

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
        _addressURLString = _addressTextField.text;
        
        NSURL           *url        = [[NSURL alloc] initWithString:_addressTextField.text];
        NSURLRequest    *urlRequest = [NSURLRequest requestWithURL:url];
        
        [_webView loadRequest:urlRequest];
    }
    else
    {
        NSString        *urlString  = [[NSString alloc] initWithFormat:@"http://%@", _addressTextField.text];
        
        if ([self validateURL:urlString])
        {
            _addressURLString = urlString;
            
            NSURL           *url        = [[NSURL alloc] initWithString:urlString];
            NSURLRequest    *urlRequest = [NSURLRequest requestWithURL:url];
            
            [_webView loadRequest:urlRequest];
        }
        else
        {
            urlString = [[NSString alloc] initWithFormat:@"http://www.baidu.com/s?wd=%@", _addressTextField.text];
            
            urlString = [self encodeString:urlString];
            
            _addressURLString = urlString;
            
            NSURL           *url        = [[NSURL alloc] initWithString:urlString];
            NSURLRequest    *urlRequest = [NSURLRequest requestWithURL:url];
            
            [_webView loadRequest:urlRequest];
        }
    }
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
    
    UIImage *image = [UIImage imageNamed:@"ZSSNaviStopButton"];
    [self.reloadButton setImage:image forState:UIControlStateNormal];
}

- (void)zsswebViewDidStartLoad:(ZSSWebView *)webview
{
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)zsswebView:(ZSSWebView *)webview didFinishLoadingURL:(NSURL *)URL {
    
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [_webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSString *string = data;
        _addressTitleString = string;
        _addressTextField.text = string;
    }];
    
    [_webView evaluateJavaScript:@"document.getElementsByClassName('adpic')[0].style.display = 'none'" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        
    }];
    
    UIImage *image = [UIImage imageNamed:@"ZSSNaviRefreshButton"];
    [self.reloadButton setImage:image forState:UIControlStateNormal];
}

- (void)zsswebView:(ZSSWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error {
    
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    textField.backgroundColor = [UIColor clearColor];
    
    [_addressTextField resignFirstResponder];
    
    if (!(_addressURLString && [_addressURLString isEqualToString:textField.text])) {
        
        [self loadRequest];
    }
    else {
        
        if (_addressTitleString) {
            
            _addressTextField.text = _addressTitleString;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    textField.backgroundColor = NAVIGATIONBAR_SEARCH_COLOR;
    
    if (_addressURLString) {
        
        textField.text = _addressURLString;
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    textField.backgroundColor = [UIColor clearColor];
    
    return YES;
}

#pragma mark --- UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    dragStart = YES;
    
    previousYOffset = scrollView.contentOffset.y;
    
    DDLogInfo(@"previousYOffset --- %lf", previousYOffset);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!dragStart) {
        
        return;
    }
    
    DDLogInfo(@"scrollView.contentOffset.y --- %lf", scrollView.contentOffset.y);
    
    CGFloat delta = scrollView.contentOffset.y - previousYOffset;
    
    DDLogInfo(@"delta --- %lf", delta);
    
    if (delta > 20) {
        
        [self setNavigationViewFrame:(CGRect){
            0.f,
            0.f,
            SCREEN_WIDTH,
            STATUSBAR_HEIGHT
        }];
        
        [_webView setFrame:(CGRect){
            0.f,
            STATUSBAR_HEIGHT,
            SCREEN_WIDTH,
            SCREEN_HEIGHT - STATUSBAR_HEIGHT
        }];
        
        _webViewProgressBar.frame = (CGRect){
            0.f,
            STATUSBAR_HEIGHT - 2.f,
            SCREEN_WIDTH,
            2.f
        };
        
        _tabView.frame = (CGRect){
            0.f,
            SCREEN_HEIGHT,
            SCREEN_WIDTH,
            TABBAR_HEIGHT
        };
    }
    else if (delta < -20) {
        
        [self setNavigationViewFrame:(CGRect){
            0.f,
            0.f,
            SCREEN_WIDTH,
            STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT
        }];
        
        [_webView setFrame:(CGRect){
            0.f,
            STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT,
            SCREEN_WIDTH,
            SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT
        }];
        
        _webViewProgressBar.frame = (CGRect){
            0.f,
            NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT - 2.f,
            SCREEN_WIDTH,
            2.f
        };
        
        _tabView.frame = (CGRect){
            0.f,
            SCREEN_HEIGHT - TABBAR_HEIGHT,
            SCREEN_WIDTH,
            TABBAR_HEIGHT
        };
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    dragStart = NO;
}

@end
