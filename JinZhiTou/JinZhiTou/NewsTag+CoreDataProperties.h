//
//  NewsTag+CoreDataProperties.h
//  JinZhiTou
//
//  Created by air on 16/1/21.
//  Copyright © 2016年 金指投. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NewsTag.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsTag (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSSet<NewFinance *> *tag_news;

@end

@interface NewsTag (CoreDataGeneratedAccessors)

- (void)addTag_newsObject:(NewFinance *)value;
- (void)removeTag_newsObject:(NewFinance *)value;
- (void)addTag_news:(NSSet<NewFinance *> *)values;
- (void)removeTag_news:(NSSet<NewFinance *> *)values;

@end

NS_ASSUME_NONNULL_END
