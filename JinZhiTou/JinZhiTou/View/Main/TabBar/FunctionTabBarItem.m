//
//  Function.m
//  JinZhiTou
//
//  Created by air on 15/7/13.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FunctionTabBarItem.h"

@implementation FunctionTabBarItem
-(id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    //复写初始化方法
    UIImageView* imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_function"]];
    return self;
}
@end
