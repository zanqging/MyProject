//
//  RequestParam.m
//  wq
//
//  Created by berwin on 13-7-8.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "RequestParam.h"
#import "ASIFormDataRequest.h"
#import "NSStrUtil.h"
@implementation RequestParam
@synthesize strParam;
@synthesize fileParam;


//添加一个str的参数
- (void) put:(NSString *) key withValue: (NSString *) value {
    if (strParam == nil) {
        strParam = [[NSMutableDictionary alloc] init];
    }
    if([NSStrUtil notEmptyOrNull:value]){
        [strParam setValue:value forKey:key];
    }
}

//添加一个文件参数，传入文件路径
/**
 添加一个文件参数，传入文件路径
 value 可以是一个文件路径，也可以是一个NSData
 **/
- (void) putFile:(NSString *) key withValue: (id) value {
    if (fileParam == nil) {
        fileParam = [[NSMutableDictionary alloc] init];
    }
    [fileParam setValue:value forKey:key];
}



//
//// 设置将要提交的参数
//- (void) addStrParam: (ASIFormDataRequest *) request {
//    for (NSString *keys in strParam) {
//        [request setPostValue:[strParam objectForKey: keys] forKey: keys];
//    }
//}
//
//// 设置将要提交的文件
//- (void) addFileParam:(ASIFormDataRequest *) request {
//    for (NSString *keys in fileParam) {
//        id filePath = [fileParam objectForKey: keys];
//        if( [filePath isKindOfClass: [NSString class]] ){
//            // 传入的是一个文件路径
//            [request  setFile: filePath forKey: keys];
//        }else if( [filePath isKindOfClass:[NSData class]] ){
//            // 传入的是一个NSData
//            [request addData:filePath forKey: keys];
//        }
//    }
//}


@end
