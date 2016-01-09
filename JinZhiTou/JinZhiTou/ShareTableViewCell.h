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
#import "Demo9Model.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
@class ShareTableViewCell;

@interface ShareTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) Demo9Model *model;
@property(retain,nonatomic)UITableView* tableView;
@property(assign,nonatomic)float commentViewHeight;//回复列表高度
@property(assign,nonatomic)float commentHeaderViewHeight; //回复列表头部高度

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier commentViewHeight:(CGFloat)height commentHeaderViewHeight:(CGFloat)headerHeight;
@end
