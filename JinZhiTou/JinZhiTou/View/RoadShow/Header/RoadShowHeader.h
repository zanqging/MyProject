//
//  RoadShowHeader.h
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface RoadShowHeader : UIView
{
    UILabel* leftLabel; //剩余进度
    UILabel* statusLabel; //状态
    UILabel* industryLabel;//行业
    UILabel* showTimeLabel; //预路演时间
    UILabel* currentTraceLabel;//当前进度
    UIImageView* currentImgView; //当前进度指示
    UILabel* currentColllectLabel;//收藏数
    UIImageView* introduceImgview;  //项目简介图片
    UILabel* currentPriseLabel; //点赞数
}
@property(assign,nonatomic)int type;
@property(assign,nonatomic)float process;
@property(assign,nonatomic)BOOL isLike;
@property(assign,nonatomic)BOOL isCollect;
@property(retain,nonatomic)UIColor* tinColor; //标签颜色
@property(retain,nonatomic)NSString* status;
@property(retain,nonatomic)NSString* leftNum;//剩余人数
@property(retain,nonatomic)NSString* amout; //预融资总额
@property(retain,nonatomic)NSString* industry;//行业
@property(retain,nonatomic)NSString* showTime; //预路演时间
@property(retain,nonatomic)NSString* mediaUrl; //视频播放url
@property(retain,nonatomic)NSString* leftName; //标签一
@property(retain,nonatomic)NSString* rightName; //标签一
@property(assign,nonatomic)NSInteger priserNum;//点赞数
@property(assign,nonatomic)NSInteger collecteNum;//收藏数
@property(retain,nonatomic)NSString* investAmout; //已获取融资
@property(retain,nonatomic)NSString* introduceImage;
@property(retain,nonatomic)UIImageView* imgPlay; //播放
@property(retain,nonatomic)UIImageView* introduceImgview;  //项目简介图片
@end
