//
//  AGTableViewRowAction.h
//  AGTableViewCell
//
//  Created by Agenric on 15/9/28.
//  Copyright (c) 2015年 Agenric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGTableViewRowAction : UIButton
@property (nonatomic, assign, readonly) NSInteger index;
//- (instancetype)initWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor index:(NSInteger)index;

+ (NSArray *)actionsWithTitles:(NSArray *)titles backgroundColors:(NSArray *)colors;
@end
