//
//  NewFinance+CoreDataProperties.h
//  JinZhiTou
//
//  Created by air on 16/1/21.
//  Copyright © 2016年 金指投. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NewFinance.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewFinance (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *create_datetime;
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *img;
@property (nullable, nonatomic, retain) NSNumber *read;
@property (nullable, nonatomic, retain) NSNumber *share;
@property (nullable, nonatomic, retain) NSString *src;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NewsTag *news_tag;

@end

NS_ASSUME_NONNULL_END
