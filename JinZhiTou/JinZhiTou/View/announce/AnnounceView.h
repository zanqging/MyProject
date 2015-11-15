//
//  AnnounceView.h
//  JinZhiTou
//
//  Created by air on 15/11/14.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnounceView : UIView
@property(retain,nonatomic)NSString* announStartContent;
@property(retain,nonatomic)NSString* announMiddleContent;
@property(retain,nonatomic)NSString* announEndContent;
@property(retain,nonatomic)UILabel* contentLabel;
-(void)setAnnounContent:(NSString*)announStartContent middleContent:(NSString*)announMiddleContent endContent:(NSString*)announEndContent;
@end
