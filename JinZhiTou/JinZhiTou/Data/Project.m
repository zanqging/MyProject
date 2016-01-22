//
//  Project.m
//  JinZhiTou
//
//  Created by air on 16/1/3.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import "Project.h"
#define TableName @"Project"
@implementation Project

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
//    NSManagedObjectContext *context = [self managedObjectContext];
    for (NSDictionary * dic in dataArray) {
        Project * project = [[Project alloc]init];
        
        project.tag = DICVFK(dic, @"tag");
        project.date  = DICVFK(dic, @"date");
        project.imgUrl = DICVFK(dic, @"img");
        project.company = DICVFK(dic, @"company");
        project.projectId = [DICVFK(dic, @"id") integerValue];
        project.invest = [NSString stringWithFormat:@"%@",DICVFK(dic, @"invest")];
        project.planfinance  = [NSString stringWithFormat:@"%@",DICVFK(dic, @"planfinance")];
        
        NSError *error;
        if(![[DataManager shareInstance].context save:&error])
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
    
    for (NSDictionary *dic in fetchedObjects) {
        
        if (DICVFK(dic, @"imgUrl")) {
            NSMutableDictionary * data = [NSMutableDictionary new];
            SETDICVFK(data,@"tag",DICVFK(dic, @"tag"));
            SETDICVFK(data,@"date",DICVFK(dic, @"date"));
            SETDICVFK(data,@"img",DICVFK(dic, @"imgUrl"));
            SETDICVFK(data,@"company",DICVFK(dic, @"company"));
            SETDICVFK(data,@"id",STRING(@"%@",DICVFK(dic, @"projectId")));
            SETDICVFK(data,@"invest",STRING(@"%@",DICVFK(dic, @"invest")));
            SETDICVFK(data,@"planfinance",STRING(@"%@", DICVFK(dic, @"planfinance")));
            [resultArray addObject:data];
        }
    }
    return resultArray;
}

//删除
-(void)deleteData
{
//    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:[DataManager shareInstance].context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [[DataManager shareInstance].context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [[DataManager shareInstance].context deleteObject:obj];
        }
        if (![[DataManager shareInstance].context save:&error])
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
    //NSError *error = nil;
    //NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    //保存
//    if ([context save:&error]) {
//        //更新成功
//        NSLog(@"更新成功");
//    }
}

@end
