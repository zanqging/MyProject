//
//  CycleHeader.h
//  JinZhiTou
//
//  Created by air on 15/10/22.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpUtils.h"
#import "UIImageView+WebCache.h"
@interface CycleHeader : UIView
{
    HttpUtils*  httpUtils;
}
@property(retain,nonatomic)UIImageView* headerView;
@property(retain,nonatomic)UIImageView* headerBackView;
@property(retain,nonatomic)UILabel* nameLabel;

-(void)loadData;
@end
