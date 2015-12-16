//
//  CyclePriseTableViewCell.h
//  Cycle
//
//  Created by air on 15/10/15.
//  Copyright © 2015年 csz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface CyclePriseTableViewCell : UITableViewCell
{
    UIImageView* headerImgView;
    UILabel* nameLabel,* companyLabel;
    UILabel* contentLabel;
}
@property(retain,nonatomic)NSDictionary* dic;
@end
