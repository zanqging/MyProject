//
//  NewsTag.h
//  JinZhiTou
//
//  Created by air on 16/1/21.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NewFinance;

NS_ASSUME_NONNULL_BEGIN

@interface NewsTag : NSManagedObject

/**
*  保存结果
*
*  @return 返回是否执行成功
*/
-(BOOL)save;

- (void)saveContext;
//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray;
//查询
- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage;
//删除
- (void)deleteData;
//更新
- (void)updateData:(NSString*)newsId withDic:(NSDictionary*)dic;
//更新
- (NSMutableArray *)selectData:(int)pageSize andOffset:(int)currentPage newId:(NSInteger)newId;

@end

NS_ASSUME_NONNULL_END

#import "NewsTag+CoreDataProperties.h"
