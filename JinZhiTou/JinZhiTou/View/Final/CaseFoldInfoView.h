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
@interface CaseFoldInfoView : UIView
{
    UILabel * _label;
    UIView * _lineView;
    UIImageView * _iconImgView;
    UIScrollView * _scrollView;
}

@property (retain, nonatomic) NSMutableArray* dataArray;
@end
