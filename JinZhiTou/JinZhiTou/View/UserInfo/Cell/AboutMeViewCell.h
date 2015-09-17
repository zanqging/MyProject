//
//  UserInfoViewCellTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BedgesView.h"
@interface AboutMeViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgview;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property(assign,nonatomic)BOOL isBedgesEnabled;

-(void)setImageWithName:(NSString*)name setTitle:(NSString*)title;
@end
