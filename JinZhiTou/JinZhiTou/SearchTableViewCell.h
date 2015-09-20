//
//  SearchTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/8/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol searchTableViewCellDelegate <NSObject>
@required
-(void)searchResult:(id)sender;

@end

@interface SearchTableViewCell : UITableViewCell
@property(assign,nonatomic)NSInteger type;
@property(retain,nonatomic)NSMutableDictionary* dataDic;
@property(retain,nonatomic)id <searchTableViewCellDelegate> delegate;
@end


