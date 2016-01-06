//
//  Share+CoreDataProperties.h
//  JinZhiTou
//
//  Created by air on 16/1/5.
//  Copyright © 2016年 金指投. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Share.h"

NS_ASSUME_NONNULL_BEGIN

@interface Share (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *img;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) Cycle *cycle;
@end

NS_ASSUME_NONNULL_END
