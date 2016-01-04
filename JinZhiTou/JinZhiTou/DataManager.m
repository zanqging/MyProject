//
//  DataManager.m
//  CoreDataTest
//
//  Created by air on 16/1/3.
//  Copyright © 2016年 csz. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

-(id)init
{
    if (self = [super init]) {
        //从应用程序中加载数据模型
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        //传入模型对象，初始化NSPersistentStoreCoordinsator
        NSPersistentStoreCoordinator *psr =[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        //构建SQLite 数据库文件路径
        NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"model.data"]];
        //添加持久化存储库，这里使用SQLite作为存储库
        NSError* error = nil;
        NSPersistentStore * store = [psr addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
        if (!store) {
            //直接抛出异常
            NSLog(@"数据库异常");
            [NSException raise:@"添加数据库错误" format:@"%@",[error localizedDescription]];
        }
        //初始化上下文，设置NSPersistentStoreCoordinator属性
        self.context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        self.context.persistentStoreCoordinator = psr;
    }
    return self;
}

+ (DataManager*)shareInstance
{
    static DataManager* shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance  =[[self alloc]init];
    });
    return shareInstance;
}
@end
