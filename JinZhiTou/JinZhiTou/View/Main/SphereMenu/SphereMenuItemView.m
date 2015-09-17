//
//  SphereMenuItemView.m
//  JinZhiTou
//
//  Created by air on 15/7/18.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "SphereMenuItemView.h"
#import "UConstants.h"

static const float HEIGHT = 25;
@implementation SphereMenuItemView
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        //图片
        self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self)-10, (HEIGHT(self)-HEIGHT))];
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        
        //标签
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(self.imageView)-15, WIDTH(self), HEIGHT)];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font=[UIFont fontWithName:@"Arial" size:12];
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
                                                                               
    }
    return self;
}

-(void)setModel:(DataModel *)model
{
    self.titleLabel.text=model.desc1;
    self.imageView.image=[UIImage imageNamed:model.desc2];
}
@end
