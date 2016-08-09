//
//  ZSSIPAddress.h
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/20.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSNSObject.h"

#define MAXADDRS    32

@interface ZSSIPAddress : ZSSNSObject

+ (NSString *)getIPAddress;

@end
