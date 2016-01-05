//
//  Comment+CoreDataProperties.h
//  JinZhiTou
//
//  Created by air on 16/1/5.
//  Copyright © 2016年 金指投. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface Comment (CoreDataProperties)
@property (nullable, nonatomic, retain) NSString *atName;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *photo;
@property (nullable, nonatomic, retain) NSNumber *uid;
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSNumber *flag;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) Cycle *cycle;

@end

NS_ASSUME_NONNULL_END
