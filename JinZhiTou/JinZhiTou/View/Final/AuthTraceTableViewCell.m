
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
        
        self.labelContent = [[ UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+10, Y(imgView), WIDTH(self)-POS_X(imgView)-20, 20)];
        self.labelContent.numberOfLines  = 0;
        self.labelContent.lineBreakMode = NSLineBreakByWordWrapping;
        self.labelContent.font  =SYSTEMFONT(14);
        [viewTrace addSubview:self.labelContent];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(self.labelContent)+60, WIDTH(self)/3, 21)];
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
        
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(X(viewTrace), POS_Y(imgView)+10, WIDTH(self)/3, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 10002;
        label.font =SYSTEMFONT(14);
        [viewTrace addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(X(viewTrace), POS_Y(label), WIDTH(self)/3, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 10003;
        label.font =SYSTEMFONT(14);
        [viewTrace addSubview:label];
        
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(viewTrace)/3, POS_Y(imgView)+10, WIDTH(self)/3, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 10004;
        label.font =SYSTEMFONT(14);
        [viewTrace addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(viewTrace)/3, POS_Y(label), WIDTH(self)/3, 21)];
        label.textAlignment = NSTextAlignmentCenter;
         label.tag = 10005;
        label.font =SYSTEMFONT(14);
        [viewTrace addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(viewTrace)*2/3, POS_Y(imgView)+10, WIDTH(self)/3, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 10006;
        label.font =SYSTEMFONT(14);
        [viewTrace addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(viewTrace)*2/3, POS_Y(label), WIDTH(self)/3, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 10007;
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
        label.text =self.title;
        label.font = SYSTEMFONT(14);
        label.textColor = WriteColor;
        label.textAlignment = NSTextAlignmentLeft;
        [v addSubview:label];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2-30, POS_Y(label)+35, 60, 60)];
        imgView.image = IMAGENAMED(@"touziren");
        imgView.contentMode =UIViewContentModeScaleAspectFill;
        [v addSubview:imgView];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(imgView)+30, WIDTH(self), 21)];
        label.font = SYSTEMFONT(16);
        label.text=self.content;
        label.textAlignment = NSTextAlignmentCenter;
        [v addSubview:label];
    }
}

-(void)setIsScuesssed:(BOOL)isScuesssed
{
    self->_isScuesssed  =isScuesssed;

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
    label.text =self.title;
    label.font = SYSTEMFONT(14);
    label.textColor = WriteColor;
    label.textAlignment = NSTextAlignmentLeft;
    [v addSubview:label];
    
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2-30, POS_Y(label)+35, 60, 60)];
     if (isScuesssed) {
         imgView.image = IMAGENAMED(@"application-success");
     }else{
         imgView.image = IMAGENAMED(@"application-fails");
     }
    imgView.contentMode =UIViewContentModeScaleAspectFill;
    [v addSubview:imgView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(imgView)+30, WIDTH(self), 21)];
    label.font = SYSTEMFONT(16);
    label.text=self.content;
    label.textAlignment = NSTextAlignmentCenter;
    [v addSubview:label];
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

-(void)setContent:(NSString *)content
{
    self->_content  =content;
    
    if (self.content) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
        
        [paragraphStyle setLineSpacing:8.f];//调整行间距
        [paragraphStyle setAlignment:NSTextAlignmentJustified];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
        
        self.labelContent.attributedText = attributedString;//ios 6
        [self.labelContent sizeToFit];
    }

}

-(void)setCreateDateTime:(NSString *)createDateTime
{
    self->_createDateTime = createDateTime;
    if (self.createDateTime && ![self.createDateTime isEqualToString:@""]) {
        NSString* timeStart = [createDateTime substringWithRange:NSMakeRange(11, 8)];
        UILabel* label =(UILabel*)[viewTrace viewWithTag:10002];
        label.text = timeStart;
        
        timeStart = [createDateTime substringWithRange:NSMakeRange(0, 10)];
        label =(UILabel*)[viewTrace viewWithTag:10003];
        label.text = timeStart;
    }
}

-(void)setHandleDateTime:(NSString *)handleDateTime
{
    self->_handleDateTime = handleDateTime;
    if (self.handleDateTime && ![self.handleDateTime isEqualToString:@""]) {
        NSString* timeStart = [handleDateTime substringWithRange:NSMakeRange(11, 8)];
        UILabel* label =(UILabel*)[viewTrace viewWithTag:10004];
        label.text = timeStart;
        
        timeStart = [handleDateTime substringWithRange:NSMakeRange(0, 10)];
        label =(UILabel*)[viewTrace viewWithTag:10005];
        label.text = timeStart;
    }

}

-(void)setAuditDateTime:(NSString *)auditDateTime
{
    self->_auditDateTime =auditDateTime;
    if (self.auditDateTime && ![self.auditDateTime isEqualToString:@""]) {
        NSString* timeStart = [auditDateTime substringWithRange:NSMakeRange(11, 8)];
        UILabel* label =(UILabel*)[viewTrace viewWithTag:10006];
        label.text = timeStart;
        
        timeStart = [auditDateTime substringWithRange:NSMakeRange(0, 10)];
        label =(UILabel*)[viewTrace viewWithTag:10007];
        label.text = timeStart;   
    }
    
    
}
@end
