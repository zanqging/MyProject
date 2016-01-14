//
//  InfoFoldView.h
//  JinZhiTou
//
//  Created by air on 16/1/13.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
@interface ComFinanceFoldInfoView : UIView
{
    UIView* _lineView;  //分割线
    UIImageView* _imgView; //图标
    UILabel* _contentLabel1; //内容
    UILabel* _contentLabel2; //内容
    UILabel* _contentLabel3; //内容
    UILabel* _contentLabel4; //内容
    
    
}

@property (retain,nonatomic) NSMutableDictionary* dic;
@end
