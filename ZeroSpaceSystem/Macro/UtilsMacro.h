//
//  UtilsMacro.h
//  ZeroSpaceSystem
//
//  Created by NEO on 16/7/18.
//  Copyright © 2016年 zero. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

#define RGBA(r, g, b, a)        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]
#define RGB(r, g, b)            [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

#define SIZE(w, h)              CGSizeMake(w, h)
#define POINT(x, y)             CGPointMake(x, y)
#define RECT(x, y, w, h)        CGRectMake(x, y, w, h)

#define SAFE_REMOVEVIEW(v)      if (v) {[v removeFromSuperview];v = nil;}

#endif /* UtilsMacro_h */
