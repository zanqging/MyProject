//
//  WeiboTableViewCell.h
//  Cycle
//
//  Created by air on 15/10/12.
//  Copyright © 2015年 csz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "ReplyTableViewCell.h"

@protocol WeiboTableViewCellDelegate <NSObject>

-(void)weiboTableViewCell:(id)weiboTableViewCell userId:(NSString*)userId isSelf:(BOOL) isSelf;

@end

@interface WeiboTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate>
{
    NSMutableArray *_selections;
}
@property (retain, nonatomic)  UITableView *tableView;

@property (retain, nonatomic) NSMutableDictionary* dic;
@property (retain, nonatomic)  UIView *priseView;
@property (retain, nonatomic)  UIView *funView;
@property (retain, nonatomic)  UIView *imgContentView;

@property (nonatomic, retain) NSMutableArray *photos;
@property (nonatomic, retain) NSMutableArray *thumbs;
@property (nonatomic, retain) NSMutableArray *assets;
@property(retain,nonatomic)MWPhotoBrowser *browser;
@property (retain, nonatomic)  UIImageView *headerImgView;
@property (retain, nonatomic)  UILabel *nameLabel;
@property (retain, nonatomic)  UILabel *companyLabel;
@property (retain, nonatomic)  UILabel *jobLabel;
@property (retain, nonatomic)  UILabel *industryLabel;
@property (retain, nonatomic)  UILabel *contentLabel;
@property (retain, nonatomic)  UIButton *expandButton;
@property (retain, nonatomic)  UILabel *priseListLabel;
@property(retain,nonatomic)UIButton* criticalButton;
@property(retain,nonatomic)UIButton * shareButton;
@property(retain,nonatomic)UIButton* priseButton;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property(retain,nonatomic)id <WeiboTableViewCellDelegate>delegate;

@end

