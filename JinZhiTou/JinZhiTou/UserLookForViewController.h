//
//  UserLookForViewController.h
//  Cycle
//
//  Created by air on 15/10/14.
//  Copyright © 2015年 csz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
@interface UserLookForViewController : UIViewController
@property(retain,nonatomic)UIView* contentView;
@property(retain,nonatomic)NavView* navView;
@property(retain,nonatomic)NSDictionary* dic;
@property(assign,nonatomic)NSString* userId;
@end
