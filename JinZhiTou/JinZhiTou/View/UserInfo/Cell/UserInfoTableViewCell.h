//
//  UserInfoViewCellTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BedgesView.h"
@interface UserInfoTableViewCell : UITableViewCell
@property(assign,nonatomic)BOOL isBedgesEnabled;

@property(retain,nonatomic)NSString* messageCount;
@property (strong, nonatomic) IBOutlet UIImageView *imgview;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

-(void)setImageWithName:(NSString*)name setTitle:(NSString*)title;
@end
