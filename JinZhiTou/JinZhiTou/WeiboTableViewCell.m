//
//  WeiboTableViewCell.m
//  Cycle
//
//  Created by air on 15/10/12.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "WeiboTableViewCell.h"
#import "GlobalDefine.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "NSString+SBJSON.h"
#import "UILabel+Data.h"
#import "TDUtil.h"
#import <QuartzCore/QuartzCore.h>
@implementation WeiboTableViewCell

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //头像
        self.headerImgView  = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.headerImgView.image  =IMAGENAMED(@"coremember");
        self.headerImgView.userInteractionEnabled  =YES;
        [self.headerImgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UserInfoAction:)]];
        [self addSubview:self.headerImgView];
        
        //名称
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.headerImgView)+10, Y(self.headerImgView), 50, 21)];
        self.nameLabel.font = FONT(@"Arial", 14);
        self.nameLabel.textColor = [UIColor blueColor];
        self.nameLabel.userInteractionEnabled = YES;
        [self.nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UserInfoAction:)]];
        [self addSubview:self.nameLabel];
        
        //公司
        self.companyLabel  = [[ UILabel alloc]initWithFrame:CGRectMake(POS_X(self.nameLabel), Y(self.nameLabel), 5, HEIGHT(self.nameLabel))];
        self.companyLabel.font  =FONT(@"Arial", 14);
        self.companyLabel.textColor  =FONT_COLOR_GRAY;
        [self addSubview:self.companyLabel];
        
        float position1 =WIDTH(self);
        float position2 =POS_X(self.companyLabel);
        //职务
        self.jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.companyLabel), Y(self.companyLabel), position1-position2-30, HEIGHT(self.companyLabel))];
        self.jobLabel.font = FONT(@"Arial", 14);
        self.jobLabel.textColor  = FONT_COLOR_GRAY;
        [self addSubview:self.jobLabel];
        
        //行业
        position1 =WIDTH(self);
        position2 =X(self.nameLabel);
        self.industryLabel  =[[ UILabel alloc]initWithFrame:CGRectMake(X(self.nameLabel), POS_Y(self.nameLabel)+10, position1-position2-10, HEIGHT(self.nameLabel))];
        self.industryLabel.font = FONT(@"Arial", 14);
        self.industryLabel.textColor = FONT_COLOR_GRAY;
        [self addSubview:self.industryLabel];
        
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.industryLabel), POS_Y(self.industryLabel)+5, WIDTH(self.industryLabel), 80)];
        self.contentLabel.font  =FONT(@"Arial", 14);
        self.contentLabel.textColor  =FONT_COLOR_BLACK;
        self.contentLabel.numberOfLines  =5;
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.contentLabel];
        
        self.expandButton = [[UIButton alloc]initWithFrame:CGRectMake(X(self.contentLabel)-15, POS_Y(self.contentLabel)+5, 50, 50)];
        self.expandButton.titleLabel.font  =FONT(@"Arial", 12);
        [self.expandButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.expandButton setTitle:@"全文" forState:UIControlStateNormal];
        [self.expandButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.expandButton];
       
        
        
        
    }
    return self;
}

-(void)setTableViewFrame:(UIView*)v
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , POS_Y(v)+5, WIDTH(self.priseView), HEIGHT(self.priseView)-55)];
    self.tableView.bounces=NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.scrollEnabled =  NO;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.priseView addSubview:self.tableView];
    
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
   
}
-(void)commentAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(weiboTableViewCell:contentId:atId:isSelf:)]) {
        [_delegate weiboTableViewCell:self contentId:[self.dic valueForKey:@"id"] atId:nil isSelf:NO];
    }
}

-(void)priseAction:(id)sender
{
    if (!httpUtils) {
        httpUtils = [[HttpUtils alloc]init];
    }
    NSString* serverUrl = [CYCLE_CONTENT_PRISE stringByAppendingFormat:@"%@/%d/",[self.dic
                           valueForKey:@"id"],1];
    [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestFinished:)];
}

-(void)shareAction:(id)sender
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:@"分享消息" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)deleteAction:(id)sender
{
    if (!httpUtils) {
        httpUtils = [[HttpUtils alloc]init];
    }
    NSString* serverUrl = [CYCLE_CONTENT_DELETE stringByAppendingFormat:@"%@/",[self.dic
                                                                                  valueForKey:@"id"]];
    [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestDeleteFinished:)];

}

- (IBAction)expandAction:(id)sender {
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"展开/收缩:%d",self.expandButton.isSelected] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)UserInfoAction:(UITapGestureRecognizer*)sender
{
    UILabel* label = (UILabel*)sender.view;
    if ([_delegate respondsToSelector:@selector(weiboTableViewCell:userId:isSelf:)]) {
        NSString* userId =@"";
        if ([label isKindOfClass:UILabel.class]) {
            userId = label.index;
        }else{
            userId = @"self";
        }
        
        [_delegate weiboTableViewCell:self userId:userId isSelf:NO];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic =self.dataArray[indexPath.row];
    currentSelectedCellIndex = indexPath;
    if(![[dic valueForKey:@"flag"] boolValue]){
        if ([_delegate respondsToSelector:@selector(weiboTableViewCell:contentId:atId:isSelf:)]) {
            [_delegate weiboTableViewCell:self contentId:[self.dic valueForKey:@"id"] atId:[dic valueForKey:@"id"] isSelf:NO];
        }
    }else{
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:@"删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag  = [[dic valueForKey:@"id"] integerValue];
        alertView.delegate = self;
        [alertView show];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"ReplyCell";
    //用TableDataIdentifier标记重用单元格
    ReplyTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    if (!cell) {
        CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        cell  =  [[ReplyTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), height)];
    }
    NSDictionary* dic  = self.dataArray[indexPath.row];
    NSString* name  = [dic valueForKey:@"name"];
    NSString* atLabel = [dic valueForKey:@"at_label"];
    NSString* atName = [dic valueForKey:@"at_name"];
    NSString* suffix =  [dic valueForKey:@"label_suffix"];
    NSString* content =  [dic valueForKey:@"content"];
    NSString* str = name;
    if (atLabel) {
        str = [str stringByAppendingString:atLabel];
    }
    
    if (atName) {
        str = [str stringByAppendingString:atName];
    }
    
    if (suffix) {
        str = [str stringByAppendingString:suffix];
    }
    
    if (content) {
        str = [str stringByAppendingString:content];
    }
    
    
    cell.textLabel.font =FONT(@"Arial", 12);
    cell.textLabel.text = str;
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}



-(void)showImage:(UITapGestureRecognizer*)sender
{
    NSMutableArray* dataArray = [self.dic valueForKey:@"imageName"];
    
    MWPhoto* photo;
    NSMutableArray* thumbs = [NSMutableArray new];
    
    for (int i= 0 ; i <dataArray.count;i++) {
        photo = [MWPhoto photoWithImage:[UIImage imageNamed:dataArray[i]]];
        [thumbs addObject:photo];
    }
    self.thumbs = thumbs;
    
    UIImageView* imageView = (UIImageView*)(sender.view);
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    BOOL autoPlayOnAppear = NO;
    
    displayActionButton = NO;
    displaySelectionButtons = NO;
    startOnGrid = YES;
    enableGrid = YES;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableSwipeToDismiss = NO;
    browser.displayNavArrows = displayNavArrows;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    browser.displayActionButton = displayActionButton;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.displaySelectionButtons = displaySelectionButtons;
    [browser setCurrentPhotoIndex:imageView.tag];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:nc animated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!httpUtils) {
        httpUtils = [[HttpUtils alloc]init];
    }
    NSString* serverUrl = [CYCLE_CONTENT_REPLY_DELETE stringByAppendingFormat:@"%ld/",alertView.tag];
    [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestDeleteReplyFinished:)];
}

-(void)setDic:(NSMutableDictionary *)dic
{
    if (dic) {
        self->_dic =dic;
        
        if ([[dic valueForKey:@"flag"] boolValue]) {
            self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(POS_X(self.expandButton), Y(self.expandButton), 50, 50)];
            self.deleteButton.titleLabel.font  =FONT(@"Arial", 12);
            [self.deleteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
            [self.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.deleteButton];
        }
        
        
        NSArray* pics =[self.dic valueForKey:@"pics"];
        NSInteger value = pics.count;
        NSInteger number = value/3;
        
        if ( value % 3 !=0) {
            number++;
        }else if (value<3 && value >0){
            number++;
        }
        self.imgContentView = [[UIView alloc]initWithFrame:CGRectMake(X(self.contentLabel), POS_Y(self.expandButton)+10, WIDTH(self.contentLabel), number*80)];
        [self addSubview:self.imgContentView];
        
        UIImageView* imgView;
        float pos_x =0,pos_y=0;
        number = 0;
        NSMutableArray* array =[NSMutableArray new];
        for (int i = 0; i < value; i ++) {
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(pos_x, pos_y, 70, 70)];
            imgView.tag = i;
            imgView.userInteractionEnabled  = YES;
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImage:)]];
            [self.imgContentView addSubview:imgView];
            NSURL* url =[NSURL URLWithString:[pics objectAtIndex:i]];
            [imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"coremember")];
            
            [array addObject:[NSString stringWithFormat:@"%d",i+1]];
            pos_x += 70+10;
            
            if ((i+1)%3==0) {
                pos_x = 0;
                pos_y += 70+10;
                number++;
            }
        }
        NSMutableDictionary* dictemp = [[NSMutableDictionary alloc]init];
        
        [dictemp setValue:array forKey:@"imageName"];
        
        //分享点赞
        self.funView = [[UIView alloc]initWithFrame:CGRectMake(X(self.contentLabel), POS_Y(self.imgContentView), WIDTH(self.contentLabel), 30)];
        [self addSubview:self.funView];
        
        
        //点赞，分享,评论
        NSMutableArray* dataCriticalArray = [self.dic valueForKey:@"comment"];
        
        //评论
        self.criticalButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self.funView)-70, 0, 50, 25)];
        [self.criticalButton setTitleColor:FONT_COLOR_GRAY forState:UIControlStateNormal];
        [self.criticalButton setTitle:[NSString stringWithFormat:@"%ld",dataCriticalArray.count] forState:UIControlStateNormal];
        [self.criticalButton.titleLabel setFont:FONT(@"Arial", 10)];
        [self.criticalButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.criticalButton setImage:IMAGENAMED(@"gossip_comment") forState:UIControlStateNormal];
        [self.funView addSubview:self.criticalButton];
        
        //分享
        self.shareButton = [[UIButton alloc]initWithFrame:CGRectMake(X(self.criticalButton)-50, Y(self.criticalButton), WIDTH(self.criticalButton), HEIGHT(self.criticalButton))];
        [self.shareButton setTitleColor:FONT_COLOR_GRAY forState:UIControlStateNormal];
        [self.shareButton setTitle:@"转发" forState:UIControlStateNormal];
        [self.shareButton.titleLabel setFont:FONT(@"Arial", 10)];
        [self.shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareButton setImage:IMAGENAMED(@"gossip_share") forState:UIControlStateNormal];
        [self.funView addSubview:self.shareButton];
        
        //点赞
        NSMutableArray* dataPriseArray = [self.dic valueForKey:@"likers"];
        self.priseButton = [[UIButton alloc]initWithFrame:CGRectMake(X(self.shareButton)-50, Y(self.shareButton), WIDTH(self.shareButton), HEIGHT(self.shareButton))];
        [self.priseButton setTitleColor:FONT_COLOR_GRAY forState:UIControlStateNormal];
        [self.priseButton setTitle:[NSString stringWithFormat:@"%ld",dataPriseArray.count] forState:UIControlStateNormal];
        [self.priseButton.titleLabel setFont:FONT(@"Arial", 10)];
        [self.priseButton addTarget:self action:@selector(priseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.priseButton setImage:IMAGENAMED(@"gossip_like_normal") forState:UIControlStateNormal];
        [self.funView addSubview:self.priseButton];
        
        //点赞评论区域
        
        self.priseView = [[UIView alloc]initWithFrame:CGRectMake(X(self.contentLabel), POS_Y(self.funView), WIDTH(self.contentLabel), 150)];
        self.priseView.layer.cornerRadius = 5;
        self.priseView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.priseView];
        
        UILabel* label;
        pos_x =30,pos_y =10;
        NSDictionary* dic;
        for (int i = 0; i<dataPriseArray.count; i++) {
            dic =dataPriseArray[i];
            label = [[UILabel alloc]initWithFrame:CGRectMake(pos_x,pos_y, 40, 15)];
            label.index =[NSString stringWithFormat:@"%@",[dic valueForKey:@"uid"]];
            label.text  =[NSString stringWithFormat:@"%@,",[dic valueForKey:@"name"]];
            label.font  = FONT(@"Arial", 10);
            label.textColor = [UIColor blueColor];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UserInfoAction:)]];
            [self.priseView addSubview:label];
            pos_x+=WIDTH(label);
            if (pos_x > WIDTH(self.priseView)-40) {
                pos_y+=HEIGHT(label)+5;
                pos_x = 10;
            }
        }
        
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 15, 15)];
        imgview.image = IMAGENAMED(@"like_white");
        [self.priseView addSubview:imgview];
        
        
        [self setTableViewFrame:label];
        
        self.dataArray = dataCriticalArray;
        
       

    }
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.thumbs.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return [self.thumbs objectAtIndex:index];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [[UIApplication sharedApplication].windows[0].rootViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma ASIHttpRequest
-(void)requestData:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            self.dataArray  = [dic valueForKey:@"data"];
        }else{
            
        }
        [[DialogUtil sharedInstance]showDlg:self textOnly:[dic valueForKey:@"msg"]];
    }
}

-(void)requestFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            if ([_delegate respondsToSelector:@selector(weiboTableViewCell:refresh:)]) {
                [_delegate weiboTableViewCell:self refresh:YES];
            }
        }
        [[DialogUtil sharedInstance]showDlg:self.superview textOnly:[dic valueForKey:@"msg"]];
    }
}
-(void)requestDeleteReplyFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            NSDictionary* tempDic =self.dataArray[currentSelectedCellIndex.row];
            if ([self.dataArray containsObject:tempDic]) {
                [self.dataArray removeObject:tempDic];
                [self.tableView reloadData];
            }
        }
    }
}

-(void)requestDeleteFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            if ([_delegate respondsToSelector:@selector(weiboTableViewCell:deleteDic:)]) {
                [_delegate weiboTableViewCell:self deleteDic:self.dic];

            }
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
}

@end
