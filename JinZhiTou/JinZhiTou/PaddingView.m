//
//  PaddingView.m
//  WeiNI
//
//  Created by air on 15/3/3.
//  Copyright (c) 2015年 weini. All rights reserved.
//

#import "PaddingView.h"

@implementation PaddingView

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        imageView= [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-10, frame.size.height)];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
    }
    return self;
}
-(void)setImage:(UIImage *)image
{
    self->_image=image;
    imageView.image=image;
}
@end
