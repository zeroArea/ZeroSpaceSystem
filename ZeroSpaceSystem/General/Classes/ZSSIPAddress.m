//
//  ZSSIPAddress.m
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/20.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSIPAddress.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDTTYLogger.h>

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ZSSIPAddress

+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    int success = getifaddrs(&interfaces);
    
    if (success == 0) // Loop through linked list of interfaces
    {
        temp_addr = interfaces;
        
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                DDLogInfo(@"%@", [NSString stringWithUTF8String:temp_addr->ifa_name]);
                
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] hasPrefix:@"en"])
                {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces); // Free memory
    
    return address;
}

@end
