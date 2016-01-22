//
//  INSViewController.m
//  Berlin Insomniac
//
//  Created by Salánki, Benjámin on 06/03/14.
//  Copyright (c) 2014 Berlin Insomniac. All rights reserved.
//

#import "INSViewController.h"
#import "MJRefresh.h"
#import "INSSearchBar.h"
#import "CreditTableViewCell.h"
#import "BannerViewController.h"
#import "SearchTableViewHeader.h"
#import "UserInfoTableViewCell.h"
#import "NewFinialTableViewCell.h"
#import "UserCollecteTableViewCell.h"
#import "RoadShowDetailViewController.h"
@interface INSViewController () <INSSearchBarDelegate,ASIHTTPRequestDelegate>
{
    NSInteger currentPage;
    SearchTableViewHeader* header;
    
    BOOL isSearch;
    BOOL isRefresh;
}

@property (nonatomic, strong) INSSearchBar *searchBarWithoutDelegate;

@end

@implementation INSViewController

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"搜索"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.view addSubview:self.navView];
    
    self.view.backgroundColor = ColorTheme;
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:self.title forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
	self.searchBarWithoutDelegate = [[INSSearchBar alloc] initWithFrame:CGRectMake(100.0, 27.0, CGRectGetWidth(self.view.bounds) - 110.0, 34.0)];
    self.searchBarWithoutDelegate.searchField.textColor =AppColorTheme;
    self.searchBarWithoutDelegate.delegate = self;
	[self.view addSubview:self.searchBarWithoutDelegate];
    
    
    self.tableView=[[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-kTopBarHeight-kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.backgroundColor=BackColor;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refresh:) loadAction:@selector(loadMore:)];
    
    [self.view addSubview:self.tableView];
    
    header = [[SearchTableViewHeader alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 50)];
    if (self.titleContent) {
        header.title = self.titleContent;
    }else{
        header.title =@"待融资项目搜索热词";
    }
    [self.tableView setTableHeaderView:header];
    
    if (self.type==0) {
        //加载关键词
        [self loadKeyWord];
    }else if (self.type ==3){
        [self loadCreditKeyWord];
    }
//    
    [self.searchBarWithoutDelegate showSearchBar:nil];
    
    
}

/**
 *  刷新
 *
 *  @param sender sender
 */
-(void)refresh:(id)sender
{
    currentPage = 0;
    isRefresh  =YES;
    [self searchBarDidTapReturn:self.searchBarWithoutDelegate];
}

/**
 *  加载更多
 *
 *  @param sender
 */
-(void)loadMore:(id)sender
{
    currentPage ++;
    [self searchBarDidTapReturn:self.searchBarWithoutDelegate];
}


/**
 *  加载关键词
 */
-(void)loadKeyWord
{
    //加载页面
    self.startLoading  =YES;
    [self.httpUtil getDataFromAPIWithOps:KEYWORD postParam:nil type:0 delegate:self sel:@selector(requestKeyWord:)];
    
}


-(void)loadCreditKeyWord
{
    //加载页面
    self.startLoading  =YES;
    [self.httpUtil getDataFromAPIWithOps:@"credit/" postParam:nil type:0 delegate:self sel:@selector(requestKeyWord:)];
}
-(void)setTitleContent:(NSString *)titleContent
{
    self->_titleContent  =titleContent;
    if (self.titleContent) {
        header.title = self.titleContent;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSMutableDictionary* dic = self.dataArray[row];
    
    if (self.type ==0) {
        RoadShowDetailViewController* controller =[[RoadShowDetailViewController alloc]init];
//        Project* project = [[Project alloc]init];
//        project = [[Project alloc]init];
//        project.imgUrl = [dic valueForKey:@"img"];
//        project.tag = [dic valueForKey:@"tag"];
//        project.company = [dic valueForKey:@"company"];
//        project.projectId = [[dic valueForKey:@"id"] integerValue];
//        project.invest = [NSString stringWithFormat:@"%@",[dic valueForKey:@"invest"]];
//        project.planfinance = [NSString stringWithFormat:@"%@",[dic valueForKey:@"planfinance"]];
        
        controller.dic = dic;
        controller.title = self.navView.title;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(self.type==3){
        if (isSearch) {
            BannerViewController* controller =[[BannerViewController alloc]init];
            controller.title = self.navView.title;
            controller.titleStr  =@"搜索结果";
            NSURL* url = [NSURL URLWithString:[dic valueForKey:@"url"]];
            controller.type = 1;
            controller.url = url;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            self.searchBarWithoutDelegate.searchField.text = self.dataArray[row];
            [self searchBarDidTapReturn:self.searchBarWithoutDelegate];
        }
    }else{
        BannerViewController* controller =[[BannerViewController alloc]init];
        controller.title = self.navView.title;
        NSURL* url = [NSURL URLWithString:[dic valueForKey:@"url"]];
        controller.type = 3;
        controller.url = url;
        controller.dic = dic;
        [self.navigationController pushViewController:controller animated:YES];
        NSString* serverUrl = [NEWS_READ_COUNT stringByAppendingFormat:@"%@/",[dic valueForKey:@"id"]];
        [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:0 sel:nil];
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearch) {
        if (self.type==0) {
            return 110;
        }else if(self.type==3){
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WIDTH(self.view)-20, 20)];
            label.numberOfLines = 2;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            float height = 0;
            NSDictionary* dic = [self.dataArray objectAtIndex:indexPath.row];
            
            [TDUtil setLabelMutableText:label content:[dic valueForKey:@"title"] lineSpacing:0 headIndent:0];
            
            height = HEIGHT(label);
            
            [label setFrame:CGRectMake(10, 0, WIDTH(self.view)-20, 20)];
            label.numberOfLines = 3;
            label.font = SYSTEMFONT(16);
            [TDUtil setLabelMutableText:label content:[dic valueForKey:@"content"] lineSpacing:3 headIndent:0];
            height += HEIGHT(label);
            return height+25;
        }else{
            return 120;
        }
    }
    return 60;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isSearch) {
        if (self.type==0) {
            //声明静态字符串对象，用来标记重用单元格
            NSString* TableDataIdentifier=@"UserCollecteViewCell";
            //用TableDataIdentifier标记重用单元格
            UserCollecteTableViewCell* cell=(UserCollecteTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
            //如果单元格未创建，则需要新建
            if (cell==nil) {
                cell =[[UserCollecteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableDataIdentifier];
            }
            
            NSDictionary* dic = self.dataArray[indexPath.row];
            
            [cell.imgview sd_setImageWithURL:[dic valueForKey:@"img"] placeholderImage:IMAGENAMED(@"loading")];
            cell.titleLabel.text = [dic valueForKey:@"company"];
            [TDUtil setLabelMutableText:cell.desclabel content:[dic valueForKey:@"profile"] lineSpacing:3 headIndent:0];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryNone;
            tableView.contentSize = CGSizeMake(WIDTH(tableView), 150*self.dataArray.count+100);
            return cell;
        }else if(self.type==3){
            //声明静态字符串对象，用来标记重用单元格
            NSString* TableDataIdentifier=@"CreditViewCell";
            //用TableDataIdentifier标记重用单元格
            CreditTableViewCell* cell=(CreditTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
            //如果单元格未创建，则需要新建
            if (cell==nil) {
                cell =[[CreditTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableDataIdentifier];
            }
            
            NSDictionary* dic = self.dataArray[indexPath.row];
            [dic setValue:self.searchBarWithoutDelegate.searchField.text forKey:@"searchText"];
            cell.dataDic =dic;
            tableView.separatorStyle  =UITableViewCellSeparatorStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }else{
            //声明静态字符串对象，用来标记重用单元格
            NSString* TableDataIdentifier=@"UsefFinialViewCell";
            //用TableDataIdentifier标记重用单元格
            NewFinialTableViewCell* cell=(NewFinialTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
            //如果单元格未创建，则需要新建
            if (cell==nil) {
                cell =[[NewFinialTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableDataIdentifier];
            }
            
            NSDictionary* dic = self.dataArray[indexPath.row];
            NSURL* url = [dic valueForKey:@"img"];
            
            cell.desclabel.text = [dic valueForKey:@"src"];
            cell.titleLabel.text = [dic valueForKey:@"title"];
            cell.typeLabel.text = [dic valueForKey:@"content"];
            cell.timeLabel.text = [dic valueForKey:@"create_datetime"];
            cell.priseLabel.text = [[dic valueForKey:@"share"] stringValue];
            cell.colletcteLabel.text = [[dic valueForKey:@"read"] stringValue];
            [cell.imgview sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading")];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            tableView.contentSize = CGSizeMake(WIDTH(tableView), 120*self.dataArray.count+60);
            return cell;
        }
    }else{
        //声明静态字符串对象，用来标记重用单元格
        NSString* TableDataIdentifier=@"UserInfoViewCell";
        if (self.type==0) {
            //用TableDataIdentifier标记重用单元格
            searchTableViewCell=(SearchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
            //如果单元格未创建，则需要新建
            if (searchTableViewCell==nil) {
                searchTableViewCell = [[SearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 100)];
                searchTableViewCell.delegate  = self;
                searchTableViewCell.type = self.type;
                tableView.separatorStyle  =UITableViewCellSeparatorStyleNone;
            }
            NSMutableDictionary* dic = self.dataArray[indexPath.row];
            searchTableViewCell.dataDic = dic;
            searchTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return searchTableViewCell;
        }else{
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
            if (!cell) {
                cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableDataIdentifier];
            }
            
            NSString* text = self.dataArray[indexPath.row];
            cell.textLabel.text = text;
            return cell;
        }
        
    }
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (self.dataArray.count>0) {
        [self.tableView setIsNone:NO];
        [self.tableView setContentSize:CGSizeMake(WIDTH(self.tableView), 60*self.dataArray.count)];
    }else{
        header.title =[NSString stringWithFormat:@"没有包含\"%@\"的搜索结果",self.searchBarWithoutDelegate.searchField.text];
        [self.tableView setIsNone:YES];
        [self.tableView setEmptyImgFileName:@"empty"];
    }
    [self.tableView reloadData];
}

#pragma mark - search bar delegate

- (CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar
{
    CGRect frame = searchBar.frame;
    frame.origin.x = 30;
    frame.size.width = WIDTH(self.view)-40;
    
    [self.navView.leftButton setAlpha:0];
    searchBar.searchField.placeholder = @"名称/行业/地域/关键词 搜索";
	return frame;
}

- (void)searchBar:(INSSearchBar *)searchBar willStartTransitioningToState:(INSSearchBarState)destinationState
{
	// Do whatever you deem necessary.
}

- (void)searchBar:(INSSearchBar *)searchBar didEndTransitioningFromState:(INSSearchBarState)previousState
{
	// Do whatever you deem necessary.
}

-(void)searchBarDone:(INSSearchBar *)searchBar
{
    [self.navView.leftButton setAlpha:1];
}

- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar
{
    NSLog(@"搜索：%@",searchBar.searchField.text);
    
    header.title =[NSString stringWithFormat:@"包含\"%@\"的搜索结果",searchBar.searchField.text];
    NSString* url;
    if (self.type==0) {
        url= [PROJECT_SEARCH stringByAppendingFormat:@"%ld/",currentPage];
    }else if(self.type==3){
        url= HOME_CREDIT;
    }else{
        url= [NEWS_SEARCH stringByAppendingFormat:@"%ld/",currentPage];
    }
    NSString* value =searchBar.searchField.text;
    if ([TDUtil isValidString:value]) {
        if (!isRefresh) {
            self.startLoading  = YES;
            self.isTransparent = YES;
        }
        NSString* key = @"wd";
        [self.httpUtil getDataFromAPIWithOps:url postParam:[NSDictionary dictionaryWithObject:value forKey:key] type:0 delegate:self sel:@selector(requestSearch:)];
    }
}

- (void)searchBarTextDidChange:(INSSearchBar *)searchBar
{
	// Do whatever you deem necessary.
	// Access the text from the search bar like searchBar.searchField.text
}

-(void)refresh
{
    [self searchBarDidTapReturn:self.searchBarWithoutDelegate];
}



#pragma searchResult
-(void)searchResult:(id)sender
{
    UILabel* label =(UILabel*)[sender view];
    SearchTableViewCell* cell = (SearchTableViewCell*)[label superview];
    NSString* par;
    NSArray* array = [cell.dataDic valueForKey:@"data"];
    
    NSString* key;
    if (self.type==0) {
        key  =@"word";
    }else{
        key = @"value";
    }
    NSString* str=@"";
    for (int  i =0; i<array.count; i++) {
        if ([array[i] isKindOfClass:NSDictionary.class]) {
            str = [array[i] valueForKey:key];
        }else{
            str = array[i];
        }
        if ([label.text isEqualToString:str]) {
            par = str;
        }
    }
    header.title =[NSString stringWithFormat:@"包含\"%@\"的搜索结果",label.text];
    self.startLoading  =YES;
    self.isTransparent  =YES;
    
    NSString* url;
    if (self.type==0) {
        key  =@"word";
         url= [PROJECT_SEARCH stringByAppendingFormat:@"%ld/",currentPage];
    }else{
        key = @"value";
        url= [NEWS_SEARCH stringByAppendingFormat:@"%ld/",currentPage];
    }
    
    if(par)
    {
        [self.httpUtil getDataFromAPIWithOps:url postParam:[NSDictionary dictionaryWithObject:par forKey:@"wd"] type:0 delegate:self sel:@selector(requestSearch:)];
    }
    
}

/**
 *  网络请求
 *
 *  @param request ASIHttpRequeste
 */
-(void)requestKeyWord:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        int code = [[jsonDic valueForKey:@"code"] intValue];
        if (code == 0 || code ==-1) {
            if (self.type==0) {
                NSArray* arr=[[jsonDic valueForKey:@"data"] valueForKey:@"keyword"];
                NSMutableArray* array = [[NSMutableArray alloc]init];
                NSMutableArray* tempArray = [[NSMutableArray alloc]init];
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                int num=0;
                for (int i=0; i<arr.count; i++) {
                    
                    if (num>=3) {
                        num = 0;
                        dic = [[NSMutableDictionary alloc]init];
                        [dic setValue:array forKey:@"data"];
                        [tempArray addObject:dic];
                        array = [[NSMutableArray alloc]init];
                        
                    }
                    
                    [array addObject:arr[i]];
                    
                    if (i==arr.count -1) {
                        if (array.count>0) {
                            dic = [[NSMutableDictionary alloc]init];
                            [dic setValue:array forKey:@"data"];
                            [tempArray addObject:dic];
                            array = [[NSMutableArray alloc]init];
                        }
                    }
                    
                    num++;
                    
                }
                self.dataArray = tempArray;
            }else{
                self.dataArray = [[jsonDic valueForKey:@"data"] valueForKey:@"company"];
            }
            
            self.startLoading = NO;
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        }
        [self.searchBarWithoutDelegate changeStateIfPossible:nil];
        
        self.tableView.content = [jsonDic valueForKey:@"msg"];
    }
}

/**
 *  搜索
 *
 *  @param request ASIHttpRequeste
 */
-(void)requestSearch:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] ==2) {
            if (currentPage==0) {
                self.dataArray =[jsonDic valueForKey:@"data"];
            }else{
                NSMutableArray* array = [[NSMutableArray alloc] init];
                if (self.dataArray) {
                    array  =self.dataArray;
                }
                //重新组装
                [array addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                self.dataArray = array;
            }
            isSearch = YES;
            self.startLoading = NO;
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            self.isNetRequestError  =YES;
        }
        self.tableView.content = [jsonDic valueForKey:@"msg"];
    }
}


- (void) viewWillAppear: (BOOL)inAnimated {
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:YES];
}

@end
