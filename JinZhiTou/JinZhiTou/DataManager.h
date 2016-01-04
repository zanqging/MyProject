//
//  DataManager.h
//  CoreDataTest
//
//  Created by air on 16/1/3.
//  Copyright © 2016年 csz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface DataManager : NSObject
@property(retain,nonatomic)NSManagedObjectContext *context;
/**
 *  单例设置
 *
 *  @return 当前实例
 */
+ (DataManager*)shareInstance;
@end
