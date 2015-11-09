//
//  WMTableViewController.h
//  WMPageController
//
//  Created by Mark on 15/6/13.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMTableViewController : UITableViewController
@property(assign,nonatomic)int type;
@property (nonatomic, copy) NSNumber *age;
@property(retain,nonatomic)NSMutableArray* dataArray;
@end
