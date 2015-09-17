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
@synthesize requestInstance;

- (id)init {
    if (self=[super init]) {
        self.requestInstance=[[ASIFormDataRequest alloc]init];
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
    
    self.requestInstance.timeOutSeconds=10;
    if (delegate) {
        requestInstance.delegate=delegate;
    }else{
        requestInstance.delegate=self;
    }
    
    if (sel) {
        [requestInstance setDidFinishSelector:sel];
    }
    if (type==1) {
        [requestInstance startSynchronous];
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
    if (postDic!=nil) {
        for (int i=0; i<postDic.count; i++) {
            NSString* key=[[postDic allKeys] objectAtIndex:i];
            NSString* value=[postDic valueForKey:key];
            [self.requestInstance setPostValue:value forKey:key];
        }
    }
    self.requestInstance.timeOutSeconds=10;
    if (delegate) {
        requestInstance.delegate=delegate;
    }else{
        requestInstance.delegate=self;
    }
    
    if (sel) {
        [requestInstance setDidFinishSelector:sel];
    }
    if (type==1) {
        [requestInstance startSynchronous];
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
    if (postDic!=nil) {
        for (int i=0; i<postDic.count; i++) {
            NSString* key=[[postDic allKeys] objectAtIndex:i];
            NSString* value=[postDic valueForKey:key];
            [self.requestInstance setPostValue:value forKey:key];
        }
    }
    self.requestInstance.timeOutSeconds=10;
    if (delegate) {
        requestInstance.delegate=delegate;
    }else{
        requestInstance.delegate=self;
    }
    
    if (type==1) {
        [requestInstance startSynchronous];
    }else{
        [self.requestInstance startAsynchronous];
        //        [requestInstance startSynchronous];
    }
    
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSError *error = [requestInstance error];
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
