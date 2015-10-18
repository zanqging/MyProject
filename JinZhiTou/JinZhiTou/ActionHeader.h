//
//  ActionHeader.h
//  Cycle
//
//  Created by air on 15/10/14.
//  Copyright © 2015年 csz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionHeader.h"
#import "UIImageView+WebCache.h"
@protocol ActionHeaderDeleaget <NSObject>
@required
-(void)actionHeader:(id)header selectedIndex:(NSInteger)selectedIndex className:(NSString*)className;

@end

@interface ActionHeader : UIView
{
    UIImageView* headerImgView;
    UILabel* nameLabel,* companyLabel,* industoryLabel;
    UILabel* contentLabel;
    UIView* imgContentView;
    
    
    UIButton* criticalButton,* shareButton,* priseButton;
    
    UIButton* criticalListButton,* shareListButton,* priseListButton;
}
@property(retain,nonatomic)id <ActionHeaderDeleaget> delegate;
@property(retain,nonatomic)NSDictionary* dic;
@end

