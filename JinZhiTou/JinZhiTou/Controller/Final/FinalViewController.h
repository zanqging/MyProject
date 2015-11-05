//
//  FinalViewController.h
//  JinZhiTou
//
//  Created by air on 15/7/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "FinalKindTableViewCell.h"
#import "UITableViewCustomView.h"
#import "FinalContentTableViewCell.h"
@interface FinalViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(retain,nonatomic)NSMutableArray* array;
@property (strong, nonatomic)UITableView *finalFunTableView;
@property (strong, nonatomic)UITableViewCustomView *finalContentTableView;

@property(retain,nonatomic)NSMutableArray* waitFinialDataArray;
@property(retain,nonatomic)NSMutableArray* finishedFinialDataArray;
@property(retain,nonatomic)NSMutableArray* thinkTankFinialDataArray;
@property(retain,nonatomic)NSMutableArray* recommendFinialDataArray;
@end
