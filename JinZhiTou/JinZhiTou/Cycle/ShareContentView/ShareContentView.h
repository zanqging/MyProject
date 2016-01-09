//
//  ShareContentView.h
//  JinZhiTou
//
//  Created by air on 16/1/8.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalDefine.h"
#import "UConstants.h"
#import "UIImageView+WebCache.h"
#import "Share+CoreDataProperties.h"
#import "UIImageView+WebCache.h"
#import "UIView+SDAutoLayout.h"
@interface ShareContentView : UIView
{
    UIImageView* imgView;
    UILabel* labelContent;
}
@property(retain,nonatomic)NSDictionary* dic;
@end
