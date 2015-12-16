//
//  WaterFallHeader.m
//  CollectionView
//
//  Created by d2space on 14-2-27.
//  Copyright (c) 2014年 D2space. All rights reserved.
//

#import "WaterFallHeader.h"

@implementation WaterFallHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addImageContent];
        [self addTextContent];
    }
    return self;
}
- (void)addTextContent
{
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(5, 4, 320, 30)];
    self.label.textColor = [UIColor redColor];
    self.label.text = Nil;
    [self addSubview:self.label];
}

- (void)addImageContent
{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 320, 38)];
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 1;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageView];
}




@end
