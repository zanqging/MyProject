//
//  WeiboTableViewCell.h
//  Cycle
//
//  Created by air on 15/10/12.
//  Copyright © 2015年 csz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pic+CoreDataProperties.h"
#import "Share+CoreDataProperties.h"
#import "Cycle+CoreDataProperties.h"
#import "Likers+CoreDataProperties.h"
#import "Comment+CoreDataProperties.h"
#import "HttpUtils.h"
#import "MWPhotoBrowser.h"
#import "UIImageView+WebCache.h"

@protocol WeiboTableViewCellDelegate <NSObject>

-(void)weiboTableViewCell:(id)weiboTableViewCell refresh:(BOOL)refresh;
-(void)weiboTableViewCell:(id)weiboTableViewCell deleteDic:(Cycle*) cycle;
-(void)weiboTableViewCell:(id)weiboTableViewCell priseDic:(NSDictionary*)dic msg:(NSString*)msg;
-(void)weiboTableViewCell:(id)weiboTableViewCell userId:(NSString*)userId isSelf:(BOOL) isSelf;
-(void)weiboTableViewCell:(id)weiboTableViewCell contentId:(NSString*)contentId atId:(NSString*)atId isSelf:(BOOL) isSelf;
-(void)weiboTableViewCell:(id)weiboTableViewCell didSelectedContent:(BOOL)isSelected;
-(void)weiboTableViewCell:(id)weiboTableViewCell didSelectedShareContentUrl:(NSURL*)urlStr;

@end

@interface WeiboTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate,UIAlertViewDelegate>
{
    HttpUtils* httpUtils;
    NSMutableArray *_selections;
    int currentTag; //当前删除模式
    NSIndexPath* currentSelectedCellIndex;
}
@property (retain, nonatomic)  UITableView *tableView;

@property (retain, nonatomic)  Cycle* cycle;
@property(retain,nonatomic)NSString* topId;
@property (retain, nonatomic)  UIView *funView;
@property (retain, nonatomic)  UIView *priseView; //点赞区域
@property (retain, nonatomic)  UILabel *nameLabel;
@property(retain,nonatomic)    UIButton* priseButton;
@property(retain,nonatomic)    MWPhotoBrowser *browser;
@property (nonatomic, retain)  NSMutableArray *photos;
@property (nonatomic, retain)  NSMutableArray *thumbs;
@property (retain, nonatomic)  UILabel *companyLabel;
@property (retain, nonatomic)  UILabel *dateTimeLabel;
@property (nonatomic, retain)  NSMutableArray *assets;
@property (retain, nonatomic)  UILabel *priseListLabel;
@property (retain, nonatomic)  UILabel *contentLabel;
@property(retain,nonatomic)    UIButton* criticalButton;
@property(retain,nonatomic)    NSMutableArray* dataArray;
@property (retain, nonatomic)  UIView *imgContentView;
@property (retain, nonatomic)  UIButton *expandButton;
@property (retain, nonatomic)  UIButton *deleteButton;
@property (retain, nonatomic)  UIImageView *headerImgView;


//---------------分享功能--------------//
@property (retain, nonatomic)  UIView *shareView; //点赞区域
@property (retain, nonatomic)  UILabel *shareLabel;
@property (retain, nonatomic)  UIImageView *shareImgView;
//---------------分享功能--------------//


@property(retain,nonatomic)id  <WeiboTableViewCellDelegate>delegate;


@end

