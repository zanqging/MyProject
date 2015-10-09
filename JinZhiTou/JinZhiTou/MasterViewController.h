//
//  MasterViewController.h
//  SwipeableTableCell
//
//  Created by Ellen Shapiro on 1/5/14.
//  Copyright (c) 2014 Designated Nerd Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import "UITableViewCustomView.h"
@interface MasterViewController : UIViewController
@property(retain,nonatomic)NavView* navView;
@property(assign,nonatomic)NSInteger type;
@property(retain,nonatomic)NSString* titleStr;
@property(assign,nonatomic)NSInteger project_id;
@property(assign,nonatomic)BOOL isEndOfPageSize;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property (weak, nonatomic) IBOutlet UITableViewCustomView *tableView;

@end
