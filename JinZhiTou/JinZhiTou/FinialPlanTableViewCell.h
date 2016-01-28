//
//  FinialPlanTableViewCell.h
//  JinZhiTou
//
//  Created by air on 16/1/25.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinialPlanTableViewCell : UITableViewCell
{
    UIImageView * _iconImgView;
    UILabel * _labelTitle;
    UILabel * _labelContent;
    
    UIView * _lineSeprateView;
    UIView * _bottomLineSeprateView;
}
@property (retain, nonatomic) NSDictionary * dic;
@property (retain, nonatomic) NSString * title;
@property (retain, nonatomic) NSString * content;
@end
