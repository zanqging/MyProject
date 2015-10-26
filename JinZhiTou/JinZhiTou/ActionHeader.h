//
//  ActionHeader.h
//  Cycle
//
//  Created by air on 15/10/14.
//  Copyright © 2015年 csz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionHeader.h"
#import "MWPhotoBrowser.h"
#import "UIImageView+WebCache.h"
@protocol ActionHeaderDeleaget <NSObject>
@required
-(void)actionHeader:(id)header selectedIndex:(NSInteger)selectedIndex className:(NSString*)className;

-(void)actionHeader:(id)header data:(NSDictionary*)data prise:(BOOL)priseFlag;
-(void)actionHeader:(id)header data:(NSDictionary*)data critical:(BOOL)criticalFlag;

@end

@interface ActionHeader : UIView<MWPhotoBrowserDelegate>
{
    UIImageView* headerImgView;
    UILabel* nameLabel,* companyLabel,* industoryLabel;
    UILabel* contentLabel,*dateTimeLabel;
    UIView* imgContentView;
    
    
    UIButton* criticalButton,* priseButton;
    
    UIButton* criticalListButton,* priseListButton;
}
@property(retain,nonatomic)id <ActionHeaderDeleaget> delegate;
@property(retain,nonatomic)NSDictionary* dic;
@property(retain,nonatomic)NSMutableArray* thumbs;
@end

