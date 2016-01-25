//
//  CycleHeader.m
//  JinZhiTou
//
//  Created by air on 15/10/22.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "CycleHeader.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import <QuartzCore/QuartzCore.h>
@implementation CycleHeader
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = WriteColor;
        
        self.headerBackView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-20)];
        self.headerBackView.backgroundColor = BackColor;
        self.headerBackView.image =[TDUtil loadContent:USER_STATIC_CYCLE_BG];
        self.headerBackView.layer.masksToBounds  =YES;
        self.headerBackView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.headerBackView];
        
        self.headerView  =[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)-90, HEIGHT(self)-70, 70, 70)];
        UIImage* image =[TDUtil loadContent:USER_STATIC_HEADER_PIC];
        if (!image) {
            image = IMAGENAMED(@"coremember");
        }
        self.headerView.image  =image;
        self.headerView.layer.borderColor = WriteColor.CGColor;
        self.headerView.layer.borderWidth = 2;
        self.headerView.contentMode  =UIViewContentModeScaleToFill;
        [self addSubview:self.headerView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y(self.headerView)+10, WIDTH(self)-100, 21)];
        self.nameLabel.textColor  = WriteColor;
        self.nameLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.nameLabel];
        
        [self loadData];
        
        //添加更改
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"changePic" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUserPic:) name:@"changeUserPic" object:nil];
        
    }
    return self;
}

-(void)changeUserPic:(NSDictionary*)dic
{
    UIImage* img = [[dic valueForKey:@"userInfo"] valueForKey:@"img"];
    if (img) {
        self.headerView.image = img;
    }
}


-(void)loadData
{
    httpUtils =[[HttpUtils alloc]init];
    [httpUtils getDataFromAPIWithOps:CYCLE_CONTENT_BACKGROUND_UPLOAD type:0 delegate:self sel:@selector(requestFinished:) method:@"GET"];
}

-(void)requestFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* code = [dic valueForKey:@"code"];
        if ([code integerValue] ==0) {
            NSDictionary* data = [dic valueForKey:@"data"];
            [self.headerBackView sd_setImageWithURL:[NSURL URLWithString:[data valueForKey:@"bg"]] placeholderImage:[TDUtil loadContent:USER_STATIC_CYCLE_BG] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    [TDUtil saveCameraPicture:image fileName:USER_STATIC_CYCLE_BG];
                }
            }];
            [self.headerView sd_setImageWithURL:[NSURL URLWithString:[data valueForKey:@"photo"]]placeholderImage:[TDUtil loadContent:USER_STATIC_HEADER_PIC] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    [TDUtil saveCameraPicture:image fileName:USER_STATIC_HEADER_PIC];
                }
            }];
            //移除重新加载数据
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
        }else if ([code intValue]==-1){
            //添加重新加载数据监听
             [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"reloadData" object:nil];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
}
@end
