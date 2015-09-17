//
//  UserBasicInfoViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/7.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "DialogUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "PECropViewController.h"
#import "UserBasicInfoTableViewCell.h"
@interface UserBasicInfoViewController : UIViewController
@property (strong, nonatomic)NavView *navView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
