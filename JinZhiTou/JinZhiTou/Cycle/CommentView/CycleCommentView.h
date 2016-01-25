//
//  CycleCommentView.h
//  JinZhiTou
//
//  Created by air on 15/1/1.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@protocol CycleCommentDelegate <NSObject>

-(void)cycleComment:(id)cycleComment contentId:(NSString*)contentId atId:(NSString*)atId isSelf:(BOOL)isSelf;

-(void)cycleComment:(id)cycleComment deleteId:(NSString*)deleteId;

-(void)cycleComment:(id)cycleComment refresh:(BOOL) refresh data:(NSArray*) dataArray;

@end

@interface CycleCommentView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView * _bgImgView;   //背景图片
    UIImageView * _iconImgView;   //点赞icon
    UILabel * _labelPrise;   //点赞视图
    UIView * _lineView;    //分割线
    
    float height; //高度
    
}
@property (retain, nonatomic) UITableView * tableView; //UITableView
@property (retain, nonatomic) NSDictionary * dic; //数据字典
@property (retain, nonatomic) NSArray * likersDataArray;
@property (retain, nonatomic) NSArray * commentDataArray;
@property (retain, nonatomic) id<CycleCommentDelegate> delegate;

@end
