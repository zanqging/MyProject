//
//  Announcement.m
//  JinZhiTou
//
//  Created by air on 16/1/3.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import "Announcement.h"
#import "UConstants.h"
#define TableName @"Announcement"
@implementation Announcement
-(id)init
{
    self  = [NSEntityDescription  insertNewObjectForEntityForName:TableName inManagedObjectContext:[DataManager shareInstance].context];
    return self;
}

/**
 *  保存结果
 *
 *  @return 返回是否执行成功
 */
-(BOOL)save
{
    NSError *error = nil;
    BOOL scuess = [[DataManager shareInstance].context save:&error];
    if (!scuess && error) {
        [NSException raise:@"操作数据库出现错误" format:@"%@",[error localizedDescription]];
        return NO;
    }
    return YES;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray
{
    NSManagedObjectContext *context = [self managedObjectContext];
    for (NSDictionary *dic in dataArray) {
        //        Banner *bannerInfo = [NSEntityDescription insertNewObjectForEntityForName:TableName inManagedObjectContext:context];
        self.title = DICVFK(dic, @"title");
        self.url = DICVFK(dic, @"url");
        
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
    }
}

//查询
- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage
{
    
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setFetchLimit:pageSize];
    [fetchRequest setFetchOffset:currentPage];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:[DataManager shareInstance].context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [[DataManager shareInstance].context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (Announcement *pro in fetchedObjects) {
        
        if (pro.title) {
            NSMutableDictionary * dic = [NSMutableDictionary new];
            SETDICVFK(dic,@"title" , pro.title);
            SETDICVFK(dic, @"url" , pro.url);
            [resultArray addObject:dic];
        }
    }
    return resultArray;
}

//删除
-(void)deleteData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}
//更新
- (void)updateData:(NSString*)newsId  withIsLook:(NSString*)islook
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"newsid like[cd] %@",newsId];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}

@end
