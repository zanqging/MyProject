//
//  UILabel+Data.m
//  Cycle
//
//  Created by air on 15/10/15.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "UILabel+Data.h"

@implementation UILabel (UILabel_Data)
//@dynamic index;
- (id)index
{
    return objc_getAssociatedObject(self, @selector(index));
}

- (void)setIndex:(id)index
{
    objc_setAssociatedObject(self, @selector(index), index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
