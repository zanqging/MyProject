//
//  HttpUtils.h
//  WeiNI
//
//  Created by air on 14/11/20.
//  Copyright (c) 2014年 weini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
@interface HttpUtils : NSObject<ASIHTTPRequestDelegate>
{
    ASIFormDataRequest* requestInstance;  //请求
}

@property(retain,nonatomic)NSString* isRequestSuccessed;
@property(retain,nonatomic)NSMutableDictionary* dataDictory;
@property(retain,nonatomic)ASIFormDataRequest* requestInstance;  //请求

-(void)getDataFromAPI:(NSString*)urlStr postParam:(NSDictionary*)postDic type:(NSInteger)type delegate:(id)delegate;
-(void)getDataFromAPIWithOps:(NSString*)urlStr postParam:(NSDictionary*)postDic type:(NSInteger)type delegate:(id)delegate sel:(SEL)sel;
-(void)getDataFromAPIWithOps:(NSString*)urlStr postParam:(NSDictionary*)postDic file:(NSString*)fileName postName:(NSString*)postName type:(NSInteger)type delegate:(id)delegate sel:(SEL)sel;
@end
