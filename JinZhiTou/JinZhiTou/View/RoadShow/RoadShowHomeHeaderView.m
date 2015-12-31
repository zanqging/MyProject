//
//  RoadShowHomeHeaderView.m
//  JinZhiTou
//
//  Created by air on 15/11/4.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "RoadShowHomeHeaderView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "INSViewController.h"
#import "BannerViewController.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "RoadShowDetailViewController.h"
@implementation RoadShowHomeHeaderView

-(id)initWithFrame:(CGRect)frame withData:(NSDictionary *)data
{
    if (self = [self initWithFrame:frame]) {
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), 150)];
        view.backgroundColor = WriteColor;
        view.tag=1000;
        [self addSubview:view];
        
        self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectInset(view.frame, 1, 1) animationDuration:2];
        self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        [view addSubview:self.mainScorllView];
        
        //新手指南
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(self.mainScorllView)+5, WIDTH(self.mainScorllView)/2, 30)];
        label.tag=1001;
        label.font=SYSTEMFONT(14);
        label.userInteractionEnabled = YES;
        label.textColor  =ColorCompanyTheme;
        label.backgroundColor  =WriteColor;
        label.userInteractionEnabled = YES;
        label.textAlignment =NSTextAlignmentCenter;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notificationAction:)]];
        [self addSubview:label];
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(label)+5, Y(label)+2, 25, 25)];
        imgView.image = IMAGENAMED(@"notice");
        [self addSubview:imgView];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label)+1, Y(label), WIDTH(label), HEIGHT(label))];
        label.tag=1002;
        label.text = @"征信查询";
        label.font=SYSTEMFONT(14);
//        label.layer.cornerRadius = 5;
//        label.layer.masksToBounds= YES;
        label.textColor  =FONT_COLOR_GRAY;
        label.backgroundColor  =WriteColor;
        label.userInteractionEnabled  =YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(creditSearchAction:)]];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(label)+10, Y(imgView)+5, 20, 20)];
        imgView.image = IMAGENAMED(@"credit");
        [self addSubview:imgView];
        
        //精选项目
        view = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(self)-30, WIDTH(self), 30)];
        view.backgroundColor = WriteColor;
        [self addSubview:view];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH(label), HEIGHT(view))];
        label.text = @"   精选项目";
        label.font=SYSTEMFONT(16);
        label.textColor  =FONT_COLOR_GRAY;
        [view addSubview:label];
        //图标

        label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label), 0, WIDTH(label)-15, HEIGHT(view))];
        label.text = @"客服热线电话";
        label.font=SYSTEMBOLDFONT(16);
        label.userInteractionEnabled  =YES;
        label.textAlignment = NSTextAlignmentRight;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callService:)]];
        label.textColor  =AppColorTheme;
        [view addSubview:label];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(label)+10, Y(label)+5, 20, 20)];
        imgView.image = IMAGENAMED(@"tel");
        [view addSubview:imgView];
        
        self.backgroundColor = BackColor;
        
        }
    return self;
}


-(void)callService:(id)sender
{
    if (!httpUtil) {
        httpUtil = [[HttpUtils alloc]init];
    }
    if (!loadingView) {
        loadingView = [LoadingUtil shareinstance:self.superview];
    }
    [LoadingUtil show:loadingView];
    loadingView.isTransparent =YES;
    [httpUtil getDataFromAPIWithOps:CUSTOMSERVICE postParam:nil type:0 delegate:self sel:@selector(requestCallService:)];
}


-(void)setDataDic:(NSMutableDictionary *)dataDic
{
    self->_dataDic = dataDic;
    NSMutableArray* dataArray = [self.dataDic valueForKey:@"banner"];
    if (dataArray) {
        self.viewsArray = [NSMutableArray new];
        
        for (int  i =0; i<dataArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self.mainScorllView))];
            imageView.backgroundColor = WriteColor;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.layer.masksToBounds = YES;
            
            NSString* fileName=[NSString stringWithFormat:@"%d",i+1];
            imageView.image =IMAGE(fileName, @"jpg");
            
            [self.viewsArray addObject:imageView];
            
            NSURL* url =[NSURL URLWithString:[dataArray[i] valueForKey:@"img"]];
            //            __block RoadShowHomeHeaderView* blockSelf =self;
            [imageView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.layer.masksToBounds = NO;
                [self.viewsArray replaceObjectAtIndex:i withObject:imageView];
            }];
        }
        __block RoadShowHomeHeaderView *instance = self;
        self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return [instance.viewsArray objectAtIndex:pageIndex];
        };
        self.mainScorllView.totalPagesCount = ^NSInteger(void){
            return [dataArray count];
        };
        
        __block RoadShowHomeHeaderView* roadShow=self;
        self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
            NSString* projectId =[dataArray[pageIndex] valueForKey:@"project"];
            if ([projectId isKindOfClass:NSNull.class]) {
                NSString* urlStr =[dataArray[pageIndex] valueForKey:@"url"];
                if (urlStr && ![urlStr isEqualToString:@""]) {
                    BannerViewController* controller =[[BannerViewController alloc]init];
                    controller.titleStr = @"金指投";
                    controller.title = @"首页";
                    controller.url =[NSURL URLWithString:urlStr];
                    if ([roadShow.delegate respondsToSelector:@selector(roadShowHome:controller:type:)]) {
                        [roadShow.delegate roadShowHome:roadShow controller:controller type:0];
                    }
                }

                
            }else{
                RoadShowDetailViewController* controller = [[RoadShowDetailViewController alloc]init];
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObject:projectId forKey:@"id"];
                controller.dic = dic;
                controller.title =@"项目";
                if ([roadShow.delegate respondsToSelector:@selector(roadShowHome:controller:type:)]) {
                    [roadShow.delegate roadShowHome:roadShow controller:controller type:0];
                }
            }
        };
        
        //公告
        UILabel* label = [self viewWithTag:1001];
        NSString* announcement = [[self.dataDic valueForKey:@"announcement"] valueForKey:@"title"];
        if ([TDUtil isValidString:announcement]) {
            label.text = [NSString stringWithFormat:@"%@",announcement];
        }
        
        //平台信息
        label =[self viewWithTag:1002];
    
        
        NSMutableArray* array =[self.dataDic valueForKey:@"platform"];
        NSDictionary* dic;
        float pos_x = 0,pos_y=POS_Y(label)+3;
        for (int i=0;i<array.count;i++) {
            dic = [array objectAtIndex:i];
            NSString* key = [dic valueForKey:@"key"];
            NSString* value = [dic valueForKey:@"value"];
            
            //成果融资额度
            label = [[UILabel alloc]initWithFrame:CGRectMake(pos_x, pos_y, WIDTH(self)/2, 25)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = ColorTheme2;
            label.backgroundColor  =WriteColor;
            label.text = [NSString stringWithFormat:@"%@",value];
            [self addSubview:label];
            
            label = [[UILabel alloc]initWithFrame:CGRectMake(pos_x, POS_Y(label)-3, WIDTH(self)/2, 25)];
            label.font = SYSTEMFONT(14);
            label.textColor = FONT_COLOR_GRAY;
            label.backgroundColor  =WriteColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [NSString stringWithFormat:@"%@",key];
            [self addSubview:label];
            if ((i+1)%2==0) {
                pos_x=0;
                pos_y+=51;
            }else{
                pos_x=WIDTH(self)/2+1;
            }
        }

    }
}

/**
 *  企业征信查询
 *
 *  @param sender sender
 */
-(void)creditSearchAction:(id)sender
{
    INSViewController* controller =[[INSViewController alloc]init];
    controller.type = 3;
    controller.title = @"首页";
    controller.titleContent = @"企业征信查询";
    if ([_delegate respondsToSelector:@selector(roadShowHome:controller:type:)]) {
        [_delegate roadShowHome:self controller:controller type:0];
    }
}

-(void)notificationAction:(id)sender
{
    BannerViewController* controller =[[BannerViewController alloc]init];
    controller.title = @"首页";
    controller.titleStr = @"公告";
    controller.url = [NSURL URLWithString:[[self.dataDic valueForKey:@"announcement"] valueForKey:@"url"]];
    if ([_delegate respondsToSelector:@selector(roadShowHome:controller:type:)]) {
        [_delegate roadShowHome:self controller:controller type:0];
    }
}


-(void)requestCallService:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSMutableArray* array =[jsonDic valueForKey:@"data"];
            NSDictionary* dic  = [array objectAtIndex:0];
            
            //获取第一个电话号码
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[dic valueForKey:@"value"]];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self addSubview:callWebview];
        }
    }
    [LoadingUtil close:loadingView];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [[DialogUtil sharedInstance]showDlg:self.superview textOnly:@"客服忙，请稍后再联系!"];
    [LoadingUtil close:loadingView];
}
@end
