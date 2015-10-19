//
//  WeiboTableViewCell.h
//  Cycle
//
//  Created by air on 15/10/12.
//  Copyright © 2015年 csz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpUtils.h"
#import "MWPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "ReplyTableViewCell.h"

@protocol WeiboTableViewCellDelegate <NSObject>

-(void)weiboTableViewCell:(id)weiboTableViewCell userId:(NSString*)userId isSelf:(BOOL) isSelf;
-(void)weiboTableViewCell:(id)weiboTableViewCell contentId:(NSString*)contentId atId:(NSString*)atId isSelf:(BOOL) isSelf;
-(void)weiboTableViewCell:(id)weiboTableViewCell deleteDic:(NSDictionary*)dic;
-(void)weiboTableViewCell:(id)weiboTableViewCell refresh:(BOOL)refresh;

@end

@interface WeiboTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_selections;
    HttpUtils* httpUtils;
    NSIndexPath* currentSelectedCellIndex;
}
@property (retain, nonatomic)  UITableView *tableView;

@property(retain,nonatomic)NSString* topId;
@property (retain, nonatomic)  UIView *funView;
@property (retain, nonatomic)  UIView *priseView;
@property (retain, nonatomic)  UILabel *jobLabel;
@property (retain, nonatomic)  UILabel *nameLabel;
@property(retain,nonatomic)    UIButton* priseButton;
@property(retain,nonatomic)    UIButton * shareButton;
@property(retain,nonatomic)    MWPhotoBrowser *browser;
@property (nonatomic, retain)  NSMutableArray *photos;
@property (nonatomic, retain)  NSMutableArray *thumbs;
@property (retain, nonatomic)  UILabel *companyLabel;
@property (retain, nonatomic)  UILabel *dateTimeLabel;
@property (retain, nonatomic)  UILabel *industryLabel;
@property (nonatomic, retain)  NSMutableArray *assets;
@property (retain, nonatomic)  UIView *priseListView;
@property (retain, nonatomic)  UILabel *contentLabel;
@property(retain,nonatomic)    UIButton* criticalButton;
@property(retain,nonatomic)    NSMutableArray* dataArray;
@property (retain, nonatomic)  UIView *imgContentView;
@property (retain, nonatomic)  UIButton *expandButton;
@property (retain, nonatomic)  UIButton *deleteButton;
@property (retain, nonatomic)  NSMutableDictionary* dic;
@property (retain, nonatomic)  UIImageView *headerImgView;
@property(retain,nonatomic)id  <WeiboTableViewCellDelegate>delegate;


@end

