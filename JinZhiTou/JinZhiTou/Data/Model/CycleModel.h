//
//  CycleModel.h
//  JinZhiTou
//
//  Created by air on 16/1/6.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PicModel.h"
#import "ShareModel.h"
#import "LikersModel.h"
#import "CommentModel.h"
@interface CycleModel : NSObject
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *addr;
@property (nullable, nonatomic, retain) NSNumber *flag;
@property (nullable, nonatomic, retain) NSString *photo;
@property (nullable, nonatomic, retain) NSNumber *uid;
@property (nullable, nonatomic, retain) NSNumber *is_like;
@property (nullable, nonatomic, retain) NSString *company;
@property (nullable, nonatomic, retain) ShareModel* share;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *position;
@property (nullable, nonatomic, retain) NSString *datetime;
@property (nullable, nonatomic, retain) NSNumber *remain_like;
@property (nullable, nonatomic, retain) NSSet<PicModel *> *pic;
@property (nullable, nonatomic, retain) NSNumber *remain_comment;
@property (nullable, nonatomic, retain) NSSet<LikersModel *> *likers;
@property (nullable, nonatomic, retain) NSSet<CommentModel *> *comment;

@end
