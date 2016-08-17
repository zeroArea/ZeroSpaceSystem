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
#import "ZSSUIWebView.h"
#import "ZSSUIProgressView.h"
#import "ZSSTabView.h"
#import "ZSSUIImageView.h"
#import "ZSSUIImage.h"
#import "ZSSUIButton.h"

#import "ZSSCarouselView.h"
#import "ZSSCommonHelpers.h"

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_INFO;

@interface ZSSWebBrowserViewController ()
<
UIScrollViewDelegate,
ZSSUIWebViewProgressDelegate,
UIWebViewDelegate,
UITextFieldDelegate,
iCarouselDataSource,
iCarouselDelegate
>

@property (assign, nonatomic) NSInteger                 countCarousel;

@property (assign, nonatomic) BOOL                      dragStart;
@property (assign, nonatomic) CGFloat                   previousYOffset;

@property (strong, nonatomic) NSString                  *addressURLString;
@property (strong, nonatomic) NSString                  *addressTitleString;

@property (strong, nonatomic) ZSSUIWebView                *currentWebView;

@property (strong, nonatomic) ZSSUITextField            *addressTextField;

@property (strong, nonatomic) ZSSUIView                 *addressRightView;
@property (strong, nonatomic) ZSSUIButton               *reloadButton;
@property (strong, nonatomic) ZSSUIView                 *addressLeftView;
@property (strong, nonatomic) ZSSUIButton               *leftButton;

@property (strong, nonatomic) ZSSUIProgressView         *webViewProgressBar;

@property (strong, nonatomic) ZSSTabView                *tabView;

@property (strong, nonatomic) ZSSCarouselView           *carouselView;

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

#pragma mark --- Action

- (void)leftOnClicked:(id)sender {
    
}

- (void)goBack
{
    [_currentWebView goBack];
}

- (void)goForward
{
    [_currentWebView goForward];
}

- (void)menuOnClicked:(id)sender
{
    
}

- (void)goHome
{
    
}

- (void)reloadOnClicked:(id)sender {
    
    if ([_currentWebView isLoading]) {
        
        [_currentWebView stopLoading];
    }
    else {
        
        [_currentWebView reload];
    }
}

- (void)multiOnClicked:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        [self showControl:NO animate:NO];
        
        [_currentWebView setFrame:(CGRect){
            SCREEN_WIDTH / 6.f,
            (SCREEN_HEIGHT - STATUSBAR_HEIGHT) / 6.f + STATUSBAR_HEIGHT,
            SCREEN_WIDTH * 2.f / 3.f,
            (SCREEN_HEIGHT - STATUSBAR_HEIGHT) * 2.f / 3.f
        }];
    } completion:^(BOOL finished) {
        [_currentWebView removeFromSuperview];
        
        _currentWebView.userInteractionEnabled = NO;
        
        _currentWebView.scrollView.scrollEnabled = NO;
        
        [_currentWebView setFrame:(CGRect){
            0,
            0,
            SCREEN_WIDTH * 2.f / 3.f,
            (SCREEN_HEIGHT - STATUSBAR_HEIGHT) * 2.f / 3.f
        }];
        
        [_carouselView.currentItemView addSubview:_currentWebView];
        
        _carouselView.userInteractionEnabled = YES;
    }];
}

- (void)noneOnClicked:(id)sender {
    
}

- (void)addTabOnClicked:(id)sender {
    _countCarousel++;
    
    [_carouselView insertItemAtIndex:_countCarousel - 1 animated:YES];
    
    [_carouselView scrollToItemAtIndex:_countCarousel - 1 animated:YES];
}

- (void)backTabOnClicked:(id)sender {
    
}

#pragma mark --- iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _countCarousel;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:(CGRect){
            0.f,
            0.f,
            SCREEN_WIDTH * 2.f / 3.f,
            (SCREEN_HEIGHT - STATUSBAR_HEIGHT) * 2.f / 3.f
        }];
    }
    
    if (index != 0) {
        ZSSUIWebView *webView = [[ZSSUIWebView alloc] initWithFrame:(CGRect){
            0.f,
            0.f,
            SCREEN_WIDTH * 2.f / 3.f,
            (SCREEN_HEIGHT - STATUSBAR_HEIGHT) * 2.f / 3.f
        }];
        webView.delegate = self;
        webView.scrollView.delegate = self;
        webView.progressDelegate = self;
        [webView setMultipleTouchEnabled:YES];
        [webView setAutoresizesSubviews:YES];
        [webView setScalesPageToFit:YES];
        [webView.scrollView setAlwaysBounceVertical:YES];
        [webView.scrollView setAlwaysBounceHorizontal:YES];
        [view addSubview:webView];
        
        webView.userInteractionEnabled = NO;
        webView.scrollView.scrollEnabled = NO;
    }
    
    return view;
}

#pragma mark --- iCarouselDelegate

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (carousel.currentItemIndex == index)
    {
        carousel.userInteractionEnabled = NO;
        
        ZSSUIWebView *view = (ZSSUIWebView *)[carousel.currentItemView subviews][0];
        
        view.userInteractionEnabled = YES;
        
        view.scrollView.scrollEnabled = YES;
        
        CGRect frame = [view convertRect:view.frame toView:self.view];
        
        view.frame = frame;
        
        [view removeFromSuperview];
        
        [self.contentView addSubview:view];
        
        _currentWebView = view;
        
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = (CGRect){
                0,
                NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT,
                SCREEN_WIDTH,
                SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT
            };
            [self showControl:YES animate:NO];
        }];
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
    UIImage *image2 = [UIImage imageNamed:@"ZSSNaviFavoritesButton_N"];
    [_leftButton setImage:image2 forState:UIControlStateNormal];
    [_leftButton sizeToFit];
    _leftButton.frame = (CGRect){
        10,
        0,
        _leftButton.frame.size.width,
        _leftButton.frame.size.height
    };
    [_leftButton addTarget:self
                    action:@selector(leftOnClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    _addressLeftView = [[ZSSUIView alloc] initWithFrame:(CGRect){
        0.f,
        0.f,
        _leftButton.frame.size.width + 10,
        _leftButton.frame.size.height
    }];
    [_addressLeftView addSubview:_leftButton];
    _addressTextField.leftView  = _addressLeftView;
    
    _countCarousel = 1;
    
    _carouselView = [[ZSSCarouselView alloc] initWithFrame:(CGRect){
        0,
        STATUSBAR_HEIGHT,
        SCREEN_WIDTH,
        SCREEN_HEIGHT - STATUSBAR_HEIGHT
    }];
    _carouselView.backgroundColor = [UIColor purpleColor];
    _carouselView.type = iCarouselTypeCoverFlow2;
    _carouselView.delegate = self;
    _carouselView.dataSource = self;
    _carouselView.userInteractionEnabled = NO;
    [self.contentView addSubview:_carouselView];
    
    _currentWebView = [[ZSSUIWebView alloc] initWithFrame:(CGRect){
        0,
        STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT,
        SCREEN_WIDTH,
        SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT
    }];
    _currentWebView.delegate = self;
    _currentWebView.scrollView.delegate = self;
    _currentWebView.progressDelegate = self;
    [_currentWebView setMultipleTouchEnabled:YES];
    [_currentWebView setAutoresizesSubviews:YES];
    [_currentWebView setScalesPageToFit:YES];
    [_currentWebView.scrollView setAlwaysBounceVertical:YES];
    [_currentWebView.scrollView setAlwaysBounceHorizontal:YES];
    [self.contentView addSubview:_currentWebView];
    
    ZSSUIButton *noneButton     = [self createButtonWithNImage:[UIImage imageNamed:@"ZSSNaviBackButton_H"]
                                                        hImage:[UIImage imageNamed:@"ZSSNaviBackButton_H"]
                                                        action:@selector(noneOnClicked:)];
    noneButton.frame = (CGRect){
        10,
        SCREEN_HEIGHT - noneButton.frame.size.height - 5,
        noneButton.frame.size.width,
        noneButton.frame.size.height
    };
    [self.contentView addSubview:noneButton];
    
    ZSSUIButton *addTabButton   = [self createButtonWithNImage:[UIImage imageNamed:@"ZSSNaviBackButton_H"]
                                                        hImage:[UIImage imageNamed:@"ZSSNaviBackButton_H"]
                                                        action:@selector(addTabOnClicked:)];
    addTabButton.frame = (CGRect){
        (SCREEN_WIDTH - noneButton.frame.size.width) / 2,
        SCREEN_HEIGHT - noneButton.frame.size.height - 5,
        addTabButton.frame.size.width,
        addTabButton.frame.size.height
    };
    [self.contentView addSubview:addTabButton];
    
    ZSSUIButton *backTabButton  = [self createButtonWithNImage:[UIImage imageNamed:@"ZSSNaviBackButton_H"]
                                                        hImage:[UIImage imageNamed:@"ZSSNaviBackButton_H"]
                                                        action:@selector(backTabOnClicked:)];
    backTabButton.frame = (CGRect){
        SCREEN_WIDTH - backTabButton.frame.size.width - 10,
        SCREEN_HEIGHT - backTabButton.frame.size.height - 5,
        backTabButton.frame.size.width,
        backTabButton.frame.size.height
    };
    [self.contentView addSubview:backTabButton];
    
    _webViewProgressBar = [[ZSSUIProgressView alloc] initWithFrame:(CGRect){
        0.f,
        NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT - 2.f,
        SCREEN_WIDTH,
        2.f
    }];
    [self.contentView addSubview:_webViewProgressBar];
    
    _webViewProgressBar.alpha = 0;
    
    _tabView = [[ZSSTabView alloc] initWithFrame:(CGRect){
        0.f,
        SCREEN_HEIGHT - TABBAR_HEIGHT,
        SCREEN_WIDTH,
        TABBAR_HEIGHT
    }];
    
    ZSSUIButton *backButton     = [self createButtonWithNImage:[UIImage imageNamed:@"ZSSTabGoBackButton_N"]
                                                        hImage:[UIImage imageNamed:@"ZSSTabGoBackButton_H"]
                                                        action:@selector(goBack)];
    
    ZSSUIButton *forwarkButton  = [self createButtonWithNImage:[UIImage imageNamed:@"ZSSTabGoForwardButton_N"]
                                                        hImage:[UIImage imageNamed:@"ZSSTabGoForwardButton_H"]
                                                        action:@selector(goForward)];
    
    ZSSUIButton *menuButton     = [self createButtonWithNImage:[UIImage imageNamed:@"ZSSTabMenuButton_N"]
                                                        hImage:[UIImage imageNamed:@"ZSSTabMenuButton_H"]
                                                        action:@selector(menuOnClicked:)];
    
    ZSSUIButton *multiButton    = [self createButtonWithNImage:[UIImage imageNamed:@"ZSSTabMultiButton_N"]
                                                        hImage:[UIImage imageNamed:@"ZSSTabMultiButton_H"]
                                                        action:@selector(multiOnClicked:)];
    
    ZSSUIButton *homeButton     = [self createButtonWithNImage:[UIImage imageNamed:@"ZSSTabHomeButton_N"]
                                                        hImage:[UIImage imageNamed:@"ZSSTabHomeButton_H"]
                                                        action:@selector(goHome)];
    
    [_tabView setButtonItems:@[backButton, forwarkButton, menuButton, multiButton, homeButton]];
    [self.view addSubview:_tabView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ZSSUIButton *)createButtonWithNImage:(UIImage *)nimage hImage:(UIImage *)himage action:(SEL)action {
    ZSSUIButton *button     = [[ZSSUIButton alloc] init];
    [button setImage:nimage forState:UIControlStateNormal];
    [button setImage:himage forState:UIControlStateHighlighted];
    [button setImage:himage forState:UIControlStateDisabled];
    [button sizeToFit];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
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
        _addressURLString = _addressTextField.text;
        
        NSURL           *url        = [[NSURL alloc] initWithString:_addressTextField.text];
        NSURLRequest    *urlRequest = [NSURLRequest requestWithURL:url];
        
        [_currentWebView loadRequest:urlRequest];
    }
    else
    {
        NSString        *urlString  = [[NSString alloc] initWithFormat:@"http://%@", _addressTextField.text];
        
        if ([self validateURL:urlString])
        {
            _addressURLString = urlString;
            
            NSURL           *url        = [[NSURL alloc] initWithString:urlString];
            NSURLRequest    *urlRequest = [NSURLRequest requestWithURL:url];
            
            [_currentWebView loadRequest:urlRequest];
        }
        else
        {
            urlString = [[NSString alloc] initWithFormat:@"http://www.baidu.com/s?wd=%@", _addressTextField.text];
            
            urlString = [self encodeString:urlString];
            
            _addressURLString = urlString;
            
            NSURL           *url        = [[NSURL alloc] initWithString:urlString];
            NSURLRequest    *urlRequest = [NSURLRequest requestWithURL:url];
            
            [_currentWebView loadRequest:urlRequest];
        }
    }
}

- (void)dealloc
{
    [_currentWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    [_currentWebView setDelegate:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    UIImage *image = [UIImage imageNamed:@"ZSSNaviStopButton"];
    [self.reloadButton setImage:image forState:UIControlStateNormal];
}

- (void)webView:(ZSSUIWebView*)webView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources {
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    if (_webViewProgressBar.alpha == 0.f && resourceNumber > 0 && totalResources > resourceNumber)
    {
        _webViewProgressBar.progress = 0.f;
        
        [UIView animateWithDuration:0.2 animations:^{
            _webViewProgressBar.alpha = 1.f;
        }];
    }
    else if (_webViewProgressBar.alpha == 1.f && resourceNumber == totalResources)
    {
        [UIView animateWithDuration:0.2 animations:^{
            _webViewProgressBar.alpha = 0.f;
        } completion:^(BOOL finished) {
            _webViewProgressBar.progress = 0.f;
        }];
    }
    [_webViewProgressBar setProgress:(resourceNumber * 1.f / totalResources * 1.f) animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    UIImage *image = [UIImage imageNamed:@"ZSSNaviRefreshButton"];
    [self.reloadButton setImage:image forState:UIControlStateNormal];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    DDLogInfo(@"%@:%@", THIS_FILE, THIS_METHOD);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    _addressTitleString = [_currentWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    _addressTextField.text = _addressTitleString;
    
    [_currentWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('adpic')[0].style.display = 'none'"];
    
    UIImage *image = [UIImage imageNamed:@"ZSSNaviRefreshButton"];
    [self.reloadButton setImage:image forState:UIControlStateNormal];
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
    
    _dragStart = YES;
    
    _previousYOffset = scrollView.contentOffset.y;
    
    DDLogInfo(@"previousYOffset --- %lf", _previousYOffset);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_dragStart) {
        
        return;
    }
    
    DDLogInfo(@"scrollView.contentOffset.y --- %lf", scrollView.contentOffset.y);
    
    CGFloat delta = scrollView.contentOffset.y - _previousYOffset;
    
    DDLogInfo(@"delta --- %lf", delta);
    
    if (delta > 20) {
        
        [self showControl:NO animate:YES];
    }
    else if (delta < -20) {
        
        [self showControl:YES animate:YES];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    _dragStart = NO;
}

- (void)showControl:(BOOL)show animate:(BOOL)animate
{
    if (animate) {
        [UIView animateWithDuration:0.5 animations:^{
            if (show) {
                [self setNavigationViewFrame:(CGRect){
                    0.f,
                    0.f,
                    SCREEN_WIDTH,
                    STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT
                }];
                
                [_currentWebView setFrame:(CGRect){
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
            } else {
                [self setNavigationViewFrame:(CGRect){
                    0.f,
                    0.f,
                    SCREEN_WIDTH,
                    STATUSBAR_HEIGHT
                }];
                
                [_currentWebView setFrame:(CGRect){
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
        }];
    } else {
        if (show) {
            [self setNavigationViewFrame:(CGRect){
                0.f,
                0.f,
                SCREEN_WIDTH,
                STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT
            }];
            
            [_currentWebView setFrame:(CGRect){
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
        } else {
            [self setNavigationViewFrame:(CGRect){
                0.f,
                0.f,
                SCREEN_WIDTH,
                STATUSBAR_HEIGHT
            }];
            
            [_currentWebView setFrame:(CGRect){
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
    }
}

@end
