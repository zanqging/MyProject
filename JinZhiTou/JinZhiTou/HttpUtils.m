//
//  self.m
//  WeiNI
//
//  Created by air on 14/11/20.
//  Copyright (c) 2014年 weini. All rights reserved.
//

#import "HttpUtils.h"
#import "TDUtil.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
@implementation HttpUtils {
    NSString* str;
}
@synthesize isRequestSuccessed;

- (id)init {
    if (self=[super init]) {
        self.requestInstance=[[ASIFormDataRequest alloc]init];
        [self.requestInstance setTimeOutSeconds:10];
    }
    return self;
}

//上传图片
- (void)getDataFromAPIWithOps:(NSString*)urlStr
        postParam:(NSDictionary*)postDic
        file:(NSString*)fileName
        postName:(NSString*)postName
        type:(NSInteger)type
        delegate:(id)delegate
        sel:(SEL)sel {
    
    str=urlStr;
    //设置请求标志
    self.isRequestSuccessed=@"NO";
    NSURL* url = [NSURL URLWithString:[SERVICE_URL stringByAppendingString:urlStr]];
    NSLog(@"上传文件:%@",url);
    self.requestInstance=[ASIFormDataRequest requestWithURL:url];
    [self.requestInstance setTimeOutSeconds:5];
    if (postDic!=nil) {
        for (int i=0; i<postDic.count; i++) {
            NSString* key=[[postDic allKeys] objectAtIndex:i];
            NSString* value=[postDic valueForKey:key];
            [self.requestInstance setPostValue:value forKey:key];
        }
    }
    NSString* filePath = [TDUtil loadContentPath:fileName];
    fileName = [fileName stringByAppendingString:@".jpg"];
    [self.requestInstance setFile:filePath withFileName:fileName andContentType:@"jpg" forKey:@"file"];
    
    if (delegate) {
        self.requestInstance.delegate=delegate;
    }else{
        self.requestInstance.delegate=self;
    }
    
    if (sel) {
        [self.requestInstance setDidFinishSelector:sel];
    }
    if (type==1) {
        [self.requestInstance startSynchronous];
    }else{
        [self.requestInstance startAsynchronous];
        //        [requestInstance startSynchronous];
    }
}

//使用字典上传图片
- (void)getDataFromAPIWithOps:(NSString*)urlStr
                    postParam:(NSDictionary*)postDic
                        files:(NSDictionary*) filesDic
                         type:(NSInteger)type
                     delegate:(id)delegate
                          sel:(SEL)sel {
    
    str=urlStr;
    //设置请求标志
    self.isRequestSuccessed=@"NO";
    NSURL* url = [NSURL URLWithString:[SERVICE_URL stringByAppendingString:urlStr]];
    NSLog(@"上传文件:%@",url);
    self.requestInstance=[ASIFormDataRequest requestWithURL:url];
    [self.requestInstance setTimeOutSeconds:5];
    if (postDic!=nil) {
        for (int i=0; i<postDic.count; i++) {
            NSString* key=[[postDic allKeys] objectAtIndex:i];
            NSString* value=[postDic valueForKey:key];
            [self.requestInstance setPostValue:value forKey:key];
        }
        [self.requestInstance setRequestMethod:@"POST"];
    }else{
        [self.requestInstance setRequestMethod:@"GET"];
    }
    
    NSString* fileName;
    NSArray * array = [filesDic allKeys];
    for (int i = 0 ; i <array.count; i++) {
        //上传用户名称
        fileName = [array objectAtIndex:i];
        //本地保存名称，用于获取本地存储路径
        NSString* filePath = [TDUtil loadContentPath:[filesDic valueForKey:fileName]];
        
//        filePath = [filePath stringByAppendingString:@".jpg"];
        NSString * uploadFileName =[[filesDic valueForKey:fileName] stringByAppendingString:@".jpg"];
        
        [self.requestInstance setFile:filePath withFileName:uploadFileName andContentType:@"jpg" forKey:fileName];
    }
    
    if (delegate) {
        self.requestInstance.delegate=delegate;
    }else{
        self.requestInstance.delegate=self;
    }
    
    if (sel) {
        [self.requestInstance setDidFinishSelector:sel];
        [self.requestInstance setDidFailSelector:sel];
    }
    if (type==1) {
        [self.requestInstance startSynchronous];
    }else{
        [self.requestInstance startAsynchronous];
        //        [requestInstance startSynchronous];
    }
    
}

//上传图片
- (void)getDataFromAPIWithOps:(NSString*)urlStr
                    postParam:(NSDictionary*)postDic
                         files:(NSMutableArray*)files
                     postName:(NSString*)postName
                         type:(NSInteger)type
                     delegate:(id)delegate
                          sel:(SEL)sel {
    
    str=urlStr;
    //设置请求标志
    self.isRequestSuccessed=@"NO";
    NSURL* url = [NSURL URLWithString:[SERVICE_URL stringByAppendingString:urlStr]];
    NSLog(@"上传文件:%@",url);
    self.requestInstance=[ASIFormDataRequest requestWithURL:url];
    [self.requestInstance setTimeOutSeconds:5];
    if (postDic!=nil) {
        for (int i=0; i<postDic.count; i++) {
            NSString* key=[[postDic allKeys] objectAtIndex:i];
            NSString* value=[postDic valueForKey:key];
            [self.requestInstance setPostValue:value forKey:key];
        }
    }
    
    NSString* fileName;
    for (int i = 0 ; i <files.count; i++) {
        fileName = [files objectAtIndex:i];
        NSString* filePath = [TDUtil loadContentPath:fileName];
        fileName = [fileName stringByAppendingString:@".jpg"];
        [self.requestInstance setFile:filePath withFileName:fileName andContentType:@"jpg" forKey:[NSString stringWithFormat:@"%@%d",postName,i]];
    }
    
    if (delegate) {
        self.requestInstance.delegate=delegate;
    }else{
        self.requestInstance.delegate=self;
    }
    
    if (sel) {
        [self.requestInstance setDidFinishSelector:sel];
    }
    if (type==1) {
        [self.requestInstance startSynchronous];
    }else{
        [self.requestInstance startAsynchronous];
        //        [requestInstance startSynchronous];
    }
    
}

- (void)getDataFromAPIWithOps:(NSString*)urlStr
        postParam:(NSDictionary*)postDic
        type:(NSInteger)type
        delegate:(id)delegate
        sel:(SEL)sel {
    
    str=urlStr;
    //设置请求标志
    self.isRequestSuccessed=@"NO";
    NSURL* url = [NSURL URLWithString:[SERVICE_URL stringByAppendingString:urlStr]];
    NSLog(@"请求地址:%@",url);
    self.requestInstance=[ASIFormDataRequest requestWithURL:url];
    [self.requestInstance setTimeOutSeconds:5];
    if (!postDic) {
        [self.requestInstance setRequestMethod:@"GET"];
    }
    if (postDic!=nil) {
        for (int i=0; i<postDic.count; i++) {
            NSString* key=[[postDic allKeys] objectAtIndex:i];
            NSString* value=[postDic valueForKey:key];
            [self.requestInstance setPostValue:value forKey:key];
        }
    }
    if (delegate) {
        self.requestInstance.delegate=delegate;
    }else{
        self.requestInstance.delegate=self;
    }
    
    if (sel) {
        [self.requestInstance setDidFinishSelector:sel];
    }
    if (type==1) {
        [self.requestInstance startSynchronous];
    }else{
        [self.requestInstance startAsynchronous];
        //        [requestInstance startSynchronous];
    }
    
}


- (void)getDataFromAPI:(NSString*)urlStr postParam:(NSDictionary*)postDic type:(NSInteger)type delegate:(id)delegate {
    str=urlStr;
    //设置请求标志
    self.isRequestSuccessed=@"NO";
    NSURL* url = [NSURL URLWithString:[SERVICE_URL stringByAppendingString:urlStr]];
    self.requestInstance=[ASIFormDataRequest requestWithURL:url];
    [self.requestInstance setTimeOutSeconds:5];
    if (!postDic) {
        [self.requestInstance setRequestMethod:@"GET"];
    }
    if (postDic!=nil) {
        for (int i=0; i<postDic.count; i++) {
            NSString* key=[[postDic allKeys] objectAtIndex:i];
            NSString* value=[postDic valueForKey:key];
            [self.requestInstance setPostValue:value forKey:key];
        }
    }
    self.requestInstance.timeOutSeconds=10;
    if (delegate) {
        self.requestInstance.delegate=delegate;
    }else{
        self.requestInstance.delegate=self;
    }
    
    if (type==1) {
        [self.requestInstance startSynchronous];
    }else{
        [self.requestInstance startAsynchronous];
        //        [requestInstance startSynchronous];
    }
    
}



- (void)getDataFromAPIWithOps:(NSString *)urlStr  type:(NSInteger)type delegate:(id)delegate sel:(SEL)sel method:(NSString *)method{
    str=urlStr;
    //设置请求标志
    self.isRequestSuccessed=@"NO";
    NSURL* url = [NSURL URLWithString:[SERVICE_URL stringByAppendingString:urlStr]];
    NSLog(@"请求地址:%@",url);
    self.requestInstance=[ASIFormDataRequest requestWithURL:url];
    self.requestInstance.timeOutSeconds=5;
    [self.requestInstance setRequestMethod:method];
    if (delegate) {
        self.requestInstance.delegate=delegate;
    }else{
        self.requestInstance.delegate=self;
    }
    
    if (sel) {
        [self.requestInstance setDidFinishSelector:sel];
    }
    if (type==1) {
        [self.requestInstance startSynchronous];
    }else{
        [self.requestInstance startAsynchronous];
        //        [requestInstance startSynchronous];
    }
}


- (void)requestFinished:(ASIHTTPRequest *)request {
    NSError *error = [self.requestInstance error];
    if (!error) {
        NSMutableDictionary* jsonDic = [request.responseString JSONValue];
        if (jsonDic!=nil) {
            self.dataDictory=jsonDic;
            self.isRequestSuccessed=@"YES";
        }else{
            self.isRequestSuccessed=@"YES";
            self.dataDictory=nil;
        }
    }else{
        self.isRequestSuccessed=@"NO";
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"请求失败!:%@",[request error]);
}

- (void)dealloc {
    
    //在回收自身的时候，取消发出的请求，当然如果是多个request，可以都放到请求队列，一并撤销。
    
    [self.requestInstance cancel];
    
    [self.requestInstance setDelegate:nil];
    
}
@end
