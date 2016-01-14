//
//  CompanyCaseItemView.h
//  JinZhiTou
//
//  Created by air on 16/1/13.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface CompanyCaseItemView : UIView
{
    UIImageView * _imgView;
    UILabel * _label;
}
@property (retain , nonatomic) NSDictionary * dic;
@end
