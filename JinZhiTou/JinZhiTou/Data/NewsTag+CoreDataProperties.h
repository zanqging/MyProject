//
//  NewsTag+CoreDataProperties.h
//  JinZhiTou
//
//  Created by air on 16/1/4.
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

@end

NS_ASSUME_NONNULL_END
