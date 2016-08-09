//
//  ZSSHTTPServer.h
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/19.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSNSObject.h"

@interface ZSSHTTPServer : ZSSNSObject

+ (instancetype)shareInstance;

- (NSString *)getDocumentURL;
- (UInt16)getServerPort;
- (void)startSuccess:(void (^)())success failure:(void (^)(id))failure;
- (void)stopServer;

@end
