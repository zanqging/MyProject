//
//  Cycle.m
//  JinZhiTou
//
//  Created by air on 16/1/5.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import "Cycle.h"
#import "Comment.h"
#import "Likers.h"
#import "Pic.h"
#define  TableName @"Cycle"
@implementation Cycle
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
    for (Cycle *instance in dataArray) {
        /**
         @property (nullable, nonatomic, retain) NSNumber *id;
         @property (nullable, nonatomic, retain) NSString *position;
         @property (nullable, nonatomic, retain) NSString *datetime;
         @property (nullable, nonatomic, retain) NSString *name;
         @property (nullable, nonatomic, retain) NSNumber *is_like;
         @property (nullable, nonatomic, retain) NSString *addr;
         @property (nullable, nonatomic, retain) NSNumber *remain_comment;
         @property (nullable, nonatomic, retain) NSNumber *flag;
         @property (nullable, nonatomic, retain) NSNumber *remain_like;
         @property (nullable, nonatomic, retain) NSString *photo;
         @property (nullable, nonatomic, retain) NSNumber *uid;
         @property (nullable, nonatomic, retain) NSString *company;
         @property (nullable, nonatomic, retain) NSString *content;
         @property (nullable, nonatomic, retain) NSSet<Comment *> *comment;
         @property (nullable, nonatomic, retain) NSSet<Likers *> *likers;
         @property (nullable, nonatomic, retain) NSSet<Pic *> *pic;
         **/
        self.id = instance.id;
        self.pic = instance.pic;
        self.uid = instance.uid;
        self.name = instance.name;
        self.addr = instance.addr;
        self.flag = instance.flag;
        self.photo = instance.photo;
        self.share = instance.share;
        self.likers = instance.likers;
        self.company = instance.company;
        self.content = instance.content;
        self.comment = instance.comment;
        self.position = instance.position;
        self.datetime = instance.datetime;
        self.remain_like = instance.remain_like;
        self.remain_comment = instance.remain_comment;
        
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
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error;
    NSArray *fetchedObjects = [[DataManager shareInstance].context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (Cycle *pro in fetchedObjects) {
        if ([pro.id integerValue]!=0 && [pro.uid integerValue]!=0) {
            [resultArray addObject:pro];
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
    //    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"newsid like[cd] %@",newsId];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:[DataManager shareInstance].context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [[DataManager shareInstance].context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    //保存
    if ([[DataManager shareInstance].context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}

@end
