//
//  SearchTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/8/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation SearchTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataDic:(NSMutableDictionary *)dataDic
{
    self->_dataDic = dataDic;
    
    NSString* key;
    if (self.type==0) {
        key=@"word";
    }else{
        key = @"value";
    }
    NSMutableArray* array = [dataDic valueForKey:@"data"];
    UILabel* label;
    NSInteger count =array.count;
    float w = WIDTH(self)/3;
    for (int i = 0; i<count; i++) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(10+w*i, 10, w-20, HEIGHT(self))];
        label.layer.borderWidth = 1;
        label.font = SYSTEMFONT(13);
        label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
        label.userInteractionEnabled = YES;
        label.backgroundColor = WriteColor;
        label.text = [array[i] valueForKey:key];
        label.textAlignment = NSTextAlignmentCenter;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchResult:)]];
        label.layer.borderColor = BackColor.CGColor;
        [self addSubview:label];
        
        self.backgroundColor = BackColor;
    }
}
/**
 *  代理 返回结果
 *
 *  @param sender sender
 *
 *  @return 返回结果
 */
-(void)searchResult:(id)sender
{
    if ([_delegate respondsToSelector:@selector(searchResult:)]) {
        [_delegate searchResult:sender];
    }
}

@end
