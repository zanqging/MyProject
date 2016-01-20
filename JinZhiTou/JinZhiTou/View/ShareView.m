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
        
        [self addShareItem:nil];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView:)]];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame isShareNews:(BOOL)isShareNews
{
    if (self = [super initWithFrame:frame]) {
        view =[[UIView alloc]initWithFrame:frame];
        view.backgroundColor = BlackColor;
        view.alpha = 0.7;
        
        [self addSubview:view];
        
        NSDictionary* dic;
        if (isShareNews) {
            dic = [[NSMutableDictionary alloc]init];
            [dic setValue:@"jinzht" forKey:@"imagename"];
            [dic setValue:@"圈子" forKey:@"title"];
        }
        [self addShareItem:dic];
        
        self.isShareNews = isShareNews;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView:)]];
    }
    return self;
}

-(void)setDic:(NSMutableDictionary *)dic
{
    self->_dic = dic;
    
}
-(void)addShareItem:(NSDictionary*)dic
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    if (dic) {
        [array addObject:dic];
    }
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"wechat" forKey:@"imagename"];
    [dic setValue:@"微信" forKey:@"title"];
    [array addObject:dic];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"cycle" forKey:@"imagename"];
    [dic setValue:@"朋友圈" forKey:@"title"];
    [array addObject:dic];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"QQ" forKey:@"imagename"];
    [dic setValue:@"QQ" forKey:@"title"];
    [array addObject:dic];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"message" forKey:@"imagename"];
    [dic setValue:@"短信" forKey:@"title"];
    [array addObject:dic];
    
    
    float h =HEIGHT(self)-100;
    float w =WIDTH(self)/(array.count*2+1);
    float pos_x=WIDTH(self)/(array.count*2+1);
    UIView* v  =[[UIView alloc]initWithFrame:CGRectMake(0, h, WIDTH(self), 100)];
    v.backgroundColor  =BackColor;
    [self addSubview:v];
    
    UIImageView* imageView;
    UILabel* label;
    for (int i=0; i<array.count; i++) {
        dic = array[i];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(pos_x-10, h+20, w+10, w+10)];
        imageView.tag = 1000+i;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share:)]];
        imageView.image =IMAGE([dic valueForKey:@"imagename"], @"png");
        [self addSubview:imageView];
        pos_x+=w*2;
        label = [[UILabel alloc]initWithFrame:CGRectMake(X(imageView)-w,POS_Y(imageView), WIDTH(imageView)*2+20, 20)];
        label.textColor = AppGrayColorTheme;
        label.textAlignment  =NSTextAlignmentCenter;
        label.text = [dic valueForKey:@"title"];
        label.font = SYSTEMBOLDFONT(15);
        [self addSubview:label];
    }
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
        NSString* url = [NEWS_SHARE stringByAppendingFormat:@"%ld/",(long)self.projectId];
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
        url =[NSURL URLWithString:[dataDic valueForKey:@"img"]];
        
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
        
        ext.webpageUrl =[dataDic valueForKey:@"url"];
        
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
        url =[NSURL URLWithString:[dataDic valueForKey:@"img"]];

        NSData* imgData = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:imgData scale:0.5];
        CGSize size=image.size;
        size.width=size.width/4;
        size.height=size.height/4;
        image=[TDUtil drawInRectImage:image size:size];
        
        [message setThumbImage:image];
        
        WXWebpageObject *ext = [WXWebpageObject object];
    
        ext.webpageUrl =[dataDic valueForKey:@"url"];
        
        message.mediaObject = ext;
        message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
        
        req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
    }
    [WXApi sendReq:req];
    
    [self closeView:nil];
}

-(void)shareQQ
{
    
    TencentOAuth *auth = [[TencentOAuth alloc] initWithAppId:@"1104722649"
                                                 andDelegate:self];
    NSLog(@"%@",auth);
//
    //分享跳转URL
    NSString *urlStr;
    urlStr =[dataDic valueForKey:@"url"];

    //分享图预览图URL地址
    NSString* content =[NSString stringWithFormat: @"%@",[dataDic valueForKey:@"content"]];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"1.jpg"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSURL* url;
    
    url =[NSURL URLWithString:[dataDic valueForKey:@"img"]];
    data = [NSData dataWithContentsOfURL:url];
    
    QQApiNewsObject *newsObj =[QQApiNewsObject objectWithURL:[NSURL URLWithString:urlStr] title:[dataDic valueForKey:@"title"] description:content previewImageData:data];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
    
//    //分享跳转URL
//    NSString *url = @"http://xxx.xxx.xxx/";
//    //分享图预览图URL地址
//    NSString *previewImageUrl = @"preImageUrl.png";
//    QQApiNewsObject *newsObj = [QQApiNewsObject
//                                objectWithURL :[NSURL URLWithString:@"http://www.baidu.com"]
//                                title: @"title"
//                                description :@"description"
//                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
//    //将内容分享到qq
//    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
//    //将内容分享到qzone
////    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
//    
//    [self handleSendResult:sent];
}


- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDSUCESS:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"分享取消" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
            
            if (!self.isShareNews) {
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
                        if (self.type==0) {
                            [self.dic setValue:@"1" forKey:@"type"];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"showMessageView" object:nil   userInfo:self.dic];
                        }else{
                            [dataDic setValue:@"2" forKey:@"type"];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"showMessageView" object:nil   userInfo:dataDic];
                        }
                        [self closeView:nil];
                        break;
                    default:
                        break;
                }
            }else{
                switch (index) {
                    case 1000:
                        //金指投圈子
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareNews" object:nil];
                        [self removeFromSuperview];
                        break;
                    case 1001:
                        //微信好友
                        [self shareWeiXin:1];
                        break;
                    case 1002:
                        //微信好友
                        [self shareWeiXin:0];
                        break;
                    case 1003:
                        //QQ分享
                        [self shareQQ];
                        break;
                    case 1004:
                        if (self.type==0) {
                            //分享项目
                            [self.dic setValue:@"1" forKey:@"type"];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"showMessageView" object:nil   userInfo:self.dic];
                        }else{
                            //分享咨询
                            [dataDic setValue:@"2" forKey:@"type"];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"showMessageView" object:nil   userInfo:dataDic];
                        }
                        [self closeView:nil];
                        break;
                    default:
                        break;
                }
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
