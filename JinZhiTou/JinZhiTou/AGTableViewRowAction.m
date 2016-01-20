//
//  AGTableViewRowAction.m
//  AGTableViewCell
//
//  Created by Agenric on 15/9/28.
//  Copyright (c) 2015年 Agenric. All rights reserved.
//

#import "AGTableViewRowAction.h"

@interface AGTableViewRowAction ()
{
    NSInteger _index;
}
@end

@implementation AGTableViewRowAction
- (instancetype)initWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor index:(NSInteger)index {
    self = [super init];
    if (self) {
        _index = index;
        self.backgroundColor = backgroundColor;
        self.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self setTitle:title forState:UIControlStateNormal];
    }
    return self;
}

+ (NSArray *)actionsWithTitles:(NSArray *)titles backgroundColors:(NSArray *)colors {
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:titles.count];
    if (titles.count != colors.count) {
        return nil;
    }
    
    for (int i = 0; i < titles.count; i++) {
        [arrayM addObject:[[AGTableViewRowAction alloc] initWithTitle:titles[i] backgroundColor:colors[i] index:i]];
    }
    
    return arrayM;
}

@end
