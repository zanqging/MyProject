//
//  DemoVC9Cell.h
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * 持续更新地址: https://github.com/gsdios/SDAutoLayout                              *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 *                                                                                *
 *********************************************************************************
 
 */

#import <UIKit/UIKit.h>
#import "GlobalDefine.h"
#import "UConstants.h"
#import "CycleCommentView.h"
#import "UIImageView+WebCache.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
@class Demo9Model;
@protocol WeiboTableViewCellDelegate <NSObject>

-(void)weiboTableViewCell:(id)weiboTableViewCell refresh:(BOOL)refresh;
-(void)weiboTableViewCell:(id)weiboTableViewCell deleteDic:(id) cycle;
-(void)weiboTableViewCell:(id)weiboTableViewCell priseDic:(NSDictionary*)dic msg:(NSString*)msg;
-(void)weiboTableViewCell:(id)weiboTableViewCell userId:(NSString*)userId isSelf:(BOOL) isSelf;
-(void)weiboTableViewCell:(id)weiboTableViewCell contentId:(NSString*)contentId atId:(NSString*)atId isSelf:(BOOL) isSelf;
-(void)weiboTableViewCell:(id)weiboTableViewCell didSelectedContent:(BOOL)isSelected;
-(void)weiboTableViewCell:(id)weiboTableViewCell didSelectedShareContentUrl:(NSURL*)urlStr;

@end

@interface DemoVC9Cell : UITableViewCell<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,CycleCommentDelegate>

@property (nonatomic, strong) Demo9Model *model;
@property (nonatomic, retain) NSArray* dataArray;
@property(retain,nonatomic)UITableView* tableView;

@property(retain,nonatomic)id  <WeiboTableViewCellDelegate>delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier commentViewHeight:(CGFloat)height commentHeaderViewHeight:(CGFloat)headerHeight;

@end
