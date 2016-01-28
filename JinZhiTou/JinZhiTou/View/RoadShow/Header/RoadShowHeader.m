//
//  RoadShowHeader.m
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "RoadShowHeader.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "ZFProgressView.h"
#import "ProgressTraceView.h"
#import <QuartzCore/QuartzCore.h>
@interface RoadShowHeader()
{
    CGRect imgFrame;
    UIImageView* imgSelectView;
    ProgressTraceView* traceView;
}
@end

@implementation RoadShowHeader
@synthesize introduceImgview;
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        //图片
        introduceImgview=[[UIImageView alloc]initWithFrame:CGRectMake(1, 0, WIDTH(self)-2, 170)];
        introduceImgview.image =IMAGENAMED(@"loading");
        introduceImgview.layer.masksToBounds = YES;
        introduceImgview.contentMode = UIViewContentModeCenter;
        [self addSubview:introduceImgview];
        
        //播放按钮
        self.imgPlay = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(introduceImgview)/2-20, HEIGHT(introduceImgview)/2-20, 40, 40)];
        self.imgPlay.image = IMAGENAMED(@"bofang");
        self.imgPlay.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imgPlay];
        
        
        //介绍状态
        statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(X(introduceImgview)+20, Y(introduceImgview), 40, 50)];
        statusLabel.numberOfLines=0;
        statusLabel.font = SYSTEMFONT(16);
        statusLabel.textColor = WriteColor;
        statusLabel.backgroundColor=ColorTheme;
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:statusLabel];
        
        self.backgroundColor = WriteColor;
        
        
        //自适应
        introduceImgview.sd_layout
        .leftSpaceToView(self,1)
        .rightSpaceToView(self,1)
        .topSpaceToView(self,0)
        .heightIs(170);
        
        self.imgPlay.sd_layout
        .leftSpaceToView(self,WIDTH(introduceImgview)/2-10)
        .topSpaceToView(self,HEIGHT(introduceImgview)/2-20)
        .widthEqualToHeight(40);
        
        statusLabel.sd_layout
        .leftSpaceToView(self,20)
        .topEqualToView(introduceImgview)
        .widthIs(40)
        .heightIs(50);
    }
    return self;
}

-(void)teamShowAction:(UITapGestureRecognizer*)sender
{
    NSInteger tag = sender.view.tag;
    if ([_delegate respondsToSelector:@selector(roadShowHeader:tapTag:)]) {
        [_delegate roadShowHeader:self tapTag:(int)tag];
    }
}

-(void)collect:(UITapGestureRecognizer*)sender
{
    if ([_delegate respondsToSelector:@selector(collect)]) {
        if (!self.isCollect) {
            [currentColllectButton setImage:IMAGENAMED(@"shoucang_selected") forState:UIControlStateNormal];
            [_delegate collect];
        }else{
            [currentColllectButton setImage:IMAGENAMED(@"shoucang") forState:UIControlStateNormal];
            [_delegate collect];
        }
    }
}

-(void)prise:(UITapGestureRecognizer*)sender
{
    if ([_delegate respondsToSelector:@selector(prise)]) {
        if (!self.isLike) {
            [currentPriseButton setImage:IMAGENAMED(@"dianzan_selected") forState:UIControlStateNormal];
        }else{
            [currentPriseButton setImage:IMAGENAMED(@"dianzan") forState:UIControlStateNormal];
        }
        [_delegate prise];
    }
}

-(void)setType:(int)type
{
    self->_type = type;
    if (self.type == 0) {
        UIView * lineView = [[UIView alloc]init];
        lineView.backgroundColor  =BackColor;
        [self addSubview:lineView];
        
        lineView.sd_layout
        .leftSpaceToView(self,0)
        .topSpaceToView(introduceImgview,0)
        .rightEqualToView(self)
        .heightIs(3);
        
        //已获取融资
        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(lineView)+10, WIDTH(self)/3, 21)];
        leftLabel.tag = 5001;
        leftLabel.font=SYSTEMFONT(16);
        leftLabel.textColor  =ColorCompanyTheme;
        leftLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:leftLabel];
        
        leftLabel.sd_layout
        .leftEqualToView(introduceImgview)
        .topSpaceToView(lineView,5)
        .heightIs(20)
        .widthRatioToView(self,0.5);
        
        lineView = [[UIView alloc]init];
        lineView.backgroundColor  =BackColor;
        [self addSubview:lineView];
        
        lineView.sd_layout
        .leftSpaceToView(self,0)
        .topSpaceToView(leftLabel,5)
        .rightEqualToView(self)
        .heightIs(1);
        
        lineView = [[UIView alloc]init];
        lineView.backgroundColor  =BackColor;
        [self addSubview:lineView];
//
        lineView.sd_layout
        .leftSpaceToView(self,0)
        .topSpaceToView(leftLabel,5)
        .rightEqualToView(self)
        .heightIs(3);
        
        
        lineView = [[UIView alloc]init];
        lineView.backgroundColor  =BackColor;
        [self addSubview:lineView];
        
        lineView.sd_layout
        .leftSpaceToView(leftLabel,0)
        .topSpaceToView(introduceImgview,0)
        .bottomEqualToView(leftLabel)
        .widthIs(1);
//
//        
//        
        //点赞收藏
        currentPriseButton=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)-40, Y(leftLabel), 40, 21)];
        currentPriseButton.titleLabel.font=SYSTEMFONT(16);
        currentPriseButton.userInteractionEnabled  = YES;
        currentPriseButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [currentPriseButton setTitleColor:BlackColor forState:UIControlStateNormal];
        [currentPriseButton setImage:IMAGENAMED(@"dianzan") forState:UIControlStateNormal];
        [currentPriseButton addTarget:self action:@selector(prise:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:currentPriseButton];
        
        currentPriseButton.sd_layout
        .heightIs(21)
        .widthIs(60)
        .rightSpaceToView(self,60)
        .topEqualToView(leftLabel);
        
        //收藏
        currentColllectButton = [[UIButton alloc]initWithFrame:CGRectMake(X(currentPriseButton)-60, Y(currentPriseButton), 40, 21)];
        currentColllectButton.titleLabel.font=SYSTEMFONT(16);
        currentColllectButton.userInteractionEnabled  = YES;
        [currentColllectButton setTitleColor:BlackColor forState:UIControlStateNormal];
        currentColllectButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [currentColllectButton setImage:IMAGENAMED(@"shoucang") forState:UIControlStateNormal];
        [currentColllectButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:currentColllectButton];
        
        
        currentColllectButton.sd_layout
        .leftSpaceToView(currentPriseButton,0)
        .heightIs(21)
        .widthIs(60)
        .topEqualToView(leftLabel);
//
//        
//        
//        lineView = [[UIView alloc]init];
//        lineView.backgroundColor  =BackColor;
//        [self addSubview:lineView];
//        
//        lineView.sd_layout
//        .leftSpaceToView(self,0)
//        .rightSpaceToView(self,0)
//        .topSpaceToView(leftLabel,5)
//        .heightIs(3);
//        
//        
//        UIView* lineView1 = [[UIView alloc]init];
//        lineView1.backgroundColor  =LightGrayColor;
//        [self addSubview:lineView1];
//        
//        lineView1.sd_layout
//        .leftSpaceToView(self,0)
//        .rightSpaceToView(self,0)
//        .topSpaceToView(lineView,0)
//        .heightIs(10);
//        
//        [self setupAutoHeightWithBottomView:lineView1 bottomMargin:0];

    }else{
        
        //已获取融资
        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(traceView)+20, WIDTH(self)/3, 21)];
        leftLabel.textAlignment=NSTextAlignmentCenter;
        leftLabel.font=SYSTEMFONT(16);
        leftLabel.textColor  =ColorCompanyTheme;
        leftLabel.tag = 5001;
        [self addSubview:leftLabel];
        

        leftLabel.sd_layout
        .leftEqualToView(introduceImgview)
        .topSpaceToView(introduceImgview,5)
        .heightIs(20)
        .widthRatioToView(self,0.5);
        
        UIView * lineView = [[UIView alloc]init];
        lineView.backgroundColor  =BackColor;
        [self addSubview:lineView];
        
        lineView.sd_layout
        .leftSpaceToView(self,0)
        .topSpaceToView(leftLabel,5)
        .rightEqualToView(leftLabel)
        .heightIs(1);
        

        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(leftLabel), POS_Y(leftLabel), WIDTH(leftLabel), 21)];
        leftLabel.textAlignment=NSTextAlignmentCenter;
        leftLabel.font=SYSTEMFONT(16);
        leftLabel.textColor = ColorCompanyTheme;
        leftLabel.tag = 5003;
        [self addSubview:leftLabel];
        
        leftLabel.sd_layout
        .leftEqualToView(leftLabel)
        .topSpaceToView(lineView,5)
        .heightIs(HEIGHT(leftLabel))
        .widthRatioToView(self,0.5);
        
        lineView = [[UIView alloc]init];
        lineView.backgroundColor  =BackColor;
        [self addSubview:lineView];
        
        lineView.sd_layout
        .leftSpaceToView(self,0)
        .topSpaceToView(leftLabel,5)
        .rightEqualToView(self)
        .heightIs(3);
        
        
        lineView = [[UIView alloc]init];
        lineView.backgroundColor  =BackColor;
        [self addSubview:lineView];
        
        lineView.sd_layout
        .leftSpaceToView(leftLabel,0)
        .topSpaceToView(introduceImgview,0)
        .bottomEqualToView(leftLabel)
        .widthIs(1);
        
        ZFProgressView *progress1 = [[ZFProgressView alloc] initWithFrame:CGRectMake(WIDTH(self)/2+WIDTH(self)/16, POS_Y(introduceImgview)+5, 40, 40)];
        
        progress1.tag = 6001;
        progress1.type = 1;
        [self addSubview:progress1];
        
        [progress1 setProgressStrokeColor:[TDUtil colorWithHexString:@"33c6d6"]];
        [progress1 setBackgroundStrokeColor:[UIColor lightGrayColor]];
        [progress1 setDigitTintColor:[UIColor greenColor]];
        [progress1 setFont:SYSTEMFONT(12)];
        [progress1 setProgressLineWidth:3];
        [progress1 setBackgourndLineWidth:3];
        [progress1 setProgress:0 Animated:YES];
        
        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self)/2, POS_Y(progress1), WIDTH(self)/4, 20)];
        leftLabel.text = @"剩余天数";
        leftLabel.font  = SYSTEMFONT(10);
        leftLabel.textColor = FONT_COLOR_GRAY;
        leftLabel.textAlignment  =NSTextAlignmentCenter;
        [self addSubview:leftLabel];
//
//        progress1.sd_layout
//        .leftSpaceToView(lineView,10)
//        .widthEqualToHeight(30)
//        .topSpaceToView(introduceImgview,10);
        
        ZFProgressView *progress2 = [[ZFProgressView alloc] initWithFrame:CGRectMake(POS_X(progress1)+WIDTH(self)/8, Y(progress1), WIDTH(progress1), HEIGHT(progress1))];
        
        progress2.tag = 6002;
        [self addSubview:progress2];
        [progress2 setProgressStrokeColor:[TDUtil colorWithHexString:@"33c6d6"]];
        [progress2 setBackgroundStrokeColor:[UIColor lightGrayColor]];
        [progress2 setDigitTintColor:[UIColor greenColor]];
        [progress2 setFont:SYSTEMFONT(8)];
        [progress2 setProgressLineWidth:3];
        [progress2 setBackgourndLineWidth:3];
        
        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(leftLabel), Y(leftLabel), WIDTH(leftLabel), HEIGHT(leftLabel))];
        leftLabel.text = @"众筹中";
        leftLabel.font  = SYSTEMFONT(10);
        leftLabel.textColor = FONT_COLOR_GRAY;
        leftLabel.textAlignment  =NSTextAlignmentCenter;
        [self addSubview:leftLabel];
        
        NSArray *tickerStrings = [NSArray arrayWithObjects:@"", nil];
        
        tickerView = [[JHTickerView alloc]init];
        [tickerView setDirection:JHTickerDirectionLTR];
        [tickerView setTickerStrings:tickerStrings];
        [tickerView setTickerSpeed:60.0f];
        [tickerView pause];
        
        [self addSubview:tickerView];
        
        tickerView.sd_layout
        .topSpaceToView(progress1,25)
        .leftSpaceToView(self,10)
        .widthRatioToView(self,0.6)
        .heightIs(20);
        
        
        
        
        //点赞收藏
        currentPriseButton=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)-60, Y(tickerView), 40, 21)];
        currentPriseButton.titleLabel.font=SYSTEMFONT(16);
        [currentPriseButton setTitleColor:BlackColor forState:UIControlStateNormal];
        currentPriseButton.userInteractionEnabled  = YES;
        currentPriseButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [currentPriseButton setImage:IMAGENAMED(@"dianzan") forState:UIControlStateNormal];
        [currentPriseButton addTarget:self action:@selector(prise:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:currentPriseButton];
        
        currentPriseButton.sd_layout
        .heightIs(21)
        .widthIs(60)
        .rightSpaceToView(self,60)
        .topEqualToView(tickerView);
        
        //收藏
        currentColllectButton = [[UIButton alloc]initWithFrame:CGRectMake(X(currentPriseButton)-60, Y(currentPriseButton), 40, 21)];
        currentColllectButton.titleLabel.font=SYSTEMFONT(16);
        [currentColllectButton setTitleColor:BlackColor forState:UIControlStateNormal];
        currentColllectButton.userInteractionEnabled  = YES;
        currentColllectButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [currentColllectButton setImage:IMAGENAMED(@"shoucang") forState:UIControlStateNormal];
        [currentColllectButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:currentColllectButton];
        
        
        currentColllectButton.sd_layout
        .leftSpaceToView(currentPriseButton,0)
        .heightIs(21)
        .widthIs(60)
        .topEqualToView(tickerView);
        
        
        
        lineView = [[UIView alloc]init];
        lineView.backgroundColor  =BackColor;
        [self addSubview:lineView];
        
        lineView.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(tickerView,5)
        .heightIs(3);
        
        
        UIView* lineView1 = [[UIView alloc]init];
        lineView1.backgroundColor  =LightGrayColor;
        [self addSubview:lineView1];
        
        lineView1.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(lineView,0)
        .heightIs(10);
        
        float w =WIDTH(self)/4;
        float h =POS_Y(lineView)+20;
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        //融资计划
//        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w/2-12.5, h, 25, 25)];
        UIImageView* imageView = [UIImageView new];
        imageView.tag = 10001;
        imageView.userInteractionEnabled=YES;
        imageView.image=IMAGENAMED(@"Plan");
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        imageView.sd_layout
        .topSpaceToView(lineView,30)
        .heightIs(25)
        .leftSpaceToView(self,w/2-12.5);

        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        UILabel* lbl = [[UILabel alloc]initWithFrame:CGRectMake(X(imageView)-20, POS_Y(imageView)+5, 70, 21)];
        lbl.text = @"融资计划";
        lbl.tag = 10002;
        lbl.font = SYSTEMFONT(14);
        lbl.userInteractionEnabled=YES;
        [lbl addGestureRecognizer:recognizer];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
        
        lbl.sd_layout
        .leftSpaceToView(self,0)
        .topSpaceToView(imageView,5)
        .widthIs(WIDTH(self)/4)
        .autoHeightRatio(0);
        
        
        lineView = [[UIView alloc]init];
        lineView.backgroundColor  =BackColor;
        [self addSubview:lineView];
        
        lineView.sd_layout
        .widthIs(1)
        .leftSpaceToView(lbl,0)
        .topEqualToView(imageView)
        .bottomEqualToView(lbl);
        

        //投资列表
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w*3/2-12.5, h, 25, 25)];
        imageView.tag = 10003;
        imageView.userInteractionEnabled=YES;
        imageView.image=IMAGENAMED(@"list");
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        imageView.sd_layout
        .heightIs(25)
        .topEqualToView(lineView)
        .leftSpaceToView(lineView,w/2-12.5);

        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(X(imageView)-20, POS_Y(imageView)+5, 70, 21)];
        lbl.text = @"投资列表";
        lbl.tag = 10004;
        lbl.font = SYSTEMFONT(14);
        lbl.userInteractionEnabled=YES;
        [lbl addGestureRecognizer:recognizer];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
        
        lbl.sd_layout
        .leftSpaceToView(lineView,0)
        .topSpaceToView(imageView,5)
        .widthIs(WIDTH(self)/4)
        .autoHeightRatio(0);
        
        
        lineView = [[UIView alloc]init];
        lineView.backgroundColor  =BackColor;
        [self addSubview:lineView];
        
        lineView.sd_layout
        .widthIs(1)
        .leftSpaceToView(lbl,0)
        .topEqualToView(imageView)
        .bottomEqualToView(lbl);
        

        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        //核心团队
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w*5/2-12.5, h, 25, 25)];
        imageView.tag = 10005;
        imageView.userInteractionEnabled=YES;
        imageView.image=IMAGENAMED(@"team");
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        imageView.sd_layout
        .heightIs(25)
        .topEqualToView(lineView)
        .leftSpaceToView(lineView,w/2-12.5);

        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(X(imageView)-20, POS_Y(imageView)+5, 70, 21)];
        lbl.text = @"核心团队";
        lbl.tag = 10005;
        lbl.font = SYSTEMFONT(14);
        lbl.userInteractionEnabled=YES;
        [lbl addGestureRecognizer:recognizer];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
        
        lbl.sd_layout
        .leftSpaceToView(lineView,0)
        .topSpaceToView(imageView,5)
        .widthIs(WIDTH(self)/4)
        .autoHeightRatio(0);
        
        lineView = [[UIView alloc]init];
        lineView.backgroundColor  =BackColor;
        [self addSubview:lineView];
        
        lineView.sd_layout
        .widthIs(1)
        .leftSpaceToView(lbl,0)
        .topEqualToView(imageView)
        .bottomEqualToView(lbl);

        //互动专栏
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w*7/2-12.5, h, 25, 25)];
        imageView.tag = 10006;
        imageView.userInteractionEnabled=YES;
        [imageView addGestureRecognizer:recognizer];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image=IMAGENAMED(@"Interactive");
        [self addSubview:imageView];
        
        imageView.sd_layout
        .heightIs(25)
        .topEqualToView(lineView)
        .leftSpaceToView(lineView,w/2-12.5);
        
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(X(imageView)-20, POS_Y(imageView)+5, 70, 21)];
        lbl.text = @"互动专栏";
        lbl.tag = 10006;
        lbl.font = SYSTEMFONT(14);
        lbl.userInteractionEnabled = YES;
        [lbl addGestureRecognizer:recognizer];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
        
        lbl.sd_layout
        .leftSpaceToView(lineView,0)
        .topSpaceToView(imageView,5)
        .widthIs(WIDTH(self)/4)
        .autoHeightRatio(0);
        
        lineView = [[UIView alloc]init];
        lineView.backgroundColor  =BackColor;
        [self addSubview:lineView];
        
        lineView.sd_layout
        .widthIs(1)
        .leftSpaceToView(lbl,0)
        .topEqualToView(imageView)
        .bottomEqualToView(lbl);
        
        
        
        lineView = [[UIView alloc]init];
        lineView.backgroundColor  =BackColor;
        [self addSubview:lineView];
        
        lineView.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(lbl,20)
        .heightIs(3);
        
        
        lineView1 = [[UIView alloc]init];
        lineView1.backgroundColor  =LightGrayColor;
        [self addSubview:lineView1];
        
        lineView1.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(lineView,0)
        .heightIs(10);
        
        [self setupAutoHeightWithBottomView:lineView1 bottomMargin:0];
        
//
//        progress2.sd_layout
//        .leftSpaceToView(progress1,30)
//        .widthEqualToHeight(30)
//        .topSpaceToView(introduceImgview,10);
        
        
//        float w = (WIDTH(self)-20)/4;
//        //行业
//        UILabel* lbl=[[UILabel alloc]initWithFrame:CGRectMake(X(introduceImgview), POS_Y(introduceImgview)+10, w, 21)];
//        lbl.textAlignment=NSTextAlignmentLeft;
//        lbl.tag = 30001;
//        lbl.font=SYSTEMFONT(14);
//        [self addSubview:lbl];
//        //内容
//        industryLabel=[[UILabel alloc]initWithFrame:CGRectMake(POS_X(lbl), Y(lbl), w, HEIGHT(lbl))];
//        industryLabel.textColor=ColorTheme;
//        industryLabel.textAlignment=NSTextAlignmentLeft;
//        industryLabel.font=SYSTEMFONT(12);
//        [self addSubview:industryLabel];
//        
//        
//        //预路演时间
//        lbl=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self)-w-10, POS_Y(introduceImgview)+10, w, 21)];
//        lbl.tag = 30002;
//        lbl.font=SYSTEMFONT(12);
//        lbl.textColor = ColorTheme;
//        lbl.textAlignment=NSTextAlignmentLeft;
//        [self addSubview:lbl];
//        
//        
//        showTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(POS_X(industryLabel), POS_Y(introduceImgview)+10, w, 21)];
//        showTimeLabel.font=lbl.font;
//        showTimeLabel.font = SYSTEMFONT(14);
//        showTimeLabel.textAlignment=NSTextAlignmentLeft;
//        [self addSubview:showTimeLabel];
//
//        
//        traceView = [[ProgressTraceView alloc]initWithFrame:CGRectMake(20, POS_Y(showTimeLabel), WIDTH(self)-40, 30)];
//        [self addSubview:traceView];
//        
//        //已获取融资
//        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(traceView)+20, WIDTH(self)/3, 21)];
//        leftLabel.textAlignment=NSTextAlignmentCenter;
//        leftLabel.font=SYSTEMFONT(13);
//        leftLabel.text=@"0万";
//        leftLabel.tag = 5001;
//        [self addSubview:leftLabel];
//        
//        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(leftLabel), POS_Y(leftLabel), WIDTH(leftLabel), 21)];
//        leftLabel.textAlignment=NSTextAlignmentCenter;
//        leftLabel.font=SYSTEMFONT(14);
//        leftLabel.text=@"已获融资";
//        [self addSubview:leftLabel];
//        
//        
//        //预融资总额
//        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self)*2/3, POS_Y(traceView)+20, WIDTH(self)/3, 21)];
//        leftLabel.textAlignment=NSTextAlignmentCenter;
//        leftLabel.font=SYSTEMFONT(13);
//        leftLabel.text=@"0万";
//        leftLabel.tag = 5003;
//        [self addSubview:leftLabel];
//        
//        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(leftLabel), POS_Y(leftLabel), WIDTH(leftLabel), 21)];
//        leftLabel.textAlignment=NSTextAlignmentCenter;
//        leftLabel.font=SYSTEMFONT(14);
//        leftLabel.text=@"计划融资";
//        [self addSubview:leftLabel];
//
//
    }
}

-(void)setIntroduceImage:(NSString *)introduceImage
{
    self->_introduceImage = introduceImage;
    if (self.introduceImage) {
        NSURL * url = [NSURL URLWithString:self.introduceImage];
        
        [introduceImgview sd_setImageWithURL:url placeholderImage:introduceImgview.image completed:
         ^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL *imageUrl){
             [introduceImgview setContentMode:UIViewContentModeScaleToFill];
         }];
    }
}

-(void)setStatus:(NSString *)status
{
    self->_status = status;
    if (self.status) {
        statusLabel.text = self.status;
        
        UILabel* label = (UILabel*)[self viewWithTag:5002];
        if (label) {
            label.text = status;
        }
    }
}

-(void)setIndustry:(NSString *)industry
{
    self->_industry = industry;
    if (self.industry) {
        //UILabel* label = (UILabel*)[self viewWithTag:30001];
        //[TDUtil label:industryLabel font:industryLabel.font content:industry alignLabel:label];
        industryLabel.text = self.industry;
    }
}

-(void)setShowTime:(NSString *)showTime
{
    self->_showTime = showTime;
    if (self.showTime) {
        UILabel* label = (UILabel*)[self viewWithTag:30002];
        label.text = showTime;
        //UILabel* label = (UILabel*)[self viewWithTag:30002];
        //label.text =showTime;
        //[TDUtil label:showTimeLabel font:industryLabel.font content:showTime alignLabel:label];
    }
    
    //此项目发起于1015年3月20日 计划终止2015年8月10日
}

-(void)setLeftName:(NSString *)leftName
{
    self->_leftName = leftName;
    UILabel* label = (UILabel*)[self viewWithTag:30001];
    label.text = leftName;
    
    //[TDUtil label:label font:label.font content:leftName alignLabel:nil];
}

-(void)setRightName:(NSString *)rightName
{
    self->_rightName = rightName;
    showTimeLabel.text = rightName;
    
    //[TDUtil label:label font:label.font content:rightName alignLabel:nil];
}

-(void)setProcess:(float)process
{
    self->_process  = process;
    traceView.progress  =self.process;
}

-(void)setInvestAmout:(NSString *)investAmout
{
    self->_investAmout = investAmout;
    if(self.investAmout){
        UILabel* label = (UILabel*)[self viewWithTag:5001];
        if (label) {
            label.text = [NSString stringWithFormat:@"计划融资:%@万",self.investAmout];
        }
    }
}

-(void)setAmout:(NSString *)amout
{
    self->_amout = amout;
    if (self.amout) {
        UILabel* label = (UILabel*)[self viewWithTag:5003];
        if (label) {
            label.text  = [NSString stringWithFormat:@"已获融资:%@万",self.amout];;
        }
        
        if (self.investAmout) {
            CGFloat progress = [self.amout floatValue] / [self.investAmout floatValue];
            
            ZFProgressView * progressView = [self viewWithTag:6002];
            [progressView setProgress:progress Animated:YES];
            if (progress>1) {
                [progressView setFont:SYSTEMFONT(8)];
            }else{
                [progressView setFont:SYSTEMFONT(10)];
            }
        }
    }
}

-(void)setTinColor:(UIColor *)tinColor
{
    self->_tinColor  = tinColor;
    statusLabel.backgroundColor = tinColor;
}
            
-(void)setIsLike:(BOOL )isLike
{
    self->_isLike = isLike;
    UIImageView* imgView= (UIImageView*)[self viewWithTag:60002];
    NSString* fileName = @"";
    if (self.isLike) {
       imgSelectView = imgView;
       imgFrame = imgView.frame;
       fileName  =@"dianzan_selected";
//       [self viewAnimation:imgView salce:5];
        if (flagLike) {
            self.priserNum ++;
        }else{
            flagLike = true;
        }
    }else{
        fileName  =@"dianzan";
        if (flagLike) {
            if (self.priserNum>0) {
                self.priserNum --;
            }
        }else{
            flagLike = true;
        }
        
    }
    
    //点赞
    [currentPriseButton setImage:IMAGENAMED(fileName) forState:UIControlStateNormal];
    
}


-(void)setIsCollect:(BOOL )isCollect
{
    self->_isCollect = isCollect;
    UIImageView* imgView=(UIImageView*)[self viewWithTag:60001];
    NSString* fileName= @"";
    if (self.isCollect) {
        imgSelectView = imgView;
        imgFrame = imgView.frame;
        fileName = @"shoucang_selected";
//        [self viewAnimation:imgView salce:5];
        if (flagCollect) {
            self.collecteNum++;
        }else{
            flagCollect = true;
        }
    }else{
        fileName = @"shoucang";
        if (flagCollect) {
            if (self.collecteNum>0) {
                self.collecteNum--;
            }
        }else{
            flagCollect = true;
        }
    }
    
    //收藏
    [currentColllectButton setImage:IMAGENAMED(fileName) forState:UIControlStateNormal];
}

-(void)viewAnimation:(UIView*)view salce:(float)scale
{
    CGRect frame = view.frame;
    frame.origin.x -=scale/2;
    frame.origin.y -=scale/2;
    frame.size.width +=scale;
    frame.size.height +=scale;
    //开始动画
    [UIView beginAnimations:nil context:nil];
    //执行动画，设置动画执行时间2.0
    [UIView setAnimationDuration:1];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置动画执行完成后调用的事件
    [UIView setAnimationDidStopSelector:@selector(didStopAnimation)];
    //相反执行
    [UIView setAnimationRepeatAutoreverses:YES];
    
    [view setFrame:frame];
    
    [UIView commitAnimations];
}

-(void)setMediaUrl:(NSString *)mediaUrl
{
    self->_mediaUrl = mediaUrl;
    
    if (mediaUrl && ![mediaUrl isEqualToString:@""]) {
        self.imgPlay.alpha = 1;
    }else{
        self.imgPlay.alpha=0;
    }
}
-(void)didStopAnimation
{
    [imgSelectView setFrame:imgFrame];
}

-(void)setPriserNum:(NSInteger)priserNum
{
    self->_priserNum = priserNum;
    
    NSString * content ;
    if (priserNum<10000) {
        content = [NSString stringWithFormat:@"%ld",(long)priserNum];
    }else if(priserNum<100000000){
        content = [NSString stringWithFormat:@"%ld万",(long)priserNum/10000];
    }else{
        content = [NSString stringWithFormat:@"%ld亿",(long)priserNum/100000000];
    }
    
    [currentPriseButton setTitle:content forState:UIControlStateNormal];
}

-(void)setCollecteNum:(NSInteger)collecteNum
{
    self->_collecteNum = collecteNum;
    
    
    NSString * content ;
    if (collecteNum<10000) {
        content = [NSString stringWithFormat:@"%ld",(long)collecteNum];
    }else if(collecteNum<100000000){
        content = [NSString stringWithFormat:@"%ld万",(long)collecteNum/10000];
    }else{
        content = [NSString stringWithFormat:@"%ld亿",(long)collecteNum/100000000];
    }
    
    [currentColllectButton setTitle:content forState:UIControlStateNormal];
    
    
}

-(void)setMaxDays:(CGFloat)maxDays
{
    self->_maxDays = maxDays;
    
    if (self.maxDays!=0) {
        CGFloat progress = self.daysLeave / self.maxDays;
        
        ZFProgressView * progressView = [self viewWithTag:6001];
        [progressView setProgress:progress Animated:YES];
        
        progressView.Percentage = self.daysLeave;
        
    }
}

-(void)setEndDic:(NSMutableDictionary *)endDic
{
    self->_endDic = endDic;
    if (endDic) {
        NSString * formatStr = @"此项目%@:%@,%@:%@";
        NSString * content = [NSString stringWithFormat:formatStr,[self.startDic valueForKey:@"name"],[self.startDic valueForKey:@"datetime"],[self.endDic valueForKey:@"name"],[self.endDic valueForKey:@"datetime"]];
        [tickerView setTickerStrings:[NSArray arrayWithObject:content]];
        [tickerView start];
    }
}
@end
