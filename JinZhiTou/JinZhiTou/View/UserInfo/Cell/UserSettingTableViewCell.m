//
//  UserSettingTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/8/7.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserSettingTableViewCell.h"

@implementation UserSettingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIsEnabled:(BOOL)isEnabled
{
    if (!isEnabled) {
        self.switchView.alpha = 0;
        self.switchView.enabled = NO;
    }else{
        
    }
}
@end
