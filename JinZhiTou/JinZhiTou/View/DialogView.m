//
//  DialogView.m
//  JinZhiTou
//
//  Created by air on 15/8/12.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "DialogView.h"
#import "UConstants.h"
#import "TDUtil.h"
#import "GlobalDefine.h"
#import "UIView+SDAutoLayout.h"
#import <QuartzCore/QuartzCore.h>
@implementation DialogView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView* view = [[UIView alloc]initWithFrame:self.frame];
        view.backgroundColor = BlackColor;
        view.alpha=0.7;
        [self addSubview:view];
        
        view.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(30, HEIGHT(self)/2-75, WIDTH(self)-60,150)];
        imgView.tag = 1001;
        imgView.layer.cornerRadius = 5;
        imgView.layer.borderWidth = 0.5;
        imgView.backgroundColor = WriteColor;
        imgView.layer.borderColor  = ColorTheme.CGColor;
        [self addSubview:imgView];
        
        
        imgView.sd_layout
        .heightIs(150)
        .leftSpaceToView(self,30)
        .rightSpaceToView(self,30)
        .topSpaceToView(self,HEIGHT(self)/2-75);
//        .autoHeightRatio(0);
        
        
        //logo
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(imgView)/2-25, Y(imgView)-70, 100, 120)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = IMAGENAMED(@"Prompt box logo");
        [self addSubview:imageView];
        
        imageView.sd_layout
        .leftSpaceToView(self,WIDTH(imgView)/2-25)
        .widthIs(100)
        .heightIs(120)
        .topSpaceToView(imgView,-170)
        .autoHeightRatio(0);
        
        
        messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(imgView)+10, POS_Y(imgView)-90, WIDTH(imgView)-20, 40)];
        messageLabel.numberOfLines = 0;
        messageLabel.font = SYSTEMFONT(14);
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:messageLabel];
        
        messageLabel.sd_layout
        .leftSpaceToView(self,40)
        .rightSpaceToView(self,40)
        .topSpaceToView(imageView,65)
        .autoHeightRatio(0);
        messageLabel.sd_layout
        .minHeightIs(40);
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(imgView), POS_Y(messageLabel)+15, WIDTH(imgView), 1)];
        imgView.backgroundColor = BackColor;
        [self addSubview:imgView];
        
        imgView.sd_layout
        .topSpaceToView(messageLabel,10)
        .leftSpaceToView(self,30)
        .rightSpaceToView(self,30)
        .heightIs(1);
        
        
        self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(X(imgView), POS_Y(messageLabel)+10, WIDTH(imgView)/2, 40)];
        [self.cancelButton setTitleColor:ColorTheme forState:UIControlStateNormal];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self addSubview:self.cancelButton];
        
        self.cancelButton.sd_layout
        .topSpaceToView(imgView,0)
        .heightIs(40)
        .widthIs((WIDTH(self)-60)/2);
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.cancelButton), POS_Y(messageLabel)+15, 1,10)];
        imgView.tag=50001;
        imgView.backgroundColor = BackColor;
        [self addSubview:imgView];
        
        imgView.sd_layout
        .leftSpaceToView(self.cancelButton,0)
        .topEqualToView(self.cancelButton)
        .bottomEqualToView(self.cancelButton)
        .widthIs(1);
        
        self.shureButton = [[UIButton alloc]initWithFrame:CGRectMake(POS_X(self.cancelButton), Y(self.cancelButton), WIDTH(self.cancelButton), 40)];
        [self.shureButton setTitleColor:ColorTheme forState:UIControlStateNormal];
        [self.shureButton setTitle:@"去认证" forState:UIControlStateNormal];
        [self addSubview:self.shureButton];
        self.backgroundColor = ClearColor;
        
        self.shureButton.sd_layout
        .topEqualToView(self.cancelButton)
        .leftSpaceToView(imgView,0)
        .heightIs(40)
        .widthIs((WIDTH(self)-60)/2);
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    self->_title = title;
    if (self.title) {
//        [TDUtil setLabelMutableText:messageLabel content:self.title lineSpacing:5 headIndent:0];
        messageLabel.text = title;
    }
}

-(void)hideCancelButton
{
    [self.cancelButton removeFromSuperview];
    UIImageView* imgView =[self viewWithTag:50001];
    imgView.backgroundColor= ClearColor;
//    [self.shureButton setFrame:CGRectMake(10, Y(self.shureButton), WIDTH(self)-20, HEIGHT(self.shureButton))];
    self.shureButton.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .widthIs(WIDTH(self))
    .topSpaceToView(messageLabel, 20);
    
//    [self layoutSubviews];
//    
//    UIView * view  = [self viewWithTag:1001];
//    [view setHeight:POS_Y(self.shureButton)+10];
    
    
}

@end
