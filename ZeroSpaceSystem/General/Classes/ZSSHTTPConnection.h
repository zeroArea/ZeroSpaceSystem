//
//  ZSSHTTPConnection.h
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/22.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <HTTPConnection.h>
#import <MultipartFormDataParser.h>

#define UPLOADSTART         @"uploadstart"
#define UPLOADING           @"uploading"
#define UPLOADEND           @"uploadend"
#define UPLOADISCONNECTED   @"uploadisconnected"

@interface ZSSHTTPConnection : HTTPConnection
<
MultipartFormDataParserDelegate
>

@end
