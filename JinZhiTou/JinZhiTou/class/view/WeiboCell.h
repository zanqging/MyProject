//
//  WeiboCell.h
//  wq
//
//  Created by weqia on 13-8-28.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboData.h"
#import "WeiboViewControlle.h"
#import <QuickLook/QuickLook.h>
#import "UIImageView+WebCache.h"
#define REPLY_BACK_COLOR 0xd5d5d5

@protocol WeiboDeleget <NSObject>

-(void)weiboCell:(id)sender replyData:(id)data;

@end

@class WeiboViewControlle;
@interface WeiboCell : UITableViewCell<UIActionSheetDelegate,UIAlertViewDelegate>
{
    WeiboData * _weibo;
    
    WeiboReplyData * _reply;

//    HBCellOperation * _operation;
    
    NSArray * _replys;
    
    NSIndexPath * _indexPath;
    
    BOOL linesLimit;
    
    int replyCount;
}
@property(retain, nonatomic) NSString * atName;
@property(retain,nonatomic)NSString* topicId;
@property(retain,nonatomic)NSString* content;
@property(retain,nonatomic)NSString* titleStr;
@property(assign,nonatomic)BOOL isInvestor;
@property(nonatomic,retain) IBOutlet UILabel * time;
@property(nonatomic,retain) IBOutlet UILabel *  title;
@property(nonatomic,retain) IBOutlet UIView * lockView;
@property(nonatomic,retain) IBOutlet UIImageView * back;
@property(nonatomic,retain) IBOutlet UIImageView * logo;
@property(nonatomic,retain) IBOutlet UIImageView * mLogo;
@property(nonatomic,retain) IBOutlet UIButton *btnDelete;
@property(nonatomic,retain) IBOutlet UIButton * btnShare;
@property (retain, nonatomic) IBOutlet UIButton *btnReply;
@property(nonatomic,retain) WeiboViewControlle * controller;
@property(nonatomic,retain) IBOutlet UILabel * contentLabel;
@property(nonatomic,retain) IBOutlet UIImageView* authenImgView;
@property(weak,nonatomic)id <WeiboDeleget>delegate;
@end

