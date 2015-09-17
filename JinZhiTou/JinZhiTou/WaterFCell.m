//
//  WaterFCell.m
//  CollectionView
//
//  Created by d2space on 14-2-26.
//  Copyright (c) 2014年 D2space. All rights reserved.
//

#import "WaterFCell.h"
#import "GlobalDefine.h"
#import "UConstants.h"
@implementation WaterFCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self setup];
    }
    return self;
}
#pragma mark - Setup
- (void)setup
{
    [self setupView];
    [self setupTextView];
}

- (void)setupView
{
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [self addSubview:self.imageView];
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 25, 30)];
    imgView.tag =1001;
    imgView.backgroundColor = ColorTheme;
    [self addSubview:imgView];
    
    UILabel* label = [[UILabel alloc]initWithFrame:imgView.frame];
    label.tag  =1002;
    label.numberOfLines = 0;
    label.font = SYSTEMFONT(10);
    label.textColor  =WriteColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:label];
}

- (void)setupTextView
{
    self.lblProjectName = [[UILabel alloc] initWithFrame:CGRectMake(0,10,0,0)];
    self.lblProjectName.font=[UIFont fontWithName:@"Arial" size:14];
    self.lblProjectName.textColor=[UIColor blackColor];
    self.lblProjectName.backgroundColor = [UIColor clearColor];
    [self addSubview:self.lblProjectName];
    
    self.lblRoadShowTime = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    self.lblRoadShowTime.textColor=[UIColor blackColor];
    self.lblRoadShowTime.font=[UIFont fontWithName:@"Arial" size:12];
    self.lblRoadShowTime.backgroundColor = [UIColor clearColor];
    [self addSubview:self.lblRoadShowTime];
}

-(void)setTinColor:(UIColor *)tinColor
{
    self->_tinColor = tinColor;
    
    UIImageView* imgView = (UIImageView*)[self viewWithTag:1001];
    imgView.backgroundColor = self.tinColor;
    
}

-(void)setTitle:(NSString *)title
{
    self->_title  =title;
    UILabel* label = (UILabel*)[self viewWithTag:1002];
    label.text = self.title;
}

@end
