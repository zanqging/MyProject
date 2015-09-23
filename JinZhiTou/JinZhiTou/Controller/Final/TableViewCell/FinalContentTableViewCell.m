//
//  FinalContentTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/7/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinalContentTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation FinalContentTableViewCell

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, frame.size.width-20,frame.size.height-10)];
        view.backgroundColor= WriteColor;
        //项目图片
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
        self.imgView.image = IMAGENAMED(@"loading");
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        self.imgView.layer.masksToBounds = YES;
        [view addSubview:self.imgView];
        [self addSubview:view];
        //名称
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+5, Y(self.imgView), 130, 21)];
        self.titleLabel.font = SYSTEMFONT(14);
        self.titleLabel.textColor = ColorTheme;
        [view addSubview:self.titleLabel];
        
        //描述
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+5, POS_Y(self.titleLabel)+15, WIDTH(self.titleLabel), 21)];
        self.contentLabel.font = SYSTEMFONT(14);
        [view addSubview:self.contentLabel];
        
        //描述
        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+5, POS_Y(self.contentLabel)+15, WIDTH(self.contentLabel), 21)];
        self.typeLabel.font = SYSTEMFONT(14);
        self.typeLabel.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [view addSubview:self.typeLabel];
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(self.typeLabel)+20, frame.size.width-20, 1)];
        imgView.backgroundColor = BackColor;
        [view addSubview:imgView];
        
        self.collecteImgView = [[UIButton alloc]initWithFrame:CGRectMake(20, POS_Y(imgView)+15, 20, 20)];
        [self.collecteImgView setImage:IMAGENAMED(@"shoucang") forState:UIControlStateNormal];
        [self.collecteImgView addTarget:self action:@selector(collecteAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.collecteImgView];
        
        self.collectDataLabelView = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.collecteImgView), Y(self.collecteImgView)-5, 40, 30)];
        self.collectDataLabelView.textAlignment = NSTextAlignmentCenter;
        self.collectDataLabelView.text = @"44";
        self.collectDataLabelView.font  =SYSTEMFONT(14);
        [view addSubview:self.collectDataLabelView];
        
        UIImageView*  imageView =[[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.collectDataLabelView)+5, Y(self.collectDataLabelView), 1, 30)];
        imageView.alpha = 0.3;
        imageView.backgroundColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [view addSubview:imageView];
        
        
        self.priseImgView = [[UIButton alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, POS_Y(imgView)+15, 20, 20)];
        [self.priseImgView setImage:IMAGENAMED(@"dianzan") forState:UIControlStateNormal];
        [self.priseImgView addTarget:self action:@selector(priseAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.priseImgView];
        
        self.priseDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.priseImgView), Y(self.priseImgView)-5, 40, 30)];
        self.priseDataLabel.textAlignment = NSTextAlignmentCenter;
        self.priseDataLabel.text = @"44";
        self.priseDataLabel.font  =SYSTEMFONT(14);
        [view addSubview:self.priseDataLabel];
        
        imageView =[[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.priseDataLabel)+5, Y(imageView), 1, 30)];
        imageView.alpha = 0.3;
        imageView.backgroundColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [view addSubview:imageView];
        
        self.voteImgView = [[UIButton alloc]initWithFrame:CGRectMake(POS_X(imageView)+20, POS_Y(imgView)+15, 20, 20)];
        [self.voteImgView setImage:IMAGENAMED(@"toupiao") forState:UIControlStateNormal];
        [self.voteImgView addTarget:self action:@selector(doActionPrise:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.voteImgView];
        
        self.voteDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.voteImgView), Y(self.voteImgView)-5, 40, 30)];
        self.voteDataLabel.textAlignment = NSTextAlignmentCenter;
        self.voteDataLabel.text = @"144";
        self.voteDataLabel.font  =SYSTEMFONT(14);
        [view addSubview:self.voteDataLabel];
//
        self.backgroundColor = BackColor;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setTitle:(NSString *)title
{
    self->_title=title;
    if (self.title) {
         self.titleLabel.text=self.title;
    }
   
}

-(void)setContent:(NSString *)content
{
    self->_content=content;
    if (self.content) {
        self.contentLabel.text=self.content;
    }
}

-(void)setTypeDescription:(NSString *)typeDescription
{
    self->_typeDescription=typeDescription;
    if (self.typeDescription) {
        self.typeLabel.text=self.typeDescription;
    }
}


-(void)setCollectionData:(NSInteger)collectionData
{
    self->_collectionData=collectionData;
    self.collectDataLabelView.text=[NSString stringWithFormat:@"%ld",(long)self.collectionData];
}

-(void)setPriseData:(NSInteger )priseData
{
    self->_priseData=priseData;
    self.priseDataLabel.text=[NSString stringWithFormat:@"%ld",(long)self.priseData];
}

-(void)setVoteData:(NSInteger)voteData
{
    self->_voteData=voteData;
    self.voteDataLabel.text=[NSString stringWithFormat:@"%ld",(long)self.voteData];
}
@end
