//
//  MasterViewController.h
//  SwipeableTableCell
//
//  Created by Ellen Shapiro on 1/5/14.
//  Copyright (c) 2014 Designated Nerd Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "UITableViewCustomView.h"
@interface MasterViewController : RootViewController
@property(assign,nonatomic)NSInteger type;
@property(retain,nonatomic)NSString* titleStr;
@property(assign,nonatomic)NSInteger project_id;
@property(assign,nonatomic)BOOL isEndOfPageSize;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property (retain, nonatomic)UITableViewCustomView *tableView;

@end
