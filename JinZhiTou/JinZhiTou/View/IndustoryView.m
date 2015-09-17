//
//  IndustoryView.m
//  JinZhiTou
//
//  Created by air on 15/9/9.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "IndustoryView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "CompanyViewController.h"
#import <QuartzCore/QuartzCore.h>
@implementation IndustoryView
-(id)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.backgroundColor  =WriteColor;
        self.layer.borderColor = BACKGROUND_LIGHT_GRAY_COLOR.CGColor;
        UIView* v =[[UIView alloc]initWithFrame:frame];
        v.backgroundColor  =BlackColor;
        v.alpha = 0.7;
        [self addSubview:v];
        
        //中间区域
        v = [[UIView alloc]initWithFrame:CGRectMake(40, 40, WIDTH(self)-80, HEIGHT(self)-50)];
        v.backgroundColor = WriteColor;
        [self addSubview:v];
        
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, WIDTH(v)-20, 40)];
        label.text = @"请选择公司所在的行业";
        label.backgroundColor = WriteColor;
        label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [v addSubview:label];
        
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, POS_Y(label), WIDTH(v)-10, 1)];
        imageView.backgroundColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [v addSubview:imageView];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(imageView)+20, WIDTH(v), HEIGHT(v)-POS_Y(imageView)-100)];
        self.tableView.dataSource = self;
        self.tableView.delegate  =self;
        self.tableView.bounces=YES;
        self.tableView.allowsSelection=YES;
        self.tableView.delaysContentTouches=NO;
        self.tableView.showsVerticalScrollIndicator=NO;
        self.tableView.showsHorizontalScrollIndicator=NO;
        self.tableView.backgroundColor=BackColor;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [v addSubview:self.tableView];

        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, POS_Y(self.tableView), WIDTH(v)-10, 1)];
        imageView.backgroundColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [v addSubview:imageView];
        
        UIButton* btnAction = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(v)/2-50, POS_Y(imageView)+20, 100, 30)];
        [btnAction setTitle:@"确定" forState:UIControlStateNormal];
        btnAction.layer.borderColor = ColorCompanyTheme.CGColor;
        btnAction.layer.cornerRadius =5;
        btnAction.layer.borderWidth=1;
        [btnAction setTitleColor:ColorCompanyTheme forState:UIControlStateNormal];
        [btnAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btnAction];
        
    }
    return self;
}

-(void)btnAction:(id)sender
{
    [self removeFromSuperview];
    ((CompanyViewController*)self.controller).industoryArray = selectArray;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row =indexPath.row;
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"IndustoryCell";
    
    
    IndustoryTableViewCell * Cell =(IndustoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    if (Cell==nil) {
        Cell = [[IndustoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableDataIdentifier];
        Cell.delegate = self;
    }
    NSMutableArray* array = self.dataArray[row];
    Cell.dataArray = array;
    Cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    return Cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (self.dataArray.count>0) {
        [self.tableView reloadData];
    }
}

#pragma IndustoryDelegate
-(void)IndustoryTableViewCell:(IndustoryTableViewCell *)industoryTableViewCell finished:(BOOL)isFinished
{
    
}

-(void)IndustoryTableViewCell:(IndustoryTableViewCell *)industoryTableViewCell data:(NSDictionary *)dic
{
    if (!selectArray) {
        selectArray = [NSMutableArray new];
    }
    
    BOOL isSelected = [[dic valueForKey:@"isSelected"] boolValue];
    if (isSelected && ![selectArray containsObject:dic]) {
        [selectArray addObject:dic];
    }else if (!isSelected && [selectArray containsObject:dic]){
        [selectArray removeObject:dic];
    }
    
}
@end
