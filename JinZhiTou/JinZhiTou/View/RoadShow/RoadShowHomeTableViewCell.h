//
//  RoadShowHomeTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/11/4.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoadShowHomeTableViewCell : UITableViewCell
{
    UIView* contentView;
    UIImageView* imgView;
    UILabel* labelTitle;
    UILabel* labelContent;
    UILabel* labelDateTime;
}
@property(retain,nonatomic)NSString* dateTime;
@property(retain,nonatomic)NSString* imageName;  //图片
@property(retain,nonatomic)NSString* hasFinance;
@property(retain,nonatomic)NSString* companyName; //公司名称

-(void)layerOut:(id)sender;
@end
