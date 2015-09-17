//
//  FinalViewController.h
//  JinZhiTou
//
//  Created by air on 15/7/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinalKindTableViewCell.h"
#import "UITableViewCustomView.h"
#import "FinalContentTableViewCell.h"
@interface FinalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(retain,nonatomic)NSMutableArray* array;
@property(retain,nonatomic) UICollectionView* collectionView;
@property (strong, nonatomic) IBOutlet UITableView *finalFunTableView;
@property (strong, nonatomic)UITableViewCustomView *finalContentTableView;

@property(retain,nonatomic)NSMutableArray* waitFinialDataArray;
@property(retain,nonatomic)NSMutableArray* finishedFinialDataArray;
@property(retain,nonatomic)NSMutableArray* thinkTankFinialDataArray;
@property(retain,nonatomic)NSMutableArray* recommendFinialDataArray;
@end
