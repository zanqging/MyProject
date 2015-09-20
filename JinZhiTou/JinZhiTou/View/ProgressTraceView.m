//
//  ProgressTraceView.m
//  JinZhiTou
//
//  Created by air on 15/8/16.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ProgressTraceView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation ProgressTraceView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        progressBackView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 20, WIDTH(self)-10, 4)];
        progressBackView.backgroundColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [self addSubview:progressBackView];
        
        progressView = [[UIImageView alloc]initWithFrame:CGRectMake(5, Y(progressBackView), 0, 4)];
        progressView.backgroundColor = ColorTheme;
        [self addSubview:progressView];
        
            }
    return self;
}

-(void)setProgress:(float)progress
{
    self->_progress = progress;
    
    float w =WIDTH(progressBackView);
    CGRect frame = progressView.frame;
    frame.size.width = progress*w;
    
    [progressView setFrame:frame];
    
    UILabel* label;
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(w*progress+5, Y(progressView)-10, w, 10)];
    label.textColor = ColorTheme;
    NSString* str = [NSString stringWithFormat:@"%.1f",progress*100];
    str = [str stringByAppendingString:@"%"];
    label.text = str;
    label.font =SYSTEMFONT(10);
    [self addSubview:label];
}
@end
