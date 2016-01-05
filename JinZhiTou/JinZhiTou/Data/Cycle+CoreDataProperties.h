//
//  Cycle+CoreDataProperties.h
//  JinZhiTou
//
//  Created by air on 16/1/5.
//  Copyright © 2016年 金指投. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Cycle.h"
#import "Share.h"
NS_ASSUME_NONNULL_BEGIN

@interface Cycle (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *position;
@property (nullable, nonatomic, retain) NSString *datetime;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *is_like;
@property (nullable, nonatomic, retain) NSString *addr;
@property (nullable, nonatomic, retain) NSNumber *remain_comment;
@property (nullable, nonatomic, retain) NSNumber *flag;
@property (nullable, nonatomic, retain) NSNumber *remain_like;
@property (nullable, nonatomic, retain) NSString *photo;
@property (nullable, nonatomic, retain) NSNumber *uid;
@property (nullable, nonatomic, retain) NSString *company;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSSet<Comment *> *comment;
@property (nullable, nonatomic, retain) NSSet<Likers *> *likers;
@property (nullable, nonatomic, retain) NSSet<Pic *> *pic;
@property (nullable, nonatomic, retain) Share* share;

@end

@interface Cycle (CoreDataGeneratedAccessors)

- (void)addCommentObject:(Comment *)value;
- (void)removeCommentObject:(Comment *)value;
- (void)addComment:(NSSet<Comment *> *)values;
- (void)removeComment:(NSSet<Comment *> *)values;

- (void)addLikersObject:(Likers *)value;
- (void)removeLikersObject:(Likers *)value;
- (void)addLikers:(NSSet<Likers *> *)values;
- (void)removeLikers:(NSSet<Likers *> *)values;

- (void)addPicObject:(Pic *)value;
- (void)removePicObject:(Pic *)value;
- (void)addPic:(NSSet<Pic *> *)values;
- (void)removePic:(NSSet<Pic *> *)values;
@end

NS_ASSUME_NONNULL_END
