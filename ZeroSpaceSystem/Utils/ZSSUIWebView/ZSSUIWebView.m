//
//  ZSSUIWebView.m
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/21.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSUIWebView.h"

@interface UIWebView ()

- (id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource;
- (void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource;
- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource;

@end

@interface ZSSUIWebView ()

@property (nonatomic, assign) int resourceCount;
@property (nonatomic, assign) int resourceCompletedCount;

@end

@implementation ZSSUIWebView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource
{
    [super webView:view identifierForInitialRequest:initialRequest fromDataSource:dataSource];
    
    return [NSNumber numberWithInt:_resourceCount++];
}

- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFailLoadingWithError:error fromDataSource:dataSource];
    
    _resourceCompletedCount++;
    
    if ([self.progressDelegate respondsToSelector:@selector(webView:didReceiveResourceNumber:totalResources:)])
    {
        [self.progressDelegate webView:self didReceiveResourceNumber:_resourceCompletedCount totalResources:_resourceCount];
    }
    
    if (_resourceCount == _resourceCompletedCount)
    {
        _resourceCount = 0;
        _resourceCompletedCount = 0;
    }
}

-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFinishLoadingFromDataSource:dataSource];
    
    _resourceCompletedCount++;
    
    if ([self.progressDelegate respondsToSelector:@selector(webView:didReceiveResourceNumber:totalResources:)])
    {
        [self.progressDelegate webView:self didReceiveResourceNumber:_resourceCompletedCount totalResources:_resourceCount];
    }
    
    if (_resourceCount == _resourceCompletedCount)
    {
        _resourceCount = 0;
        _resourceCompletedCount = 0;
    }
}

@end
