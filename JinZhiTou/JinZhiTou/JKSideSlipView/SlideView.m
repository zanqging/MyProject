//
//  SlideView.m
//  WeiNI
//
//  Created by air on 15/3/5.
//  Copyright (c) 2015年 weini. All rights reserved.
//

#import "SlideView.h"

@implementation SlideView
@synthesize imageView;
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        imageView=[[UIImageView alloc]initWithFrame:frame];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
    }
    return self;
}


@end
