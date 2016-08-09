//
//  ZSSHTTPConnection.m
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/22.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSHTTPConnection.h"

#import "ZSSHTTPServer.h"

#import <MultipartMessageHeader.h>
#import <MultipartMessageHeaderField.h>
#import <HTTPDynamicFileResponse.h>
#import <HTTPMessage.h>

@interface ZSSHTTPConnection ()
{
    MultipartFormDataParser *parser;
    NSFileHandle *storeFile;
}

@end

@implementation ZSSHTTPConnection

#pragma mark HTTP Request and Response

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
    if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/index.html"])
    {
        return YES;
    }
    return [super supportsMethod:method atPath:path];
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path
{
    if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/index.html"])
    {
        NSString *contentType = [request headerField:@"Content-Type"];
        NSUInteger paramsSeparator = [contentType rangeOfString:@";"].location;
        
        if (paramsSeparator == NSNotFound || paramsSeparator >= contentType.length - 1)
        {
            return NO;
        }
        
        NSString *type = [contentType substringToIndex:paramsSeparator];
        
        if (![type isEqualToString:@"multipart/form-data"])
        {
            return NO;
        }
        
        NSArray *params = [[contentType substringFromIndex:paramsSeparator + 1] componentsSeparatedByString:@";"];
        
        for (NSString *param in params)
        {
            paramsSeparator = [param rangeOfString:@"="].location;
            
            if (paramsSeparator==NSNotFound || paramsSeparator>=param.length - 1)
            {
                continue;
            }
            
            NSString *paramName = [param substringWithRange:NSMakeRange(1, paramsSeparator - 1)];
            NSString *paramValue = [param substringFromIndex:paramsSeparator + 1];
            
            if ([paramName isEqualToString:@"boundary"])
            {
                [request setHeaderField:@"boundary" value:paramValue];
            }
        }
        
        if ([request headerField:@"boundary"]==nil)
        {
            return NO;
        }
        
        return YES;
    }
    return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
    if ([method isEqualToString:@"GET"] || ([method isEqualToString:@"POST"] && [path isEqualToString:@"/index.html"]))
    {
        NSMutableString *fileHtml = [[NSMutableString alloc] initWithString:@""];
        NSString *documentString = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:documentString];
        
        NSString *fileName = nil;
        while (fileName=[direnum nextObject])
        {
            NSString *fileURL = [[NSString alloc] initWithFormat:@"%@/%@", [[ZSSHTTPServer shareInstance] getDocumentURL], fileName];
            
            [fileHtml appendFormat:@"<a href=\"%@\"> %@ </a><br/>", fileURL, [fileName lastPathComponent]];
        }
        
        NSString *templatePath = [[config documentRoot] stringByAppendingPathComponent:@"index.html"];
        NSDictionary *replacementDict = [NSDictionary dictionaryWithObject:fileHtml forKey:@"MyFiles"];
        
        return [[HTTPDynamicFileResponse alloc] initWithFilePath:templatePath forConnection:self separator:@"%" replacementDictionary:replacementDict];
    }
    return [super httpResponseForMethod:method URI:path];
}

- (void)prepareForBodyWithSize:(UInt64)contentLength
{
    parser = [[MultipartFormDataParser alloc] initWithBoundary:[request headerField:@"boundary"] formEncoding:NSUTF8StringEncoding];
    parser.delegate = self;
}

- (void)processBodyData:(NSData *)postDataChunk
{
    [parser appendData:postDataChunk];
}

#pragma mark --- MultipartFormDataParserDelegate

- (void)processStartOfPartWithHeader:(MultipartMessageHeader *)header
{
    MultipartMessageHeaderField *disposition = [header.fields objectForKey:@"Content-Disposition"];
    
    NSString *fileName = [[disposition.params objectForKey:@"filename"] lastPathComponent];
    
    if (fileName==nil || [fileName isEqualToString:@""])
    {
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *uploadFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    if (![filemanager createFileAtPath:uploadFilePath contents:nil attributes:nil])
    {
        return;
    }
    
    storeFile = [NSFileHandle fileHandleForWritingAtPath:uploadFilePath];
}

- (void)processContent:(NSData *)data WithHeader:(MultipartMessageHeader *)header
{
    if (storeFile)
    {
        [storeFile writeData:data];
    }
}

- (void)processEndOfPartWithHeader:(MultipartMessageHeader *)header
{
    [storeFile closeFile];
    storeFile = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:UPLOADEND object:nil];
}

- (void)processPreambleData:(NSData *)data
{
    
}

- (void)processEpilogueData:(NSData *)data
{
    
}

@end
