//
//  SwipeableCell.h
//  SwipeableTableCell
//
//  Created by Ellen Shapiro on 1/5/14.
//  Copyright (c) 2014 Designated Nerd Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@protocol SwipeableCellDelegate <NSObject>
- (void)buttonOneActionForItem:(NSDictionary *)dic swipCell:(id)swipCell;
- (void)buttonTwoActionForItem:(NSDictionary *)dic swipCell:(id)swipCell;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
@end


@interface SwipeableCell : UITableViewCell

@property (nonatomic, strong) NSString *itemText;
@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;
@property(nonatomic,retain)NSDictionary* dic;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

- (void)openCell;

- (void)closeCell;

@end
