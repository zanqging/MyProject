//
//  UserCollecteViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/8.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserTraceViewController.h"
#import "MJRefresh.h"
#import "SwitchSelect.h"
#import "AuthTraceTableViewCell.h"
#import "FinialAuthViewController.h"
#import "RoadShowApplyViewController.h"
#import "UserCollecteTableViewCell.h"
#import "RoadShowDetailViewController.h"
@interface UserTraceViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate,LoadingViewDelegate>
{
    
    bool isRefresh;
    BOOL isLastPage;
    NSInteger currentPage;
    UIScrollView* scrollView;
}
@end

@implementation UserTraceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"进度查看"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"个人中心" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    //头部
    [self addSwitchView];
    
    self.tableView=[[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, POS_Y(scrollView), WIDTH(self.view), HEIGHT(self.view)-HEIGHT(scrollView)-HEIGHT(self.navView)) style:UITableViewStylePlain];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.backgroundColor=BackColor;
    [self.tableView removeFromSuperview];
    [self.view addSubview:self.tableView];
    
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
    
    [self loadData];
    
    //加载页
    self.startLoading  = YES;
    
    //加载数据
    [self refreshProject];
}

-(void)refreshProject
{
    isRefresh =YES;
    currentPage = 0;
    switch (self.currentSelected) {
        case 1000:
            [self loadMyRoadShowData];
            break;
        case 1001:
            [self loadMyParticateData];
            break;
        case 1002:
            [self loadMyAuthData];
            break;
        default:
            [self loadMyRoadShowData];
            break;
    }
    
}

-(void)loadProject
{
    isRefresh =NO;
    if (!self.isEndOfPageSize) {
        currentPage++;
        switch (self.currentSelected) {
            case 1000:
                [self loadMyRoadShowData];
                break;
            case 1001:
                [self loadMyParticateData];
                break;
            case 1002:
                [self loadMyAuthData];
                break;
            default:
                [self loadMyRoadShowData];
                break;
        }
        
    }else{
        [self.tableView.footer endRefreshing];
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"已加载全部内容"];
    }
}


-(void)loadMyRoadShowData
{
//    [self.httpUtil getDataFromAPIWithOps:MY_ROADSHOW_APPLY postParam:nil type:0 delegate:self sel:@selector(requestRoadShowData:)];
}
-(void)loadMyParticateData
{
    [self.httpUtil getDataFromAPIWithOps:MY_PARTICATE postParam:nil type:0 delegate:self sel:@selector(requestRoadShowData:)];
}
-(void)loadMyAuthData
{
    [self.httpUtil getDataFromAPIWithOps:MY_AUTH postParam:nil type:0 delegate:self sel:@selector(requestRoadShowData:)];
}

-(void)addSwitchView
{
    NSMutableArray* array=[NSMutableArray arrayWithObjects: @"我的路演",@"来现场",@"投资人认证", nil];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), 50)];
     scrollView.backgroundColor =WriteColor;
    UITapGestureRecognizer* recognizer;
    float w =WIDTH(self.view)/array.count;
    for (int i =  0; i<array.count; i++) {
        recognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        //自然投资人
        SwitchSelect* switchView = [[SwitchSelect alloc]initWithFrame:CGRectMake(w*i, 0,w, 50)];
        switchView.tag =1000+i;
        if (switchView.tag  == self.currentSelected) {
            switchView.isSelected = YES;
        }
        
        switchView.titleName = array[i];
        switchView.backgroundColor = BackColor;
        [switchView addGestureRecognizer:recognizer];
        [scrollView setContentSize:CGSizeMake(w*i, HEIGHT(scrollView))];
        [scrollView addSubview:switchView];
    }
   
   [self.view addSubview:scrollView];
}

-(void)tapAction:(UITapGestureRecognizer*)sender
{
    SwitchSelect* switchView = (SwitchSelect*)sender.view;
    switchView.isSelected =YES;
   
    for ( UIView *  v in scrollView.subviews) {
        if (v.class == SwitchSelect.class) {
            if (v.tag != switchView.tag) {
                ((SwitchSelect*)v).isSelected=NO;
            }
        }
    }
    
    if (self.currentSelected !=switchView.tag) {
         self.currentSelected = switchView.tag;
        currentPage = 0;
        self.isEndOfPageSize= NO;
        isLastPage = false;
        switch (self.currentSelected) {
            case 1000:
                [self loadMyRoadShowData];
                break;
            case 1001:
                [self loadMyParticateData];
                break;
            case 1002:
                [self loadMyAuthData];
                break;

            default:
                [self loadMyRoadShowData];
                break;
        }
    }
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadData
{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    NSMutableDictionary* dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"xiaoxihuifu" forKey:@"imageName"];
    [dic setValue:@"消息回复" forKey:@"title"];
    [array addObject:dic];
    
//    [dic setValue:@"jindu" forKey:@"imageName"];
//    [dic setValue:@"进度查看" forKey:@"title"];
//    [array addObject:dic];
//    
    [dic setValue:@"xiaoxihuifu" forKey:@"imageName"];
    [dic setValue:@"消息通知" forKey:@"title"];
    [array addObject:dic];
    
    self.dataArray=array;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==self.dataArray.count) {
        if (self.currentSelected!=1000) {
            FinialAuthViewController* controller = [[FinialAuthViewController alloc]init];
            controller.titleStr = self.navView.title;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            RoadShowApplyViewController* controller = [[RoadShowApplyViewController alloc]init];
            controller.title = self.navView.title;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row =indexPath.row;
    
    if (row<self.dataArray.count) {
        NSDictionary* dic = self.dataArray[row];
        if(self.currentSelected==1002){
            NSString* is_qualified = [dic valueForKey:@"valid"];
            if ([is_qualified isKindOfClass:NSNull.class]) {
                is_qualified = @"false";
                [dic setValue:is_qualified forKey:@"is_qualified"];
            }
            if ([is_qualified boolValue]) {
                return 150;
            }
            return 250;
        }else{
            NSString* is_qualified = [dic valueForKey:@"is_qualified"];
            if ([is_qualified isKindOfClass:NSNull.class]) {
                is_qualified = @"false";
                [dic setValue:is_qualified forKey:@"is_qualified"];
            }
            if ([is_qualified boolValue]) {
                return 150;
            }
            return 250;
        }
        
    }else{
        return 70;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<self.dataArray.count && self.dataArray.count>0) {
        //声明静态字符串对象，用来标记重用单元格
        NSString* TableDataIdentifier=@"TraceTableViewCell";
        //用TableDataIdentifier标记重用单元格
        AuthTraceTableViewCell* cellInstance=(AuthTraceTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
        //如果单元格未创建，则需要新建
        if (cellInstance==nil) {
            float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            
            cellInstance = [[AuthTraceTableViewCell alloc]initWithFrame:CGRectMake(0, 0,WIDTH(self.view), height)];
            cellInstance.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSInteger row =indexPath.row;
        NSDictionary* dic = self.dataArray[row];
        
      if(self.currentSelected==1002){
            NSString* is_qualified = [dic valueForKey:@"is_qualified"];
            if ([is_qualified isKindOfClass:NSNull.class]) {
                is_qualified = false;
                [dic setValue:@"false" forKey:@"is_qualified"];
            }
          
          
            cellInstance.title = [dic valueForKey:@"company"];
            cellInstance.content = [dic valueForKey:@"reject_reason"];
            cellInstance.createDateTime = [dic valueForKey:@"apply_for_certificate_datetime"];
            cellInstance.handleDateTime = [dic valueForKey:@"certificate_datetime"];
            cellInstance.auditDateTime = [dic valueForKey:@"audit_date"];
          if ([is_qualified boolValue]) {
              [cellInstance setIsFinished:YES];
          }
      }else{
          
          
              cellInstance.title = [dic valueForKey:@"company"];
              cellInstance.content = [dic valueForKey:@"reason"];
              cellInstance.createDateTime = [dic valueForKey:@"create_datetime"];
              cellInstance.handleDateTime = [dic valueForKey:@"handle_datetime"];
              cellInstance.auditDateTime = [dic valueForKey:@"audit_datetime"];
          
          NSString* is_qualified = [dic valueForKey:@"valid"];
          if (![is_qualified isKindOfClass:NSNull.class]) {
              if (self.currentSelected!=1000) {
                  [cellInstance setIsScuesssed:[is_qualified boolValue]];
              }else{
                  [cellInstance setIsFinished:[is_qualified boolValue]];
              }
          }
      }
        
        
        
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        return cellInstance;
    }else{
        //声明静态字符串对象，用来标记重用单元格
        NSString* TableDataIdentifier=@"UiTableViewCell";
        //用TableDataIdentifier标记重用单元格
        UITableViewCell* cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
        //如果单元格未创建，则需要新建
        UIView * view;
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableDataIdentifier];
            cell.backgroundColor = BackColor;
            view = [[UIView alloc]initWithFrame:cell.frame];
            view.backgroundColor = BackColor;
            view.tag=20001;
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(cell)/2-70, HEIGHT(cell)/2, 30, 30)];
            imageView.image = IMAGENAMED(@"shangchuan");
            [view addSubview:imageView];
            UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+5, HEIGHT(cell)/2-5, WIDTH(cell)/2, HEIGHT(cell))];
            lable.tag=20002;
            lable.textAlignment = NSTextAlignmentLeft;
            lable.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
            lable.font = SYSTEMFONT(16);
            [view addSubview:lable];
            [cell addSubview:view];
        }
        if (!view) {
            view = [cell viewWithTag:20001];
        }
        UILabel* label =(UILabel*)[view viewWithTag:20002];
        
        if (self.currentSelected==1000) {
            label.text = @"我要申请项目路演";
        }else{
            label.text = @"添加新的身份认证";
        }
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count>0) {
        if (self.currentSelected !=1001) {
            return self.dataArray.count+1;
        }
        return self.dataArray.count;
    }
    
    return 0;
   
}


-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (self.dataArray.count<=0) {
        self.tableView.isNone = YES;
    }else{
        self.tableView.isNone = NO;
    }
    [self.tableView reloadData];
}

#pragma LoadingView
-(void)refresh
{
    [self loadMyRoadShowData];
    self.isNetRequestError = NO;
    
}

#pragma ASIHttpquest
//待融资
-(void)requestRoadShowData:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSString* status =[jsonDic valueForKey:@"status"];
        if([status intValue] == 0 || [status intValue] ==-1){
            self.dataArray= nil;
            self.dataArray = [jsonDic valueForKey:@"data"];
            
            if ([status integerValue] == -1) {
                isLastPage = YES;
                self.isEndOfPageSize = YES;
            }
            self.startLoading  = NO;
        }else{
            self.isNetRequestError  =YES;
        }
        self.tableView.content = [jsonDic valueForKey:@"msg"];
    }else{
        self.isNetRequestError =YES;
    }
    
    if (isRefresh) {
        [self.tableView.header endRefreshing];
    }else{
        [self.tableView.footer endRefreshing];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (!self.navigationController.interactivePopGestureRecognizer.enabled) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setTitleStr:(NSString *)titleStr
{
    self->_titleStr  =titleStr;
    if (self.titleStr) {
        self.navView.title = self.titleStr;
    }
}
@end
