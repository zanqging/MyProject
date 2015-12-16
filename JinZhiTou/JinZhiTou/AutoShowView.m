//
//  BoxModelView.m
//  WeiNI
//
//  Created by air on 14/11/25.
//  Copyright (c) 2014年 weini. All rights reserved.
//

#import "AutoShowView.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "TableViewCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation AutoShowView
@synthesize tableView=_tableView;

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        int w = self.frame.size.width;
        self.backgroundColor=WriteColor;
        CGRect rect=CGRectMake(0, 0, w,frame.size.height);
        self.tableView=[[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
        self.tableView.bounces=NO;
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.allowsSelection=YES;
        self.tableView.delaysContentTouches=NO;
        self.tableView.backgroundColor = WriteColor;
        self.tableView.showsHorizontalScrollIndicator=NO;
        self.tableView.showsVerticalScrollIndicator=NO;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:self.tableView];
        
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
            
        }
        
        //长按事件
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = 1.0; //seconds	设置响应时间
        lpgr.delegate = self;
        [self.tableView addGestureRecognizer:lpgr];	//启用长按事件
        self.layer.borderColor=BACKGROUND_LIGHT_GRAY_COLOR.CGColor;
        self.layer.borderWidth=0.3;
        
        //加载数据
        [self loadData];
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"MainTableDataidentifer";
    //用TableDataIdentifier标记重用单元格
    TableViewCell* mainTableViewCell=(TableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    //如果单元格未创建，则需要新建
    if (mainTableViewCell==nil) {
        CGRect frame=self.frame;
        frame.origin.x = 0;
        frame.size.width =self.frame.size.width;
        mainTableViewCell=[[TableViewCell alloc]initWithFrame:frame];
    }
    
    //填充行的详细内容
    int row=(int)[indexPath row];
    NSDictionary* dic =self.dataArray[row];
    mainTableViewCell.textLabel.text=[dic valueForKey:self.title];
    mainTableViewCell.textLabel.font = SYSTEMFONT(14);
    mainTableViewCell.selectionStyle=UITableViewCellSelectionStyleBlue;
    mainTableViewCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    mainTableViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return mainTableViewCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = (TableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected=YES;
    [self viewHiddenAnimation];
    NSInteger row=[indexPath row];
    NSDictionary* dic = self.dataArray[row];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"autoSelect" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dic,@"item", nil]];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer  //长按响应函数
{
    CGPoint p = [gestureRecognizer locationInView:self.tableView ];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];//获取响应的长按的indexpath
    
    if (indexPath != nil)
    {
        TableViewCell *cell = (TableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor=CELL_SELECTED_COLOR;
        if (gestureRecognizer.state==UIGestureRecognizerStateEnded) {
            cell.backgroundColor=WriteColor;
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }
    }
    
}


-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray=dataArray;
    //开始重新设置视图布局
    NSInteger count=dataArray.count;
    
    CGRect frame=self.frame;
    
    
    if (count<5) {
        self.tableView.contentSize=CGSizeMake(self.frame.size.width, count*50);
        frame.size.height=count*50;
        [self setFrame:frame];
    }else{
        self.tableView.contentSize=CGSizeMake(self.frame.size.width, 5*50);
        frame.size.height=5*50;
        [self setFrame:frame];
        
    }
    frame.origin.y=0;
    frame.origin.x=0;
    [self.tableView setFrame:frame];
    [self.tableView reloadData];
}

-(void)loadData
{
    NSMutableArray* data=[[NSMutableArray alloc]init];
    self.dataArray=data;
}

-(void)viewShowAnimation
{
    self.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-20);
    self.transform=CGAffineTransformMakeScale(1.0f, 0.0f);//将要显示的view按照正常比例显示出来
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];  //InOut 表示进入和出去时都启动动画
    [UIView setAnimationDuration:0.5f];//动画时间
    self.transform=CGAffineTransformMakeScale(1.0f, 1.0f);//将要显示的view按照正常比例显示出来
//    self.center=CGPointMake(self.frame.size.width/2, self.frame.size.height);
    [UIView commitAnimations];
}

-(void)viewHiddenAnimation
{
    self.isHidden = YES;
}

-(void)setIsHidden:(BOOL)isHidden
{
    if (isHidden) {
        [self setAlpha:0];
    }else{
        [self setAlpha:1];
    }
}

@end
