//
//  ZSSHTTPServer.m
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/19.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSHTTPServer.h"

#import "ZSSHTTPConnection.h"
#import "ZSSIPAddress.h"

#import <CocoaHTTPServer/HTTPServer.h>
#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDTTYLogger.h>

#define HTTPSERVERPORT      13135
#define DOCUMENTSERVERPORT  13134

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface ZSSHTTPServer ()
{
    HTTPServer *httpServer;
    HTTPServer *documentServer;
}

@end

@implementation ZSSHTTPServer

+ (instancetype)shareInstance
{
    static ZSSHTTPServer *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZSSHTTPServer alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        httpServer = [[HTTPServer alloc] init];
        [httpServer setType:@"_http._tcp."];
        [httpServer setPort:HTTPSERVERPORT];
        
        NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"System"];
        
        [httpServer setDocumentRoot:webPath];
        
        [httpServer setConnectionClass:[ZSSHTTPConnection class]];
        
        documentServer = [[HTTPServer alloc] init];
        [documentServer setType:@"_http._tcp."];
        [documentServer setPort:DOCUMENTSERVERPORT];
        
        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        [documentServer setDocumentRoot:docPath];
    }
    return self;
}

- (NSString *)getDocumentURL
{
    NSString *documentURLString = [[NSString alloc] initWithFormat:@"http://%@:%hu", [ZSSIPAddress getIPAddress], [documentServer listeningPort]];
    
    return documentURLString;
}

- (UInt16)getServerPort
{
    return [httpServer listeningPort];
}

- (void)startSuccess:(void (^)())success failure:(void (^)(id))failure
{
    // Start the server (and check for problems)
    
    NSError *error;
    if([httpServer start:&error])
    {
        if ([documentServer start:&error])
        {
            DDLogInfo(@"Started http server on port %hu", [httpServer listeningPort]);
            DDLogInfo(@"Started document server on port %hu", [documentServer listeningPort]);
            
            if (success)
            {
                success();
            }
        }
        else
        {
            [httpServer stop];
            
            DDLogError(@"Error starting document Server: %@", error);
            if (failure)
            {
                failure(error);
            }
        }
    }
    else
    {
        DDLogError(@"Error starting http Server: %@", error);
        if (failure)
        {
            failure(error);
        }
    }
}

- (void)stopServer
{
    [httpServer stop];
    [documentServer stop];
}

@end
