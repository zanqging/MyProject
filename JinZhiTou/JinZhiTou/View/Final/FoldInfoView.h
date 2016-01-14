//
//  InfoFoldView.h
//  JinZhiTou
//
//  Created by air on 16/1/13.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
@interface FoldInfoView : UIView
{
    UIView* _lineView;  //分割线
    UILabel* _titleLabel; //标题标签
    UIImageView* _imgView; //图标
    UILabel* _contentLabel; //内容
}

@property (retain,nonatomic) NSMutableDictionary* dic;
@end
