//
//  ActionHeader.m
//  Cycle
//
//  Created by air on 15/10/14.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "ActionHeader.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import <QuartzCore/QuartzCore.h>
@interface ActionHeader()
{
    HttpUtils* httpUtils;
}
@end

@implementation ActionHeader
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        }
    return self;
}

-(void)btnAction:(UIButton*)sender
{
    NSInteger index = sender.tag;
    NSString* className =@"CyclePriseTableViewCell";
    switch (index) {
        case 1:
            className = @"CycleShareTableViewCell";
            break;
        case 2:
            className = @"CycleShareTableViewCell";
            break;
        case 3:
            className = @"CyclePriseTableViewCell";
            break;
        default:
            className = @"CyclePriseTableViewCell";
            break;
    }
    if ([self.delegate respondsToSelector:@selector(actionHeader:selectedIndex:className:)]) {
        [_delegate actionHeader:self selectedIndex:index className:className];
    }
}

-(void)setDic:(NSDictionary *)dic
{
    self->_dic  = dic;
    if (self.dic) {
        
        //头像
        headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self addSubview:headerImgView];
        
        //头像
        NSURL* url = [NSURL URLWithString:[dic valueForKey:@"photo"]];
        [headerImgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"coremember")];
        
        
        //名称
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(headerImgView)+10, Y(headerImgView), 50, 21)];
        nameLabel.font = SYSTEMFONT(14);
        nameLabel.textColor = [UIColor blueColor];
        [self addSubview:nameLabel];
        
        //姓名
        nameLabel.text = [dic valueForKey:@"name"];
        
        companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(nameLabel)+5, Y(nameLabel), 200, HEIGHT(nameLabel))];
        companyLabel.textColor = FONT_COLOR_GRAY;
        companyLabel.font = FONT(@"Arial", 14);
        [self addSubview:companyLabel];
        
        companyLabel.text = [dic valueForKey:@"position"];
        
        
        industoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(nameLabel), POS_Y(nameLabel)+5, WIDTH(nameLabel)+WIDTH(companyLabel), HEIGHT(nameLabel))];
        industoryLabel.font = FONT(@"Arial", 14);
        industoryLabel.textColor = FONT_COLOR_GRAY;
        [self addSubview:industoryLabel];
        
         industoryLabel.text = [dic valueForKey:@"city"];
        
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(nameLabel), POS_Y(industoryLabel)+10, WIDTH(self)-70, 50)];
        contentLabel.textColor = FONT_COLOR_BLACK;
        contentLabel.font = FONT(@"Arial", 14);
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:contentLabel];
        
        //内容
        [TDUtil setLabelMutableText:contentLabel content:[dic valueForKey:@"content"] lineSpacing:5 headIndent:0];
//        contentLabel.text = [dic valueForKey:@"content"];
        
        //事件
        dateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(contentLabel), POS_Y(contentLabel)+5, 100, 10)];
        dateTimeLabel.font  =FONT(@"Arial", 10);
        dateTimeLabel.text = [dic valueForKey:@"datetime"];
        dateTimeLabel.textColor  =FONT_COLOR_GRAY;
        [self addSubview:dateTimeLabel];
        
        //图片内容
        NSArray* pics =[self.dic valueForKey:@"pic"];
        NSInteger value = pics.count;
        NSInteger number = value/3;
        
        if ( value % 3 !=0) {
            number++;
        }else if (value<3 && value >0){
            number++;
        }
        imgContentView = [[UIView alloc]initWithFrame:CGRectMake(X(contentLabel), POS_Y(dateTimeLabel)+10,240, number*80)];
        [self addSubview:imgContentView];
        
        float pos_x =0,pos_y=0;
        number = 0;
        NSMutableArray* array =[NSMutableArray new];
        
        UIImageView* imgView;
        for (int i = 0; i < value; i ++) {
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(pos_x, pos_y, 70, 70)];
            imgView.tag = i;
            imgView.userInteractionEnabled  = YES;
            imgView.layer.masksToBounds = YES;
            imgView.contentMode  =UIViewContentModeScaleAspectFill;
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImage:)]];
            [imgContentView addSubview:imgView];
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
        
        
        //点赞，分享,评论
        //评论
        criticalButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)-70, POS_Y(imgContentView)+10, 50, 25)];
        [criticalButton setTitleColor:FONT_COLOR_GRAY forState:UIControlStateNormal];
        [criticalButton.titleLabel setFont:FONT(@"Arial", 10)];
        [
         criticalButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [criticalButton setImage:IMAGENAMED(@"gossip_comment") forState:UIControlStateNormal];
        [self addSubview:criticalButton];
        
        //点赞
        priseButton = [[UIButton alloc]initWithFrame:CGRectMake(X(criticalButton)-50, Y(criticalButton), WIDTH(criticalButton), HEIGHT(criticalButton))];
        [priseButton setTitleColor:FONT_COLOR_GRAY forState:UIControlStateNormal];
        [priseButton.titleLabel setFont:FONT(@"Arial", 10)];
        [priseButton addTarget:self action:@selector(priseAction:) forControlEvents:UIControlEventTouchUpInside];
        [priseButton setImage:IMAGENAMED(@"gossip_like_normal") forState:UIControlStateNormal];
        [self addSubview:priseButton];
        
        
        //底部
        UIImageView* lineImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(priseButton)+10, WIDTH(self), 1)];
        lineImageView.backgroundColor = FONT_COLOR_GRAY;
        [self addSubview:lineImageView];

        
        //点赞，分享,评论
        //点赞
        priseListButton = [[UIButton alloc]initWithFrame:CGRectMake(0, POS_Y(lineImageView), WIDTH(self)/3, 40)];
        priseListButton.tag =1;
        [priseListButton setTitleColor:FONT_COLOR_BLACK forState:UIControlStateNormal];
        [priseListButton.titleLabel setFont:FONT(@"Arial", 10)];
        [priseListButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:priseListButton];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(priseListButton), Y(priseListButton)+10, 1, HEIGHT(priseListButton)-20)];
        imgView.backgroundColor = lineImageView.backgroundColor;
        [self addSubview:imgView];
        
        //评论
        criticalListButton = [[UIButton alloc]initWithFrame:CGRectMake(POS_X(priseListButton), Y(priseListButton), WIDTH(priseListButton), HEIGHT(priseListButton))];
        criticalListButton.tag =3;
        [criticalListButton setTitleColor:FONT_COLOR_GRAY forState:UIControlStateNormal];
        [criticalListButton setTitle:@"评论 46" forState:UIControlStateNormal];
        [criticalListButton.titleLabel setFont:FONT(@"Arial", 10)];
        [criticalListButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:criticalListButton];
        
        NSMutableArray* dataArray = [self.dic valueForKey:@"like"];
        [priseButton setTitle:[NSString stringWithFormat:@"%ld",dataArray.count] forState:UIControlStateNormal];
        [priseListButton setTitle:[NSString stringWithFormat:@"赞  %ld",dataArray.count] forState:UIControlStateNormal];
        
        dataArray = [self.dic valueForKey:@"comment"];
        [criticalButton setTitle:[NSString stringWithFormat:@"%ld",dataArray.count] forState:UIControlStateNormal];
        [criticalListButton setTitle:[NSString stringWithFormat:@"评论  %ld",dataArray.count] forState:UIControlStateNormal];
        lineImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(lineImageView)+40, WIDTH(self), 1)];
        lineImageView.backgroundColor = FONT_COLOR_GRAY;
        [self addSubview:lineImageView];
        
        [self setFrame:CGRectMake(0, 0, WIDTH(self), POS_Y(lineImageView))];

    }
}

-(void)showImage:(UITapGestureRecognizer*)sender
{
    NSMutableArray* dataArray = [self.dic valueForKey:@"pic"];
    
    MWPhoto* photo;
    NSMutableArray* thumbs = [NSMutableArray new];
    
    for (int i= 0 ; i <dataArray.count;i++) {
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:dataArray[i]]];
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

//- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
//    return [[_selections objectAtIndex:index] boolValue];
//}
//
////- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
////    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
////}
//
//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
//    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
//}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [[UIApplication sharedApplication].windows[0].rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)commentAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(actionHeader:data:critical:)]) {
        [_delegate actionHeader:self data:self.dic critical:YES];
    }
}

-(void)priseAction:(id)sender
{
    if (!httpUtils) {
        httpUtils = [[HttpUtils alloc]init];
    }
    NSString* serverUrl = [CYCLE_CONTENT_PRISE stringByAppendingFormat:@"%@/%d/",[self.dic
                                                                                  valueForKey:@"id"],![[self.dic valueForKey:@"is_like"] boolValue]];
    [httpUtils getDataFromAPIWithOps:serverUrl type:0 delegate:self sel:@selector(requestPriseFinished:) method:@"GET"];
    
}

-(void)requestPriseFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            BOOL flag = ![[self.dic valueForKey:@"is_like"] boolValue];
            NSString* flagStr = flag==true?@"True":@"False";
            [self.dic setValue:flagStr forKey:@"is_like"];
            NSInteger num = [priseButton.titleLabel.text integerValue];
            
            flag=NO;
            if ([[self.dic valueForKey:@"is_like"]boolValue]) {
                [priseButton setTitle:[NSString stringWithFormat:@"%ld",++num] forState:UIControlStateNormal];
                [priseListButton setTitle:[NSString stringWithFormat:@"赞  %ld",num] forState:UIControlStateNormal];
                
                flag = YES;
            }else{
                [priseButton setTitle:[NSString stringWithFormat:@"%ld",--num] forState:UIControlStateNormal];
                [priseListButton setTitle:[NSString stringWithFormat:@"赞  %ld",num] forState:UIControlStateNormal];
                
            }
            
            if ([_delegate respondsToSelector:@selector(actionHeader:data:prise:)]) {
                [_delegate actionHeader:self data:[dic valueForKey:@"data"] prise:flag];
            }
        }
        [[DialogUtil sharedInstance]showDlg:self.superview textOnly:[dic valueForKey:@"msg"]];
    }
}

@end
