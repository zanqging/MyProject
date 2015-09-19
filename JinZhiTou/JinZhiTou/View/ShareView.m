//
//  ShareView.m
//  JinZhiTou
//
//  Created by air on 15/8/13.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ShareView.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
@interface  ShareView ()<ASIHTTPRequestDelegate>
{
    NSInteger index;
    NSDictionary* dataDic;
    HttpUtils* httpUtils;
    LoadingView* loadingView;
}
@end
@implementation ShareView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        view =[[UIView alloc]initWithFrame:frame];
        view.backgroundColor = BlackColor;
        view.alpha = 0.7;
        
        [self addSubview:view];
        
        [self addShareItem];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView:)]];
    }
    return self;
}

-(void)addShareItem
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSDictionary* dic;
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"weixin" forKey:@"imagename"];
    [dic setValue:@"微信" forKey:@"title"];
    [array addObject:dic];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"pengyouquan" forKey:@"imagename"];
    [dic setValue:@"朋友圈" forKey:@"title"];
    [array addObject:dic];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"QQ" forKey:@"imagename"];
    [dic setValue:@"QQ" forKey:@"title"];
    [array addObject:dic];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"mail" forKey:@"imagename"];
    [dic setValue:@"微信" forKey:@"title"];
    [array addObject:dic];
    
    float h =HEIGHT(self)-140;
    float w =(WIDTH(self)-80)/4;
    UIImageView* imageView;
    for (int i=0; i<array.count; i++) {
        dic = array[i];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i+1)*w-10, h, w-10, w-10)];
        imageView.tag = 1000+i;
        imageView.userInteractionEnabled = YES;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share:)]];
        imageView.image =IMAGENAMED([dic valueForKey:@"imagename"]);
        [self addSubview:imageView];
    }
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2-7.5, POS_Y(imageView)+45, 15, 15)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = IMAGENAMED(@"quxiao");
    [self addSubview:imageView];
}


-(void)closeView:(id)sender
{
    [self removeFromSuperview];
}

-(void)share:(UITapGestureRecognizer*)sender
{
    index = sender.view.tag;
    if (!httpUtils) {
        httpUtils = [[HttpUtils alloc]init];
    }
    
    loadingView.isTransparent = YES;
    [LoadingUtil showLoadingView:self withLoadingView:loadingView];
    if (self.type == 0) {
        NSString* url = [SHARE_PROJECT stringByAppendingFormat:@"%ld/",(long)[[self.dic valueForKey:@"id"] integerValue]];

        [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestShare:)];
    }else if(self.type == 3){
        NSString* url = [NEWS_SHARE stringByAppendingFormat:@"%d/",self.projectId];
        [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestShare:)];
    }else{
        [httpUtils getDataFromAPIWithOps:SHARE_APP postParam:nil type:0 delegate:self sel:@selector(requestShare:)];
    }
   
}
- (void)shareWeiXin:(int)type
{
    
    WXMediaMessage *message = [WXMediaMessage message];
    SendMessageToWXReq* req;
    NSString* content;
    if (type ==1) {
        
        content=[dataDic valueForKey:@"content"];
        
        message.title =[NSString stringWithFormat: @"【%@】",[dataDic valueForKey:@"title"]];
        message.description = content;
        NSURL* url;
        if (self.type==3) {
            url =[NSURL URLWithString:[dataDic valueForKey:@"src"]];
        }else{
            url =[NSURL URLWithString:[dataDic valueForKey:@"img"]];
        }
        
        NSLog(@"url:%@",url);
        NSData* imgData = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:imgData scale:0.5];
       // UIImage* image=[[UIImage alloc]init];
//        CGSize size=image.size;
//        size.width=size.width/5;
//        size.height=size.height/5;
//        image=[TDUtil drawInRectImage:image size:size];
        [message setThumbImage:image];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        
        if (self.type==3) {
            ext.webpageUrl =[dataDic valueForKey:@"href"];
        }else{
            ext.webpageUrl =[dataDic valueForKey:@"url"];
        }
        
        
        message.mediaObject = ext;
        message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
        
        req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
    }else{
        content=[dataDic valueForKey:@"content"];
        message.title =[NSString stringWithFormat: @"【%@】",[dataDic valueForKey:@"title"]];
        message.title = [message.title stringByAppendingString:content];
        message.description = @"";
        NSURL* url;
        if (self.type==3) {
            url =[NSURL URLWithString:[dataDic valueForKey:@"src"]];
        }else{
            url =[NSURL URLWithString:[dataDic valueForKey:@"img"]];
        }

        NSData* imgData = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:imgData scale:0.5];
        CGSize size=image.size;
        size.width=size.width/4;
        size.height=size.height/4;
        image=[TDUtil drawInRectImage:image size:size];
        
        [message setThumbImage:image];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        
        if (self.type==3) {
            ext.webpageUrl =[dataDic valueForKey:@"href"];
        }else{
            ext.webpageUrl =[dataDic valueForKey:@"url"];
        }
        
        message.mediaObject = ext;
        message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
        
        req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
    }
    [WXApi sendReq:req];
}

-(void)shareQQ
{
    
    TencentOAuth *auth = [[TencentOAuth alloc] initWithAppId:@"1104722649"
                                                 andDelegate:self];
    NSLog(@"%@",auth);
    
    //分享跳转URL
    NSString *urlStr;
    if (self.type==3) {
        urlStr =[dataDic valueForKey:@"href"];
    }else{
        urlStr =[dataDic valueForKey:@"url"];
    }

    //分享图预览图URL地址
    NSString* content =[NSString stringWithFormat: @"%@",[dataDic valueForKey:@"content"]];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"1.jpg"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSURL* url;
    
    if (self.type==3) {
        url =[NSURL URLWithString:[dataDic valueForKey:@"src"]];
    }else{
        url =[NSURL URLWithString:[dataDic valueForKey:@"img"]];
    }
    data = [NSData dataWithContentsOfURL:url];
    
    QQApiNewsObject *newsObj =[QQApiNewsObject objectWithURL:[NSURL URLWithString:urlStr] title:[dataDic valueForKey:@"title"] description:content previewImageData:data];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}


- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        default:
        {
            break;
        }
    }
}
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req{
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp{
    NSLog(@"%@",resp.result);
}

-(void)isOnlineResponse:(NSDictionary *)response
{
    
}

-(void)tencentDidLogin
{
    
}

-(void)tencentDidLogout
{
    
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    
}

-(void)tencentDidNotNetWork
{
    
}


-(void)requestShare:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            dataDic = [jsonDic valueForKey:@"data"];
            
            switch (index) {
                case 1000:
                    //微信好友
                    [self shareWeiXin:1];
                    break;
                case 1001:
                    //微信好友
                    [self shareWeiXin:0];
                    break;
                case 1002:
                    //QQ分享
                    [self shareQQ];
                    break;
                case 1003:
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"showMessageView" object:nil   userInfo:nil];
                    break;
                default:
                    break;
            }
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
}
@end
