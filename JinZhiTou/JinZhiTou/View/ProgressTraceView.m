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
        progressView.backgroundColor = AppColorTheme;
        [self addSubview:progressView];
        
            }
    return self;
}

-(void)setProgress:(float)progress
{
    self->_progress = progress;
    
    float w =WIDTH(progressBackView);
    CGRect frame = progressView.frame;
    
    float pro = progress > 1.0 ? 1.0 : progress;
    frame.size.width = pro*w;
    
    [progressView setFrame:frame];
    
    UILabel* label;
    
    CGRect rect;
    if (pro!=1.0) {
        rect = CGRectMake(w*pro+5, Y(progressView)-10, w, 10);
    }else{
        rect = CGRectMake(w*pro-40, Y(progressView)-10, w, 10);
    }
    label = [[UILabel alloc]initWithFrame:rect];
    label.textColor = FONT_COLOR_BLACK;
    NSString* str = [NSString stringWithFormat:@"%.1f",progress*100];
    str = [str stringByAppendingString:@"%"];
    label.text = str;
    label.font =SYSTEMFONT(12);
    [self addSubview:label];
    
    frame = progressBackView.frame;
    frame.origin.x = POS_X(progressView);
    frame.size.width = frame.size.width-frame.origin.x;
    [progressBackView setFrame:frame];
}
@end
