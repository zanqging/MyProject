//
//  Banner+CoreDataProperties.h
//  JinZhiTou
//
//  Created by air on 16/1/3.
//  Copyright © 2016年 金指投. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Banner.h"

NS_ASSUME_NONNULL_BEGIN

@interface Banner (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imgUrl;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *project;

@end

NS_ASSUME_NONNULL_END
