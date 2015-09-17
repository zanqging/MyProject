//
//  WeiboReplyData.h
//  wq8
//
//  Created by weqia on 13-9-5.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Jastor.h"
#import "MatchParser.h"
@interface WeiboReplyData : Jastor<MatchParserDelegate>
{
    __weak MatchParser * _match;
}
@property(nonatomic,strong) NSString * files;
@property(nonatomic,strong) NSString * gmtCreate;
@property(nonatomic,strong) NSString * up_mid;
@property(nonatomic,strong) NSString * msgId;
@property(nonatomic,strong) NSString * replyId;
@property(nonatomic,strong) NSString * content;
@property(nonatomic,strong) NSString * upReplyId;
@property(nonatomic,strong) NSString * atmans;

@property(nonatomic) float height;
@property(nonatomic,strong) NSAttributedString * title;
@property(nonatomic,weak,getter = getMatch,setter = setMatch:) MatchParser * match;
@property(nonatomic) int type;

-(MatchParser*)createMatchType1;
-(void)setMatch;
-(void)updateMatch:(void(^)(NSMutableAttributedString * string, NSRange range))link;

+(NSCache*)shareCacheForReply;

@end
