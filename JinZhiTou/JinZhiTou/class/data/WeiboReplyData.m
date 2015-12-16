//
//  WeiboReplyData.m
//  wq8
//
//  Created by weqia on 13-9-5.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "WeiboReplyData.h"
#import "NSStrUtil.h"
@implementation WeiboReplyData
@synthesize files,gmtCreate,up_mid,msgId,replyId,content,upReplyId,atmans,height,title;

#pragma -mark 接口方法

+(NSString *)getPrimaryKey
{
    return @"replyId";
}

+(NSString *)getTableName
{
    return @"WeiboReplyData";
}
+(NSCache*)shareCacheForReply
{
    static NSCache * cache=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache=[[NSCache alloc]init];
        cache.totalCostLimit=0.3*1024*1024;
    });
    return cache;
}
-(MatchParser*)getMatch
{
    if (_match) {
        _match.data=self;
        self.height=_match.height;
        return _match;
    }
    NSString *key=[NSString stringWithFormat:@"%@+type:%d",self.content,self.type];
    MatchParser *parser=[[WeiboReplyData shareCacheForReply] objectForKey:key];
    if (parser) {
        _match=parser;
        self.height=parser.height;
        parser.data=self;
        return parser;
    }else{
        MatchParser* parser=nil;
        if (self.type==2) {
           
        }else{
            parser=[self createMatchType1];
        }
        if (parser) {
            [[WeiboReplyData shareCacheForReply]  setObject:parser forKey:key];
        }
        return parser;
    }
}
-(MatchParser*)getMatch:(void(^)(MatchParser *parser,id data))complete data:(id)data
{
    if (_match) {
        _match.data=self;
        self.height=_match.height;
        return _match;
    }
    NSString *key=[NSString stringWithFormat:@"%@+type:%d",self.content,self.type];
    MatchParser *parser=[[WeiboReplyData shareCacheForReply] objectForKey:key];
    if (parser) {
        _match=parser;
        self.height=parser.height;
        parser.data=self;
        return parser;
    }else{
        __block MatchParser* parser=nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (self.type==2) {
                
            }else{
                parser=[self createMatchType1];
            }
            if (parser) {
                _match=parser;
                [[WeiboReplyData shareCacheForReply]  setObject:parser forKey:key];
                complete(parser,data);
            }
        });
        return nil;
    }
}

-(void)setMatch
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]&&self.title!=nil&&[self.title isKindOfClass:[NSAttributedString class]]) {
        return;
    }else{
        NSString *key=[NSString stringWithFormat:@"%@+type:%d",self.content,self.type];
        MatchParser *parser=[[WeiboReplyData shareCacheForReply] objectForKey:key];
        if (parser&&self.title!=nil&&[self.title isKindOfClass:[NSAttributedString class]]) {
            _match=parser;
            self.height=parser.height;
            parser.data=self;
        }else{
            MatchParser* parser=nil;
            if (self.type==2) {
               
            }else{
                parser=[self createMatchType1];
            }
            if (parser) {
                [[WeiboReplyData shareCacheForReply]  setObject:parser forKey:key];
            }
        }
    }
}
-(void)setMatch:(MatchParser *)match
{
    _match=match;
}



-(MatchParser*)createMatchType1
{

  //  if([NSStrUtil notEmptyOrNull:self.mid]){
        
//        UIFont*font=[UIFont systemFontOfSize:13];
//        UIFont*font2=[UIFont systemFontOfSize:13];
//        CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(font.fontName),font.pointSize,NULL);
//        CTFontRef sfontRef=CTFontCreateWithName((__bridge CFStringRef)(font2.fontName),font2.pointSize,NULL);
//        NSMutableAttributedString * strings=nil;
//        strings=[[NSMutableAttributedString alloc]init];
//        ContactData *contact = [[WeqiaAppDelegate App].dbUtil searchSingle:[ContactData class]where:[NSString stringWithFormat:@"mid='%@'",self.mid]orderBy:nil];
//        if([NSStrUtil notEmptyOrNull:contact.mName]){
//            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,[UIColor colorWithIntegerValue:HEIGHT_TEXT_COLOR alpha:1].CGColor,kCTForegroundColorAttributeName,nil];
//            [strings appendAttributedString:[[NSAttributedString alloc] initWithString:contact.mName attributes:dic]];
//            if (contact) {
//                if([NSStrUtil notEmptyOrNull:self.up_mid]){
//                    ContactData *up_contact = [[WeqiaAppDelegate App].dbUtil searchSingle:[ContactData class]where:[NSString stringWithFormat:@"mid='%@'",self.up_mid] orderBy:nil];
//                    if([NSStrUtil notEmptyOrNull:up_contact.mName]){
//                        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)sfontRef,kCTFontAttributeName,[UIColor blackColor].CGColor,kCTForegroundColorAttributeName,nil];
//                        [strings appendAttributedString:[[NSAttributedString alloc] initWithString:@"回复" attributes:dic]];
//                        dic=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,[UIColor colorWithIntegerValue:HEIGHT_TEXT_COLOR alpha:1].CGColor,kCTForegroundColorAttributeName,nil];
//                        [strings appendAttributedString:[[NSAttributedString alloc] initWithString:up_contact.mName attributes:dic]];
//                    }
//                }
//            }
//        }
//        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,[UIColor blackColor].CGColor,kCTForegroundColorAttributeName,nil];
//        [strings appendAttributedString:[[NSAttributedString alloc] initWithString:@":" attributes:dic]];
//        CFRelease(fontRef);
//        CFRelease(sfontRef);
    
 //   }
    UIFont*font=[UIFont systemFontOfSize:13];
    CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(font.fontName),font.pointSize,NULL);
    NSMutableAttributedString * strings=[[NSMutableAttributedString alloc]initWithString:@"" attributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,[UIColor blueColor].CGColor,kCTForegroundColorAttributeName,nil]];
    self.title=strings;
    
    return [self createMatch:240];
}


-(MatchParser*)createMatch:(float)width
{
    if(_match==nil||![_match isKindOfClass:[MatchParser class]]){
        MatchParser * parser=[[MatchParser alloc]init];
        parser.keyWorkColor=[UIColor blueColor];
        parser.font=[UIFont systemFontOfSize:13];
        parser.width=width;
        [parser match:self.content atCallBack:^BOOL(NSString * string) {
            return NO;
        } title:self.title];
        _match=parser;
        parser.data=self;
        self.height=parser.height;
        return parser;
    }
    return nil;
}

-(void)updateMatch:(void(^)(NSMutableAttributedString * string, NSRange range))link
{
    if(_match){
        [_match match:self.content atCallBack:^BOOL(NSString * string) {

            return NO;
        } title:self.title link:link];
    }
}


@end
