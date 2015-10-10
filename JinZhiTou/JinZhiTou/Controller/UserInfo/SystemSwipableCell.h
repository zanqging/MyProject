//
//  SystemSwipableCell.h
//  JinZhiTou
//
//  Created by air on 15/10/8.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@protocol SystemSwipableCellDelegate <NSObject>
- (void)buttonOneActionForItem:(NSDictionary *)dic swipCell:(id)swipCell;
- (void)buttonTwoActionForItem:(NSDictionary *)dic swipCell:(id)swipCell;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
@end


@interface SystemSwipableCell : UITableViewCell

@property (nonatomic, strong) NSString *itemText;
@property (nonatomic, weak) id <SystemSwipableCellDelegate> delegate;
@property(nonatomic,retain)NSDictionary* dic;
@property(assign,nonatomic)BOOL isSystemMessage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (void)openCell;
- (void)closeCell;
-(void)layout;
@end
