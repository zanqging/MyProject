//
//  RoadShowHeader.h
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTickerView.h"
#import "UIView+SDAutoLayout.h"
#import "UIImageView+WebCache.h"
@protocol RoadShowHeaderDelegate <NSObject>

-(void)collect;
-(void)prise;
-(void)roadShowHeader:(id)roadShowHeader tapTag:(int)tag;
@end
@interface RoadShowHeader : UIView
{
    BOOL flagLike;
    BOOL flagCollect;
    JHTickerView * tickerView;  //滚动播报视图
    UILabel* leftLabel; //剩余进度
    UILabel* statusLabel; //状态
    UILabel* industryLabel;//行业
    UILabel* showTimeLabel; //预路演时间
    UILabel* currentTraceLabel;//当前进度
    UIImageView* currentImgView; //当前进度指示
    UIImageView* introduceImgview;  //项目简介图片
    
    UIButton* currentColllectButton;//收藏数
    UIButton* currentPriseButton; //点赞数
}
@property(retain, nonatomic)NSMutableDictionary* startDic;
@property(retain, nonatomic)NSMutableDictionary* endDic;
@property(assign, nonatomic)int type;
@property(assign, nonatomic)float process;
@property(assign, nonatomic)BOOL isLike;
@property(assign, nonatomic)BOOL isCollect;
@property(retain, nonatomic)UIColor* tinColor; //标签颜色
@property(retain,nonatomic)NSString* status;
@property(retain,nonatomic)NSString* amout; //预融资总额
@property(retain,nonatomic)NSString* industry;//行业
@property(retain,nonatomic)NSString* showTime; //预路演时间
@property(retain,nonatomic)NSString* mediaUrl; //视频播放url
@property(retain,nonatomic)NSString* leftName; //标签一
@property(retain,nonatomic)NSString* rightName; //标签一
@property(assign,nonatomic)NSInteger priserNum;//点赞数
@property(assign,nonatomic)NSInteger collecteNum;//收藏数
@property(retain, nonatomic)NSString* investAmout; //已获取融资
@property(assign, nonatomic)CGFloat daysLeave; //剩余天数
@property(assign, nonatomic)CGFloat maxDays; //最长期限
@property(retain,nonatomic)NSString* introduceImage;
@property(retain,nonatomic)UIImageView* imgPlay; //播放
@property(retain,nonatomic)UIImageView* introduceImgview;  //项目简介图片
@property(retain,nonatomic)id <RoadShowHeaderDelegate>delegate;
@end


