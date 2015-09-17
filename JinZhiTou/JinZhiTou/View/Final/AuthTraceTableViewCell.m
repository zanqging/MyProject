//
//  AuthTraceTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "AuthTraceTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation AuthTraceTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.backgroundColor = ClearColor;
        
        viewTrace = [[UIView alloc]initWithFrame:CGRectMake(10, 10, frame.size.width-20, frame.size.height-10)];
        viewTrace.backgroundColor = WriteColor;
        [self addSubview:viewTrace];
        
        //状态图片
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 150, 30)];
        imgView.backgroundColor = ColorTheme;
        [viewTrace addSubview:imgView];
        //标签
        UILabel* label = [[UILabel alloc]initWithFrame:imgView.frame];
        label.tag = 10001;
        label.font = SYSTEMFONT(14);
        label.textColor = WriteColor;
        label.textAlignment = NSTextAlignmentRight;
        [viewTrace addSubview:label];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 50, 35, 35)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = IMAGENAMED(@"zhong");
        [viewTrace addSubview:imgView];
        
        label = [[ UILabel alloc]initWithFrame:CGRectMake(POS_Y(imgView)-10, 50, 210, 70)];
        label.numberOfLines  = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font  =SYSTEMFONT(16);
        label.text = @"    尊敬的用户，您的认证申请需要2-3天时间进行审核，请您耐心等待，审核通过后会以短信／App推送消息方式通知宁，请注意查收！";
        [viewTrace addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(label)+10, WIDTH(self)/3, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = SYSTEMFONT(16);
        label.text =@"提交认证申请";
        [viewTrace addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self)/3, Y(label), WIDTH(self)/3, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = SYSTEMFONT(16);
        label.text =@"等待后台审核";
        [viewTrace addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self)*2/3, Y(label), WIDTH(self)/3, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = SYSTEMFONT(16);
        label.text =@"申请成功";
        [viewTrace addSubview:label];
        
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(52, POS_Y(label)+13, WIDTH(self)-110, 3)];
        imgView.backgroundColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [viewTrace addSubview:imgView];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(52, POS_Y(label)+13, WIDTH(self)-170, 3)];
        imgView.backgroundColor = ColorTheme;
        [viewTrace addSubview:imgView];
        
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/6-10, POS_Y(imgView)-7, 10, 10)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = IMAGENAMED(@"1");
        [viewTrace addSubview:imgView];
        
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2-10, Y(imgView), 10, 10)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = IMAGENAMED(@"2");
        [viewTrace addSubview:imgView];
        
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)-60,Y(imgView), 10, 10)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = IMAGENAMED(@"3");
        [viewTrace addSubview:imgView];
        
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(imgView)+10, WIDTH(self)/3, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text=@"10:30";
        label.font =SYSTEMFONT(14);
        [viewTrace addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(label), WIDTH(self)/3, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text=@"2015-08-01";
        label.font =SYSTEMFONT(14);
        [viewTrace addSubview:label];
        
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self)/3, POS_Y(imgView)+10, WIDTH(self)/3, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text=@"13:30";
        label.font =SYSTEMFONT(14);
        [viewTrace addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self)/3, POS_Y(label), WIDTH(self)/3, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text=@"2015-08-01";
        label.font =SYSTEMFONT(14);
        [viewTrace addSubview:label];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setIsFinished:(BOOL)isFinished
{
    self->_isFinished  =isFinished;
    if (isFinished) {
        CGRect frame = self.frame;
        frame.size.height = 170;
        [self setFrame:frame ];
        
        UIView* v = [[UIView alloc]initWithFrame:viewTrace.frame];
        v.tag =20001;
        v.backgroundColor = WriteColor;
        //移除
        [viewTrace removeFromSuperview];
        [self addSubview:v];
        
        //状态图片
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 150, 30)];
        imgView.backgroundColor = ColorTheme;
        [v addSubview:imgView];
        //标签
        CGRect rect =imgView.frame;
        rect.origin.x+=10;
        UILabel* label = [[UILabel alloc]initWithFrame:rect];
        label.tag = 10001;
        label.font = SYSTEMFONT(14);
        label.textColor = WriteColor;
        label.textAlignment = NSTextAlignmentLeft;
        [v addSubview:label];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2-30, POS_Y(label)+5, 60, 60)];
        imgView.image = IMAGENAMED(@"touziren");
        imgView.contentMode =UIViewContentModeScaleAspectFill;
        [v addSubview:imgView];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(imgView)+5, WIDTH(self), 21)];
        label.font = SYSTEMFONT(16);
        label.text=@"尊敬的用户，您的审核已经审核通过!";
        label.textAlignment = NSTextAlignmentCenter;
        [v addSubview:label];
        
    }
}

-(void)setTitle:(NSString *)title
{
    self->_title = title;
    if (self.isFinished) {
        UIView* view = [self viewWithTag:20001];
        UILabel* label = (UILabel*)[view viewWithTag:10001];
        if (label) {
            label.text = self.title;
        }
    }else{
        UILabel* label = (UILabel*)[viewTrace viewWithTag:10001];
        if (label) {
            label.text = self.title;
        }
    }
    
}
@end
