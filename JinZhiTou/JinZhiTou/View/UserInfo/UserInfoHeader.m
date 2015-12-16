//
//  UserInfoHeader.m
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserInfoHeader.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
@implementation UserInfoHeader
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView* imgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self)*3/4)];
        imgView.image = IMAGENAMED(@"gerenzhongxin-89");
        imgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:imgView];
        
        UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0,HEIGHT(self)*2/3-20, WIDTH(self), 40)];
        view.backgroundColor  =BlackColor;
        view.alpha =0.8;
        [self addSubview:view];
        
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, HEIGHT(self)*2/3-20, 70, 70)];
        imgView.tag = 20001;
        imgView.layer.borderWidth=2;
        imgView.layer.cornerRadius=35;
        imgView.layer.masksToBounds = YES;
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upLoad:)]];
        imgView.layer.borderColor= WriteColor.CGColor;
        [self addSubview:imgView];
        
      
        
        UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+10, Y(imgView)+10, 70, 20)];
        lable.tag = 10002;
        lable.font = SYSTEMFONT(16);
        lable.textColor = WriteColor;
        [self addSubview:lable];
        
        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(modifyInfo:)];
        lable = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(lable)+5, Y(lable), 70, 20)];
        lable.tag=10003;
        lable.text = @"[修改资料]";
        lable.font = SYSTEMFONT(14);
        lable.textColor = WriteColor;
        lable.userInteractionEnabled = YES;
        [lable addGestureRecognizer:recognizer];
        [self addSubview:lable];
        self.backgroundColor = WriteColor;
        
        httpUtil = [[HttpUtils alloc]init];
        //加载数据
        [self requestData:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUserPic:) name:@"changeUserPic" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData:) name:@"reloadData" object:nil];
    }
    return self;
}

-(void)requestData:(id)sender
{
    [httpUtil getDataFromAPIWithOps:LEFT_SLIDE type:0 delegate:self sel:@selector(requestUserInfo:) method:@"GET"];
}
-(void)changeUserPic:(NSDictionary*)dic
{
    UIImage* img = [[dic valueForKey:@"userInfo"] valueForKey:@"img"];
    if (img) {
        UIImageView* imgView = (UIImageView*)[self viewWithTag:20001];
        imgView.image = img;
    }
}

-(void)requestUserInfo:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0 || [code intValue] == -1) {
            UILabel* label = (UILabel*)[self viewWithTag:10002];
            NSDictionary* dic = [jsonDic valueForKey:@"data"];
            NSString* name = [dic valueForKey:@"nickname"];
            
            label.text = name;
            [TDUtil setLabelMutableText:label content:name lineSpacing:0 headIndent:0];
            
            
            NSString* str = [dic valueForKey:@"photo"];
            
            //本地缓存数据
            NSUserDefaults* dataStore  = [NSUserDefaults standardUserDefaults];
            [dataStore setValue:name forKey:@"name"];
            [dataStore setValue:str forKey:@"photo"];

            if (str && str.class !=NSNull.class) {
                NSURL* url = [NSURL URLWithString:str];
                //头像图片
                UIImageView* imgView = (UIImageView*)[self viewWithTag:20001];
                UIImage* img = [TDUtil loadContent:USER_STATIC_HEADER_PIC];
                [imgView sd_setImageWithURL:url placeholderImage:img completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [TDUtil saveContent:image fileName:USER_STATIC_HEADER_PIC];
                }];
            }
            
        }
    }
}
-(void)modifyInfo:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"modifyUserInfo" object:nil];
}


-(void)upLoad:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"upLoad" object:nil];
}

@end
