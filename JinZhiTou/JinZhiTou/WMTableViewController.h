//
//  WMTableViewController.h
//  WMPageController
//
//  Created by Mark on 15/6/13.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMtableViewCellDelegate <NSObject>

-(void)wmTableViewController:(id)wmTableViewController tapIndexPath:(NSIndexPath*)indexPath data:(NSDictionary*)dic;

@end

@interface WMTableViewController : UITableViewController
@property(assign,nonatomic)int type;
@property(retain,nonatomic)id <WMtableViewCellDelegate>delegate;
@property (nonatomic, copy) NSNumber *age;
@property(retain,nonatomic)NSMutableArray* dataArray;
@end

