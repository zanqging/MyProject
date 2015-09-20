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
        introduceImgview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, WIDTH(self)-20, 150)];
        introduceImgview.image =IMAGENAMED(@"loading");
        introduceImgview.layer.masksToBounds = YES;
        introduceImgview.contentMode = UIViewContentModeCenter;
        [self addSubview:introduceImgview];
        
        //播放按钮
        self.imgPlay = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(introduceImgview)/2-10, HEIGHT(introduceImgview)/2-10, 40, 40)];
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
    }
    return self;
}

-(void)teamShowAction:(UITapGestureRecognizer*)sender
{
    NSInteger tag = sender.view.tag;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"teamShow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)tag],@"tag", nil]];
}

-(void)collect:(UITapGestureRecognizer*)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"collect" object:nil];
}

-(void)prise:(UITapGestureRecognizer*)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"prise" object:nil ];
}

-(void)setType:(int)type
{
    self->_type = type;
    if (self.type == 0) {
        UILabel* lbl=[[UILabel alloc]initWithFrame:CGRectMake(X(introduceImgview), POS_Y(introduceImgview)+10, 50, 21)];
        lbl.textAlignment=NSTextAlignmentLeft;
        lbl.tag = 30001;
        lbl.font=SYSTEMFONT(14);
        [self addSubview:lbl];
        //内容
        industryLabel=[[UILabel alloc]initWithFrame:CGRectMake(POS_X(lbl), Y(lbl), 80, HEIGHT(lbl))];
        industryLabel.textColor=ColorTheme;
        industryLabel.textAlignment=NSTextAlignmentLeft;
        industryLabel.font=SYSTEMFONT(14);
        industryLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:industryLabel];
        //预路演时间
        lbl=[[UILabel alloc]initWithFrame:CGRectMake(POS_X(industryLabel), Y(industryLabel), 80, HEIGHT(lbl))];
        lbl.tag = 30002;
        lbl.font=SYSTEMFONT(14);
        lbl.textAlignment=NSTextAlignmentLeft;
        lbl.font=SYSTEMFONT(14);
        [self addSubview:lbl];
        //内容
        showTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(POS_X(lbl), Y(lbl), 100, 21)];
        showTimeLabel.font=lbl.font;
        showTimeLabel.font = SYSTEMFONT(14);
        showTimeLabel.textColor=ColorTheme;
        industryLabel.adjustsFontSizeToFitWidth = YES;
        showTimeLabel.textAlignment=NSTextAlignmentLeft;
        [self addSubview:showTimeLabel];
        
        traceView = [[ProgressTraceView alloc]initWithFrame:CGRectMake(20, POS_Y(showTimeLabel), WIDTH(self)-40, 30)];
        [self addSubview:traceView];
        
        //剩余人数
        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(traceView)+10, 100, 21)];
        leftLabel.textAlignment=NSTextAlignmentLeft;
        leftLabel.font=SYSTEMFONT(14);
        leftLabel.text=@"剩余人数";
        [self addSubview:leftLabel];
        
        //点赞收藏
        UITapGestureRecognizer* recognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collect:)];
        currentPriseLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self)-60, POS_Y(leftLabel)+5, 40, 21)];
        currentPriseLabel.text=@"44";
        currentPriseLabel.adjustsFontSizeToFitWidth =YES;
        currentPriseLabel.font=SYSTEMFONT(14);
        currentPriseLabel.userInteractionEnabled  = YES;
        [currentPriseLabel addGestureRecognizer:recognizer];
        currentPriseLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:currentPriseLabel];
        
        recognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collect:)];
        UIImageView*  imageView=[[UIImageView alloc]initWithFrame:CGRectMake(X(currentPriseLabel)-20, Y(currentPriseLabel), 21, 21)];
        imageView.tag = 60001;
        imageView.image=IMAGENAMED(@"dianzan");
        imageView.userInteractionEnabled  = YES;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        //收藏
        recognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(prise:)];
        currentColllectLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(imageView)-60, Y(imageView), 40, 21)];
        currentColllectLabel.text=@"34";
        currentColllectLabel.font=SYSTEMFONT(14);
        currentColllectLabel.userInteractionEnabled  = YES;
        currentColllectLabel.adjustsFontSizeToFitWidth = YES;
        [currentColllectLabel addGestureRecognizer:recognizer];
        currentColllectLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:currentColllectLabel];
        
        recognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(prise:)];
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(X(currentColllectLabel)-25, Y(currentColllectLabel), 21, 21)];
        imageView.tag =60002;
        imageView.image=IMAGENAMED(@"shoucang");
        imageView.userInteractionEnabled  = YES;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        
        UIImageView* imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(imageView)+5, WIDTH(self), 1)];
        imgview.backgroundColor = BackColor;
        [self addSubview:imgview];
        
        float w =WIDTH(self)/4;
        float h =POS_Y(imgview)+10;

        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        //核心团队
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w*3/2-40, h, 25, 25)];
        imageView.tag = 10005;
        imageView.userInteractionEnabled=YES;
        imageView.image=IMAGENAMED(@"team");
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(X(imageView)-20, POS_Y(imageView)+5, 70, 21)];
        lbl.text = @"核心团队";
        lbl.tag = 10005;
        lbl.font = SYSTEMFONT(14);
        lbl.userInteractionEnabled=YES;
        [lbl addGestureRecognizer:recognizer];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
        
        
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(w*2, Y(imageView), 1, 60)];
        imageView.backgroundColor = BACKGROUND_GRAY_COLOR;
        [self addSubview:imageView];
        
        //互动专栏
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w*5/2+15, h, 25, 25)];
        imageView.tag = 10006;
        imageView.userInteractionEnabled=YES;
        [imageView addGestureRecognizer:recognizer];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image=IMAGENAMED(@"Interactive");
        [self addSubview:imageView];
        
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(X(imageView)-20, POS_Y(imageView)+5, 70, 21)];
        lbl.text = @"互动专栏";
        lbl.tag = 10006;
        lbl.font = SYSTEMFONT(14);
        lbl.userInteractionEnabled = YES;
        [lbl addGestureRecognizer:recognizer];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];

    }else{
        //行业
        UILabel* lbl=[[UILabel alloc]initWithFrame:CGRectMake(X(introduceImgview), POS_Y(introduceImgview)+10, 50, 21)];
        lbl.textAlignment=NSTextAlignmentLeft;
        lbl.tag = 30001;
        lbl.font=SYSTEMFONT(14);
        [self addSubview:lbl];
        //内容
        industryLabel=[[UILabel alloc]initWithFrame:CGRectMake(POS_X(lbl)+5, Y(lbl), 80, HEIGHT(lbl))];
        industryLabel.textColor=ColorTheme;
        industryLabel.textAlignment=NSTextAlignmentLeft;
        industryLabel.font=SYSTEMFONT(10);
        [self addSubview:industryLabel];
        //预路演时间
        lbl=[[UILabel alloc]initWithFrame:CGRectMake(POS_X(industryLabel), Y(industryLabel), 90, HEIGHT(lbl))];
        lbl.tag = 30002;
        lbl.font=SYSTEMFONT(14);
        lbl.textAlignment=NSTextAlignmentLeft;
        lbl.font= SYSTEMFONT(14);
        [self addSubview:lbl];
        //内容
        showTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(POS_X(lbl)-15, Y(lbl), 100, 21)];
        showTimeLabel.font=lbl.font;
        showTimeLabel.font = SYSTEMFONT(10);
        showTimeLabel.textColor=ColorTheme;
        showTimeLabel.textAlignment=NSTextAlignmentLeft;
        [self addSubview:showTimeLabel];
        
        
        traceView = [[ProgressTraceView alloc]initWithFrame:CGRectMake(20, POS_Y(showTimeLabel), WIDTH(self)-40, 30)];
        [self addSubview:traceView];
        
        //已获取融资
        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(traceView)+20, WIDTH(self)/3, 21)];
        leftLabel.textAlignment=NSTextAlignmentCenter;
        leftLabel.font=SYSTEMFONT(14);
        leftLabel.text=@"0万";
        leftLabel.tag = 5001;
        [self addSubview:leftLabel];
        
        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(leftLabel), POS_Y(leftLabel), WIDTH(leftLabel), 21)];
        leftLabel.textAlignment=NSTextAlignmentCenter;
        leftLabel.font=SYSTEMFONT(14);
        leftLabel.text=@"已获融资";
        [self addSubview:leftLabel];
        
        //融资状态
        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self)/3, POS_Y(traceView)+20, WIDTH(self)/3, 21)];
        leftLabel.textAlignment=NSTextAlignmentCenter;
        leftLabel.font=SYSTEMFONT(14);
        leftLabel.text=@"融资中";
        leftLabel.tag = 5002;
        [self addSubview:leftLabel];
        
        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(leftLabel), POS_Y(leftLabel), WIDTH(leftLabel), 21)];
        leftLabel.textAlignment=NSTextAlignmentCenter;
        leftLabel.font=SYSTEMFONT(14);
        leftLabel.text=@"融资状态";
        [self addSubview:leftLabel];
        
        //预融资总额
        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self)*2/3, POS_Y(traceView)+20, WIDTH(self)/3, 21)];
        leftLabel.textAlignment=NSTextAlignmentCenter;
        leftLabel.font=SYSTEMFONT(14);
        leftLabel.text=@"0万";
        leftLabel.tag = 5003;
        [self addSubview:leftLabel];
        
        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(leftLabel), POS_Y(leftLabel), WIDTH(leftLabel), 21)];
        leftLabel.textAlignment=NSTextAlignmentCenter;
        leftLabel.font=SYSTEMFONT(14);
        leftLabel.text=@"预融资总额";
        [self addSubview:leftLabel];
        
        //点赞收藏
        UITapGestureRecognizer* recognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collect:)];
        currentPriseLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self)-60, POS_Y(leftLabel)+15, 40, 21)];
        currentPriseLabel.font=SYSTEMFONT(14);
        currentPriseLabel.userInteractionEnabled  = YES;
        currentPriseLabel.adjustsFontSizeToFitWidth  =YES;
        [currentPriseLabel addGestureRecognizer:recognizer];
        currentPriseLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:currentPriseLabel];
        
        recognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collect:)];
        UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(X(currentPriseLabel)-20, Y(currentPriseLabel), 21, 21)];
        imageView.tag = 60001;
        imageView.image=IMAGENAMED(@"dianzan");
        imageView.userInteractionEnabled  = YES;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        //收藏
        recognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(prise:)];
        currentColllectLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(imageView)-60, Y(imageView), 40, 21)];
        currentColllectLabel.font=SYSTEMFONT(14);
        currentColllectLabel.adjustsFontSizeToFitWidth  =YES;
        currentColllectLabel.userInteractionEnabled  = YES;
        [currentColllectLabel addGestureRecognizer:recognizer];
        currentColllectLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:currentColllectLabel];
        
        recognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(prise:)];
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(X(currentColllectLabel)-25, Y(currentColllectLabel), 21, 21)];
        imageView.tag =60002;
        imageView.image=IMAGENAMED(@"shoucang");
        imageView.userInteractionEnabled  = YES;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        UIImageView* imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(imageView)+20, WIDTH(self), 1)];
        imgview.backgroundColor = BackColor;
        [self addSubview:imgview];
        
        float w =WIDTH(self)/4;
        float h =POS_Y(imgview)+20;
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        //融资计划
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w/2-12.5, h, 25, 25)];
        imageView.tag = 10001;
        imageView.userInteractionEnabled=YES;
        imageView.image=IMAGENAMED(@"Plan");
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(X(imageView)-20, POS_Y(imageView)+5, 70, 21)];
        lbl.text = @"融资计划";
        lbl.tag = 10002;
        lbl.font = SYSTEMFONT(14);
        lbl.userInteractionEnabled=YES;
        [lbl addGestureRecognizer:recognizer];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
        
        
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(w, Y(imageView), 1, 60)];
        imageView.backgroundColor = BACKGROUND_GRAY_COLOR;
        [self addSubview:imageView];
        
        //投资列表
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w*3/2-12.5, h, 25, 25)];
        imageView.tag = 10003;
        imageView.userInteractionEnabled=YES;
        imageView.image=IMAGENAMED(@"list");
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(X(imageView)-20, POS_Y(imageView)+5, 70, 21)];
        lbl.text = @"投资列表";
        lbl.tag = 10004;
        lbl.font = SYSTEMFONT(14);
        lbl.userInteractionEnabled=YES;
        [lbl addGestureRecognizer:recognizer];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
        
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(w*2, Y(imageView), 1, 60)];
        imageView.backgroundColor = BACKGROUND_GRAY_COLOR;
        [self addSubview:imageView];
        
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        //核心团队
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w*5/2-12.5, h, 25, 25)];
        imageView.tag = 10005;
        imageView.userInteractionEnabled=YES;
        imageView.image=IMAGENAMED(@"team");
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(X(imageView)-20, POS_Y(imageView)+5, 70, 21)];
        lbl.text = @"核心团队";
        lbl.tag = 10005;
        lbl.font = SYSTEMFONT(14);
        lbl.userInteractionEnabled=YES;
        [lbl addGestureRecognizer:recognizer];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
        
        
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(w*3, Y(imageView), 1, 60)];
        imageView.backgroundColor = BACKGROUND_GRAY_COLOR;
        [self addSubview:imageView];
        
        //互动专栏
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w*7/2-12.5, h, 25, 25)];
        imageView.tag = 10006;
        imageView.userInteractionEnabled=YES;
        [imageView addGestureRecognizer:recognizer];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image=IMAGENAMED(@"Interactive");
        [self addSubview:imageView];
        
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teamShowAction:)];
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(X(imageView)-20, POS_Y(imageView)+5, 70, 21)];
        lbl.text = @"互动专栏";
        lbl.tag = 10006;
        lbl.font = SYSTEMFONT(14);
        lbl.userInteractionEnabled = YES;
        [lbl addGestureRecognizer:recognizer];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
    }
}

-(void)setIntroduceImage:(NSString *)introduceImage
{
    self->_introduceImage = introduceImage;
    if (self.introduceImage) {
        NSURL * url = [NSURL URLWithString:self.introduceImage];
        
        [introduceImgview sd_setImageWithURL:url placeholderImage:introduceImgview.image];
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
        UILabel* label = (UILabel*)[self viewWithTag:30001];
        [TDUtil label:industryLabel font:industryLabel.font content:industry alignLabel:label];
        //industryLabel.text = self.industry;
    }
}

-(void)setShowTime:(NSString *)showTime
{
    self->_showTime = showTime;
    if (self.showTime) {
        //showTimeLabel.text = self.showTime;
        UILabel* label = (UILabel*)[self viewWithTag:30002];
        [TDUtil label:showTimeLabel font:industryLabel.font content:showTime alignLabel:label];
    }
}

-(void)setLeftName:(NSString *)leftName
{
    self->_leftName = leftName;
    UILabel* label = (UILabel*)[self viewWithTag:30001];
    [TDUtil label:label font:label.font content:leftName alignLabel:nil];
}

-(void)setRightName:(NSString *)rightName
{
    self->_rightName = rightName;
     UILabel* label = (UILabel*)[self viewWithTag:30002];
    [TDUtil label:label font:label.font content:rightName alignLabel:nil];
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
            label.text = [NSString stringWithFormat:@"%@万",self.investAmout];
        }
    }
}

-(void)setAmout:(NSString *)amout
{
    self->_amout = amout;
    if (self.amout) {
        UILabel* label = (UILabel*)[self viewWithTag:5003];
        if (label) {
            label.text  = [NSString stringWithFormat:@"%@万",self.amout];;
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
       [self viewAnimation:imgView salce:5];
    }else{
        fileName  =@"dianzan";
    }
    
    imgView.image = IMAGENAMED(fileName);
    
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
        [self viewAnimation:imgView salce:5];
    }else{
        fileName = @"shoucang";
    }
    
    imgView.image = IMAGENAMED(fileName);
    
}

-(void)setLeftNum:(NSString *)leftNum
{
    if (self.type==0) {
        if (leftNum) {
            self->_leftName  = leftNum;
            leftLabel.text = [NSString stringWithFormat:@"剩余人数:%@人",leftNum];
        }
    }
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
    currentPriseLabel.text = [NSString stringWithFormat:@"%ld",(long)priserNum];
}

-(void)setCollecteNum:(NSInteger)collecteNum
{
    self->_collecteNum = collecteNum;
    currentColllectLabel.text = [NSString stringWithFormat:@"%ld",(long)collecteNum];
}
@end
