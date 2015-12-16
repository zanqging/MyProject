//
//  WeiboData.m
//  wq
//
//  Created by weqia on 13-8-28.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "WeiboData.h"
#import "JSONKit.h"
@implementation WeiboData
@synthesize content,files,gmtCreate
,msgId,tMans,replys,tag,height,linesLimit,weiboId,uploadFailed,heightOflimit,shouldExtend,miniWidth,numberOfLineLimit,numberOfLinesTotal,willDisplay,imageHeight,replyHeight;

#pragma -mark 接口方法

+(NSString *)getPrimaryKey
{
    return @"weiboId";
}

+(NSString *)getTableName
{
    return @"WeiboData";
}

+(int)newTag
{
    static int tag=1000;
    return tag++;
}

+(NSCache*)shareCacheForWeibo;
{
    static NSCache * cache=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache=[[NSCache alloc]init];
        cache.totalCostLimit=0.1*1024*1024;
    });
    return cache;
}

-(MatchParser*)getMatch
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        _match.data=self;
        return _match;
    }else{
        NSString *key=[NSString stringWithFormat:@"%@:local=%d:content=%@",self.msgId,self.local,self.content];
        MatchParser *parser=[[WeiboData shareCacheForWeibo] objectForKey:key];
        if (parser) {
            _match=parser;
            self.height=parser.height;
            self.heightOflimit=parser.heightOflimit;
            self.miniWidth=parser.miniWidth;
            self.numberOfLinesTotal=parser.numberOfTotalLines;
            self.numberOfLineLimit=parser.numberOfLimitLines;
            parser.data=self;
            if (_match.numberOfTotalLines>_match.numberOfLimitLines) {
                self.shouldExtend=YES;
            }else{
                self.shouldExtend=NO;
            }
            return parser;
        }else{
            parser=[self createMatch:252];
            if (parser) {
                [[WeiboData shareCacheForWeibo]  setObject:parser forKey:key];
            }
            return parser;
        }
    }
}
-(MatchParser*)getMatch:(void(^)(MatchParser *parser,id data))complete data:(id)data
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        _match.data=self;
        return _match;
    }else{
        NSString *key=[NSString stringWithFormat:@"%@:local=%d:content=%@",self.msgId,self.local,self.content];
        MatchParser *parser=[[WeiboData shareCacheForWeibo] objectForKey:key];
        if (parser) {
            _match=parser;
            self.height=parser.height;
            self.heightOflimit=parser.heightOflimit;
            self.miniWidth=parser.miniWidth;
            self.numberOfLinesTotal=parser.numberOfTotalLines;
            self.numberOfLineLimit=parser.numberOfLimitLines;
            parser.data=self;
            if (_match.numberOfTotalLines>_match.numberOfLimitLines) {
                self.shouldExtend=YES;
            }else{
                self.shouldExtend=NO;
            }
            return parser;
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                MatchParser*parser=[self createMatch:252];
                if (parser) {
                    _match=parser;
                    [[WeiboData shareCacheForWeibo]  setObject:parser forKey:key];
                    if (complete) {
                        complete(parser,data);
                    }
                }
            });
            return nil;
        }
    }
}

-(void)setMatch
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        _match.data=self;
        return;
    }else{
        NSString *key=[NSString stringWithFormat:@"%@:local=%d:content=%@",self.msgId,self.local,self.content];
        MatchParser *parser=[[WeiboData shareCacheForWeibo] objectForKey:key];
        if (parser) {
            _match=parser;
            self.height=parser.height;
            self.heightOflimit=parser.heightOflimit;
            self.miniWidth=parser.miniWidth;
            self.numberOfLinesTotal=parser.numberOfTotalLines;
            self.numberOfLineLimit=parser.numberOfLimitLines;
            parser.data=self;
            if (_match.numberOfTotalLines>_match.numberOfLimitLines) {
                self.shouldExtend=YES;
            }else{
                self.shouldExtend=NO;
            }
            parser.data=self;
        }else{
            MatchParser* parser=[self createMatch:252];
            if (parser) {
                [[WeiboData shareCacheForWeibo]  setObject:parser forKey:key];
            }
        }
    }
}
-(void)setMatch:(MatchParser *)match
{
    _match=match;
}


-(MatchParser*)createMatch:(float)width
{
    MatchParser * parser=[[MatchParser alloc]init];
    parser.keyWorkColor=[UIColor blueColor];
    parser.width=width;
    parser.numberOfLimitLines=5;
    self.numberOfLineLimit=5;
    [parser match:self.content atCallBack:^BOOL(NSString * string) {
        NSString *partInStr;
        if (![tMans isKindOfClass:[NSString class]]) {
            partInStr = [tMans JSONString];
        } else {
            partInStr = (NSString*)tMans;
        }
        return NO;
    }];
    _match=parser;
    self.height=_match.height;
    self.heightOflimit=parser.heightOflimit;
    self.miniWidth=parser.miniWidth;
    self.numberOfLinesTotal=parser.numberOfTotalLines;
    parser.data=self;
    if (_match.numberOfTotalLines>_match.numberOfLimitLines) {
        self.shouldExtend=YES;
    }else{
        self.shouldExtend=NO;
    }
    return parser;
}
-(void)updateMatch:(void(^)(NSMutableAttributedString * string, NSRange range))link
{
    [_match match:self.content atCallBack:^BOOL(NSString * string) {
        NSString *partInStr;
        if (![tMans isKindOfClass:[NSString class]]) {
            partInStr = [tMans JSONString];
        } else {
            partInStr = (NSString*)tMans;
        }
        return NO;
    } title:nil link:link];
}


-(void)getWeiboReplysByType:(int)type1
{
    if (type1==1) {
        self.replys=nil;
    }else{
        static int replyId=0;
        NSMutableArray * datas=[[NSMutableArray alloc]init];
        WeiboReplyData * data=[[WeiboReplyData alloc]init];
        data.type=1;
        data.content=[NSString stringWithFormat:@"阿里巴巴网络技术有限公司（简称：阿里巴巴集团）是由曾担任英语教师的马云为首的18人，于1999年在中国杭州创立，他们相信互联网能够创造公平的竞争环境，让小企业通过创新与科技扩展业务，并在参与国内或全球市场竞争时处于更有利的位置。"];
        data.msgId=self.msgId;
        data.replyId=[NSString stringWithFormat:@"%d",replyId++];
        [data setMatch];
        [datas addObject:data];
        self.replys=datas;
    }
    
}
-(void)deleteByReplyId:(NSString*)replyId
{
}

-(void)updateRepleys
{
    
}




#pragma -mark 私有方法


@end
