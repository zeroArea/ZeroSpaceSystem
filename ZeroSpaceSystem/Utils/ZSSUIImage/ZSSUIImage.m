//
//  ZSSUIImage.m
//  ZeroSpaceSystem
//
//  Created by NEO on 16/8/5.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ZSSUIImage.h"

@implementation ZSSUIImage

+ (ZSSUIImage *)imageNamed:(NSString *)imageName {
    
    ZSSUIImage *image = (ZSSUIImage *)[UIImage imageNamed:imageName];
    
    return image;
}

@end
