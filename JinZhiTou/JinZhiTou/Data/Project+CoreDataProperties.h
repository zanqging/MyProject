//
//  Project+CoreDataProperties.h
//  JinZhiTou
//
//  Created by air on 16/1/3.
//  Copyright © 2016年 金指投. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Project.h"

NS_ASSUME_NONNULL_BEGIN

@interface Project (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imgUrl;
@property (nullable, nonatomic, retain) NSString *planfinance;
@property (nullable, nonatomic, retain) NSString *tag;
@property (nullable, nonatomic, retain) NSString *invest;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *company;
@property (nonatomic, assign) NSInteger projectId;

@end

NS_ASSUME_NONNULL_END
