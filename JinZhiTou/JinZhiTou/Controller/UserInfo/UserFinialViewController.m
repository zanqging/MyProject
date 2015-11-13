//
//  UserFinialViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/8.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserFinialViewController.h"
#import "MJRefresh.h"
#import "SwitchSelect.h"
#import "MMDrawerController.h"
#import "UserCollecteTableViewCell.h"
#import "RoadShowDetailViewController.h"
@interface UserFinialViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate>
{
    BOOL isRefresh;
    int currentpage;
    UIScrollView* scrollView;
}
@end

@implementation UserFinialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"我的投融资"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:self.navTitle forState:UIControlStateNormal];
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
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView removeFromSuperview];
    [self.view addSubview:self.tableView];
    [self.tableView  setTableHeaderView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
    [self refreshProject];
}

-(void)refreshProject
{
    self.startLoading  =YES;
    
    isRefresh =YES;
    currentpage = 0;
    switch (self.selectedIndex) {
        case 0:
            [self loadCreateData];
            break;
        case 1:
            [self loadFinialData];
            break;
        default:
            [self loadCreateData];
            break;
    }
    
}

-(void)loadProject
{
    isRefresh =NO;
    if (!self.isEndOfPageSize) {
        currentpage++;
        switch (self.selectedIndex) {
            case 0:
                [self loadCreateData];
                break;
            case 1:
                [self loadFinialData];
                break;
            default:
                [self loadCreateData];
                break;
        }
        
    }else{
        [self.tableView.footer endRefreshing];
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"已加载全部内容"];
    }
}


-(void)addSwitchView
{
    NSMutableArray* array=[NSMutableArray arrayWithObjects: @"我所创建的项目",@"我所投资的项目",nil];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), 50)];
    scrollView.backgroundColor =WriteColor;
    UITapGestureRecognizer* recognizer;
    float w =WIDTH(self.view)/array.count;
    for (int i =  0; i<array.count; i++) {
        recognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        //自然投资人
        SwitchSelect* switchView = [[SwitchSelect alloc]initWithFrame:CGRectMake(w*i, 0,w, 50)];
        switchView.tag =1000+i;
        if (i == self.selectedIndex) {
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
    
    if (switchView.tag  == 1000) {
        self.selectedIndex = 0;
        self.dataCreateArray =nil;
        [self loadCreateData];
    }else{
        self.selectedIndex = 1;
        self.dataFinialArray =nil;
        [self loadFinialData];
        
    }
}

-(void)back:(id)sender
{
    if (self.isBackHome) {
        for (UIViewController * c in self.navigationController.childViewControllers) {
            NSLog(@"ViewController:%@",c.class);
            if ([c isKindOfClass:MMDrawerController.class]) {
                [self.navigationController popToViewController:c animated:YES];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)loadCreateData
{
    //添加加载页面
    if (isRefresh) {
        self.isTransparent = YES;
    }
    self.startLoading  =YES;
    NSString* str = [MY_CREATE_PROJECT stringByAppendingFormat:@"%d/",currentpage];
    [self.httpUtil getDataFromAPIWithOps:str postParam:nil type:0 delegate:self sel:@selector(requestRoadShowData:)];
    
}
-(void)loadFinialData
{
    if (isRefresh) {
        self.isTransparent = YES;
    }
    self.startLoading = YES;
    
    NSString* str = [MY_FINIAL_PROJECT stringByAppendingFormat:@"%d/",currentpage];
    [self.httpUtil getDataFromAPIWithOps:str postParam:nil type:0 delegate:self sel:@selector(requestFinalData:)];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoadShowDetailViewController* controller =[[RoadShowDetailViewController alloc]init];
    controller.title = self.navView.title;
    if (self.selectedIndex==0) {
        controller.dic = self.dataCreateArray[indexPath.row];
    }else{
        controller.dic = self.dataFinialArray[indexPath.row];
    }
    [self.navigationController pushViewController:controller animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"UsefFinialViewCell";
    //用TableDataIdentifier标记重用单元格
    UserCollecteTableViewCell* cell=(UserCollecteTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    //如果单元格未创建，则需要新建
    if (cell==nil) {
        cell =[[UserCollecteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableDataIdentifier];
    }
    
    if (self.selectedIndex==0) {
        NSDictionary* dic  =self.dataCreateArray[indexPath.row];
        [cell.imgview sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"thumbnail"]] placeholderImage:IMAGENAMED(@"loading")];
        cell.titleLabel.text = [dic valueForKey:@"company_name"];
        cell.desclabel.text = [dic valueForKey:@"project_summary"];
        cell.backgroundColor = WriteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }else{
        NSDictionary* dic  =self.dataFinialArray[indexPath.row];
//        NSDictionary* dicStage = [[dic valueForKey:@"stage"] valueForKey:@"start"];
        [cell.imgview sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"thumbnail"]] placeholderImage:IMAGENAMED(@"loading")];
        cell.titleLabel.text = [dic valueForKey:@"company_name"];
        cell.desclabel.text = [dic valueForKey:@"project_summary"];
        cell.backgroundColor = WriteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentSize = CGSizeMake(WIDTH(tableView), 190*self.dataCreateArray.count+80);
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedIndex == 0) {
        return self.dataCreateArray.count;
    }else{
        return self.dataFinialArray.count;
    }
}


-(void)setDataCreateArray:(NSMutableArray *)dataCreateArray
{
    self->_dataCreateArray = dataCreateArray;
    if (self.dataCreateArray.count<=0) {
        self.tableView.isNone = YES;
        self.tableView.content = @"暂无上传项目";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.isNone = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    [self.tableView reloadData];
}

-(void)setDataFinialArray:(NSMutableArray *)dataFinialArray
{
    self->_dataFinialArray = dataFinialArray;
    if (self.dataFinialArray.count<=0) {
        self.tableView.isNone = YES;
        self.tableView.content = @"暂无投资项目";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.isNone = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    [self.tableView reloadData];
}

-(void)requestRoadShowData:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] ==-1) {
            if (isRefresh) {
                self.dataCreateArray = [jsonDic valueForKey:@"data"];
            }else{
                if (!self.dataCreateArray) {
                    self.dataCreateArray = [jsonDic valueForKey:@"data"];
                }else{
                    [self.dataCreateArray addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                    [self.tableView reloadData];
                }
            }
            if ([status intValue] ==-1) {
                self.tableView.content = [jsonDic valueForKey:@"msg"];
            }
        }
        if (isRefresh) {
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        
        //关闭加载视图
        self.startLoading  =NO;
    }else{
        
        self.isNetRequestError = YES;
        self.content = @"抱歉，主人！服务器开小差啦！";
    }
}

-(void)requestFinalData:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] ==-1) {
            [self.tableView setIsNone:NO];
            if (isRefresh) {
                self.dataFinialArray = [jsonDic valueForKey:@"data"];
            }else{
                if (!self.dataFinialArray) {
                    self.dataFinialArray = [jsonDic valueForKey:@"data"];
                }else{
                    [self.dataFinialArray addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                    [self.tableView reloadData];
                }
            }
            
            if ([status intValue] ==-1) {
                 self.tableView.content = [jsonDic valueForKey:@"msg"];
            }
            
        }
        if (isRefresh) {
           [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
       
        //关闭加载视图
        self.startLoading = NO;
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
    }
}

-(void)refresh
{
    [self refreshProject];
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

- (void)viewWillAppear:(BOOL)animated { [super viewWillAppear:animated];
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:YES];
}
@end
