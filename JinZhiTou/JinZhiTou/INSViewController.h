//
//  INSViewController.h
//  Berlin Insomniac
//
//  Created by Salánki, Benjámin on 06/03/14.
//  Copyright (c) 2014 Berlin Insomniac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "UITableViewCustomView.h"
#import "SearchTableViewCell.h"
@interface INSViewController : RootViewController<UITableViewDataSource,UITableViewDelegate,searchTableViewCellDelegate>
{
    SearchTableViewCell* searchTableViewCell;
}
@property(retain,nonatomic)UITableViewCustomView* tableView;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property(assign,nonatomic)NSInteger type;
@property(retain,nonatomic)NSString* titleContent;
@end
