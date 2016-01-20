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

@property(retain,nonatomic)NSString* isRequestSuccessed;
@property(retain,nonatomic)NSMutableDictionary* dataDictory;
@property(retain,nonatomic)ASIFormDataRequest* requestInstance;  //请求

-(void)getDataFromAPI:(NSString*)urlStr postParam:(NSDictionary*)postDic type:(NSInteger)type delegate:(id)delegate;
-(void)getDataFromAPIWithOps:(NSString*)urlStr postParam:(NSDictionary*)postDic type:(NSInteger)type delegate:(id)delegate sel:(SEL)sel;
-(void)getDataFromAPIWithOps:(NSString*)urlStr type:(NSInteger)type delegate:(id)delegate sel:(SEL)sel method:(NSString*)method;
-(void)getDataFromAPIWithOps:(NSString*)urlStr postParam:(NSDictionary*)postDic file:(NSString*)fileName postName:(NSString*)postName type:(NSInteger)type delegate:(id)delegate sel:(SEL)sel;

- (void)getDataFromAPIWithOps:(NSString*)urlStr
                    postParam:(NSDictionary*)postDic
                        files:(NSMutableArray*)files
                     postName:(NSString*)postName
                         type:(NSInteger)type
                     delegate:(id)delegate
                          sel:(SEL)sel;

/**
 *  使用字典存储 key: 接口所需文件名称，value:本地存储文件名称，用于获取文件在本地路径
 *
 *  @param urlStr   请求地址
 *  @param postDic  传参数
 *  @param filesDic 文件字典
 *  @param type     网络请求类型
 *  @param delegate 代理
 *  @param sel      执行方法
 */
- (void)getDataFromAPIWithOps:(NSString*)urlStr
                    postParam:(NSDictionary*)postDic
                        files:(NSDictionary*) filesDic
                         type:(NSInteger)type
                     delegate:(id)delegate
                          sel:(SEL)sel;
@end
