//
//  MenuView.h
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
typedef void (^didSelectRowAtIndexPath)(id cell, NSIndexPath *indexPath);
@interface MenuView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    NavView* navView;
    didSelectRowAtIndexPath _didSelectRowAtIndexPath;
}
+(instancetype)menuView;
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
-(void)didSelectRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath))didSelectRowAtIndexPath;
@end
