//
//  WeiboCell.h
//  wq
//
//  Created by weqia on 13-8-28.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCoreLabel.h"
#import "WeiboData.h"
#import "WeiboViewControlle.h"
#import <QuickLook/QuickLook.h>
#import "UIImageView+WebCache.h"
#define REPLY_BACK_COLOR 0xd5d5d5


@interface ReplyCell : UITableViewCell
@property(nonatomic,retain) IBOutlet HBCoreLabel * label;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIButton *btnReply;
@property (retain, nonatomic) IBOutlet UIImageView *headerImgView;

@end

@class WeiboViewControlle;
@interface WeiboCell : UITableViewCell<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    WeiboData * _weibo;
    
    WeiboReplyData * _reply;

//    HBCellOperation * _operation;
    
    NSArray * _replys;
    
    NSIndexPath * _indexPath;
    
    BOOL linesLimit;
    
    int replyCount;
}
@property(nonatomic,retain) IBOutlet UILabel * time;
@property(nonatomic,retain) IBOutlet UILabel *  title;
@property(nonatomic,retain) IBOutlet UIView * lockView;
@property(nonatomic,retain) IBOutlet UIImageView * back;
@property(nonatomic,retain) IBOutlet UIButton * btnShare;
@property(nonatomic,retain) IBOutlet UIImageView * mLogo;
@property(nonatomic,retain) IBOutlet UIImageView * logo;
@property(nonatomic,retain) IBOutlet UIButton *btnDelete;
@property (retain, nonatomic) IBOutlet UIButton *btnReply;
//@property(nonatomic,weak) IBOutlet UILabel * replyCount;
@property(nonatomic,retain) IBOutlet UIView * replyContent;
@property(nonatomic,retain) IBOutlet HBCoreLabel * content;
@property(nonatomic,retain) IBOutlet UIImageView* authenImgView;
@property(nonatomic,retain) IBOutlet UITableView * tableReply;
@property(nonatomic,retain) WeiboViewControlle * controller;

-(void)setCellContent:(WeiboData *)data;

+(float)getHeightByContent:(WeiboData*)data;

+(float) heightForReply:(NSArray*)replys;

-(void)loadReply;


@end

