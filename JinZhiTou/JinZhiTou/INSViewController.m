//
//  INSViewController.m
//  Berlin Insomniac
//
//  Created by Salánki, Benjámin on 06/03/14.
//  Copyright (c) 2014 Berlin Insomniac. All rights reserved.
//

#import "INSViewController.h"
#import "TDUtil.h"
#import "NavView.h"
#import "DialogUtil.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "INSSearchBar.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "BannerViewController.h"
#import "SearchTableViewHeader.h"
#import "UserInfoTableViewCell.h"
#import "NewFinialTableViewCell.h"
#import "UserCollecteTableViewCell.h"
#import "RoadShowDetailViewController.h"
@interface INSViewController () <INSSearchBarDelegate,ASIHTTPRequestDelegate>
{
    NavView* navView;
    HttpUtils* httpUtils;
    LoadingView* loadingView;
    NSInteger currentPage;
    SearchTableViewHeader* header;
    
    BOOL isSearch;
}

@property (nonatomic, strong) INSSearchBar *searchBarWithoutDelegate;

@end

@implementation INSViewController

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=1;
    [navView setTitle:@"搜索"];
    navView.titleLable.textColor=WriteColor;
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.view addSubview:navView];
    
    self.view.backgroundColor = ColorTheme;
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [navView.leftButton setTitle:self.title forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
	self.searchBarWithoutDelegate = [[INSSearchBar alloc] initWithFrame:CGRectMake(100.0, 27.0, CGRectGetWidth(self.view.bounds) - 110.0, 34.0)];
    self.searchBarWithoutDelegate.searchField.textColor =ColorTheme;
    self.searchBarWithoutDelegate.delegate = self;
	[self.view addSubview:self.searchBarWithoutDelegate];
    
    
    self.tableView=[[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-kTopBarHeight-kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.backgroundColor=BackColor;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:self.tableView];
    
    header = [[SearchTableViewHeader alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 50)];
    header.title =@"待融资项目搜索热词";
    [self.tableView setTableHeaderView:header];
    
    if (self.type==0) {
        //加载关键词
        [self loadKeyWord];
    }
    
}

-(void)loadKeyWord
{
    //网络请求对象初始化
    httpUtils = [[HttpUtils alloc]init];
    //加载页面
    loadingView = [LoadingUtil shareinstance:self.view];
    [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    [httpUtils getDataFromAPIWithOps:KEYWORD postParam:nil type:0 delegate:self sel:@selector(requestKeyWord:)];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSMutableDictionary* dic = self.dataArray[row];
    
    if (self.type ==0) {
        RoadShowDetailViewController* controller =[[RoadShowDetailViewController alloc]init];
        controller.dic = dic;
        controller.title = navView.title;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        BannerViewController* controller =[[BannerViewController alloc]init];
        controller.title = navView.title;
        NSURL* url = [NSURL URLWithString:[dic valueForKey:@"href"]];
        controller.type = 3;
        controller.url = url;
        controller.dic = dic;
        [self.navigationController pushViewController:controller animated:YES];
        NSString* serverUrl = [NEWS_READ_COUNT stringByAppendingFormat:@"%@/",[dic valueForKey:@"id"]];
        [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:0 sel:nil];
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearch) {
        if (self.type==0) {
            return 190;
        }else{
            return 150;
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
            
            [cell.imgview sd_setImageWithURL:[dic valueForKey:@"thumbnail"] placeholderImage:IMAGENAMED(@"loading")];
            cell.titleLabel.text = [dic valueForKey:@"company_name"];
            cell.desclabel.text = [dic valueForKey:@"project_summary"];
            
            NSArray* arr = [dic valueForKey:@"industry_type"];
            NSString* str =@"";
            for (int i = 0; i<arr.count; i++) {
                str = [str stringByAppendingFormat:@"%@/",arr[i]];
                tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
            }
            
            cell.typeLabel.text = str;
            cell.votelabel.text = [[dic valueForKey:@"vote_sum"] stringValue];
            cell.priseLabel.text = [[dic valueForKey:@"like_sum"] stringValue];
            cell.colletcteLabel.text = [[dic valueForKey:@"collect_sum"] stringValue];
            cell.timeLabel.text = [dic valueForKey:@"roadshow_start_datetime"];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            tableView.contentSize = CGSizeMake(WIDTH(tableView), 190*self.dataArray.count+100);
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
            NSURL* url = [dic valueForKey:@"src"];
            [cell.imgview sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading")];
            cell.titleLabel.text = [dic valueForKey:@"title"];
            cell.desclabel.text = [dic valueForKey:@"source"];
            cell.typeLabel.text = [dic valueForKey:@"content"];
            cell.colletcteLabel.text = [[dic valueForKey:@"like"] stringValue];
            cell.priseLabel.text = [[dic valueForKey:@"readcount"] stringValue];
            cell.backgroundColor = WriteColor;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            tableView.contentSize = CGSizeMake(WIDTH(tableView), 150*self.dataArray.count+80);
            return cell;
        }
    }else{
        //声明静态字符串对象，用来标记重用单元格
        NSString* TableDataIdentifier=@"UserInfoViewCell";
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
        [self.tableView setEmptyImgFileName:@"Villain"];
    }
    [self.tableView reloadData];
}

#pragma mark - search bar delegate

- (CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar
{
    CGRect frame = searchBar.frame;
    frame.origin.x = 30;
    frame.size.width = WIDTH(self.view)-40;
    
    [navView.leftButton setAlpha:0];
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
    [navView.leftButton setAlpha:1];
}

- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar
{
    NSLog(@"搜索：%@",searchBar.searchField.text);
    
    header.title =[NSString stringWithFormat:@"包含\"%@\"的搜索结果",searchBar.searchField.text];
    loadingView.isTransparent = YES;
    [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    NSString* url;
    if (self.type==0) {
        url= [PROJECT_SEARCH stringByAppendingFormat:@"%d/%ld/",0,currentPage];
    }else{
        url= [NEWS_SEARCH stringByAppendingFormat:@"%d/%ld/",0,currentPage];
    }
    if(!httpUtils){
        httpUtils = [[HttpUtils alloc]init];
    }
    [httpUtils getDataFromAPIWithOps:url postParam:[NSDictionary dictionaryWithObject:searchBar.searchField.text forKey:@"value"] type:0 delegate:self sel:@selector(requestSearch:)];
}

- (void)searchBarTextDidChange:(INSSearchBar *)searchBar
{
	// Do whatever you deem necessary.
	// Access the text from the search bar like searchBar.searchField.text
}



#pragma searchResult
-(void)searchResult:(id)sender
{
    UILabel* label =(UILabel*)[sender view];
    SearchTableViewCell* cell = (SearchTableViewCell*)[label superview];
    NSDictionary* dic;
    NSArray* array = [cell.dataDic valueForKey:@"data"];
    
    NSString* key;
    if (self.type==0) {
        key  =@"word";
    }else{
        key = @"value";
    }
    for (int  i =0; i<array.count; i++) {
        if ([label.text isEqualToString:[array[i] valueForKey:key]]) {
            dic = array[i];
        }
    }
    header.title =[NSString stringWithFormat:@"包含\"%@\"的搜索结果",label.text];
    loadingView.isTransparent = YES;
    [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    
    NSString* url;
    if (self.type==0) {
        key  =@"word";
         url= [PROJECT_SEARCH stringByAppendingFormat:@"%@/%ld/",[dic valueForKey:@"id"],currentPage];
    }else{
        key = @"value";
        url= [NEWS_SEARCH stringByAppendingFormat:@"%@/%ld/",[dic valueForKey:@"key"],currentPage];
    }
    
    NSString* index = [dic valueForKey:key];
    if (!httpUtils) {
        httpUtils = [[HttpUtils alloc]init];
    }
    [httpUtils getDataFromAPIWithOps:url postParam:[NSDictionary dictionaryWithObject:index forKey:@"value"] type:0 delegate:self sel:@selector(requestSearch:)];
    
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
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] ==-1) {
            NSArray* arr=[jsonDic valueForKey:@"data"];
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
            [LoadingUtil closeLoadingView:loadingView];
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
        if ([status intValue] == 0 || [status intValue] ==-1) {
            self.dataArray =[jsonDic valueForKey:@"data"];
            isSearch = YES;
            [LoadingUtil closeLoadingView:loadingView];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        }
        self.tableView.content = [jsonDic valueForKey:@"msg"];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
}


- (void) viewWillAppear: (BOOL)inAnimated {
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:YES];
}

@end
