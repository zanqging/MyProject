//
//  Demo9Model.h
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//


/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * 持续更新地址: https://github.com/gsdios/SDAutoLayout                              *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 *                                                                                *
 *********************************************************************************
 
 */

#import <Foundation/Foundation.h>

@interface Demo9Model : NSObject

@property (nonatomic, assign) bool isLike; //是否点赞
@property (nonatomic, assign) bool flag; //是否点赞
@property (nonatomic, assign) NSInteger id;  //id
@property (nonatomic, assign) NSInteger uid;  //uid
@property (nonatomic, copy) NSString *name;  //姓名
@property (nonatomic, copy) NSString *dateTime;  //姓名
@property (nonatomic, copy) NSString *address;//地址
@property (nonatomic, copy) NSString *position;//位置
@property (nonatomic, copy) NSString *content;//内容
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, retain) NSDictionary* shareDic;
@property (nonatomic, strong) NSArray *picNamesArray;
@property (nonatomic, strong) NSArray *likersArray;
@property (nonatomic, strong) NSArray *commentArray;

@end
