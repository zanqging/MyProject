//
//  PublishViewController.m
//  Cycle
//
//  Created by air on 15/10/12.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "PublishViewController.h"
#import <Photos/Photos.h>
#import "SDImageCache.h"
#import "MWCommon.h"
#import "GlobalDefine.h"
#import "UConstants.h"
#import "HttpUtils.h"
#import "TDUtil.h"
#import "DialogUtil.h"
#import "UIImage+Crop.h"
#import "NSString+SBJSON.h"
#import "PECropViewController.h"
#import "CustomImagePickerController.h"
@interface PublishViewController ()<CustomImagePickerControllerDelegate,UITextViewDelegate>
{
    NSMutableArray *_selections;
    UIScrollView* scrollView;
    
}
@property(retain,nonatomic)CustomImagePickerController* customPicker;
@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"圈子";
    self.view.backgroundColor  =ColorTheme;
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"发布话题"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:self.title forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    [self.navView.rightButton setImage:nil forState:UIControlStateNormal];
    [self.navView.rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [self.navView.rightTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(publishAction:)]];
    [self.view addSubview:self.navView];
    
    scrollView  =[[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    scrollView.backgroundColor  =BackColor;
    [self.view addSubview:scrollView];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, WIDTH(self.view)-20, 150)];
    self.textView.font  =SYSTEMBOLDFONT(16);
    self.textView.text  =PUBLISH_CONTENT;
    self.textView.textColor  =FONT_COLOR_GRAY;
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDone;
    [scrollView addSubview:self.textView];
    
    self.imgContentView =[[UIView alloc]initWithFrame:CGRectMake(X(self.textView), POS_Y(self.textView)+20, WIDTH(self.textView), 80)];
    [scrollView addSubview:self.imgContentView];
    
    float w =(WIDTH(self.view)-50)/4;
    self.btnSelect = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, w, w)];
    [self.btnSelect addTarget:self action:@selector(showSecureTextEntryAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSelect setImage:IMAGENAMED(@"AddGroupMemberBtnHL") forState:UIControlStateNormal];
    [self.btnSelect.titleLabel setFont:[UIFont fontWithName:@"Arial" size:75]];
    [self.btnSelect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.imgContentView addSubview:self.btnSelect];
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    self.isSelectPic = NO;
    [self loadAssets];
}


-(BOOL)publishAction:(id)sender
{
    
    NSString* content = self.textView.text;
    NSMutableArray* postArray = [[NSMutableArray alloc]init];
    for (UIView* v in self.imgContentView.subviews) {
        if ([v isKindOfClass:UIImageView.class]) {
            UIImage* image = ((UIImageView*)v).image;
            image = [image imageByCroppingSelf];
            [postArray addObject:image];
        }
    }
    
    if ([content isEqualToString:PUBLISH_CONTENT] || [content isEqualToString:@""]) {
        if ((!postArray || postArray.count==0)) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"发表内容不能为空"];
            return false;
        }
    }
    
    if ([content isEqualToString:PUBLISH_CONTENT]) {
        content =@"";
    }
    
    //发布内容
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc]init];
    [dataDic setValue:content forKey:@"content"];
    [dataDic setValue:postArray forKey:@"files"];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"publishContent" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:dataDic,@"data", nil]];
    [self performSelector:@selector(dissmissController) withObject:nil afterDelay:1];
//    [self dissmissController];
    
    return true;
}

- (void)showSecureTextEntryAlert {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    __block PublishViewController* blockSelf = self;
    // Create the actions.
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [blockSelf takePhoto:nil];
    }];
    
    UIAlertAction *chooiceAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [blockSelf btnSelect:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    // Add the actions.
    [alertController addAction:takePhotoAction];
    [alertController addAction:chooiceAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)btnSelect:(id)sender {
    self.isSelectPic  =YES;
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
//    MWPhoto *photo;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    BOOL autoPlayOnAppear = NO;
    
    
    displayActionButton = NO;
    displaySelectionButtons = YES;
    startOnGrid = YES;
    enableGrid = YES;
    
    @synchronized(_assets) {
        NSMutableArray *copy = [_assets copy];
        if (NSClassFromString(@"PHAsset")) {
            // Photos library
            UIScreen *screen = [UIScreen mainScreen];
            CGFloat scale = screen.scale;
            // Sizing is very rough... more thought required in a real implementation
            CGFloat imageSize = MAX(screen.bounds.size.width, screen.bounds.size.height) * 1.5;
            CGSize imageTargetSize = CGSizeMake(imageSize * scale, imageSize * scale);
            CGSize thumbTargetSize = CGSizeMake(imageSize / 3.0 * scale, imageSize / 3.0 * scale);
            for (PHAsset *asset in copy) {
                [photos addObject:[MWPhoto photoWithAsset:asset targetSize:imageTargetSize]];
                [thumbs addObject:[MWPhoto photoWithAsset:asset targetSize:thumbTargetSize]];
            }
        } else {
            // Assets library
            for (ALAsset *asset in copy) {
                MWPhoto *photo = [MWPhoto photoWithURL:asset.defaultRepresentation.url];
                [photos addObject:photo];
                MWPhoto *thumb = [MWPhoto photoWithImage:[UIImage imageWithCGImage:asset.thumbnail]];
                [thumbs addObject:thumb];
                if ([asset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo) {
                    photo.videoURL = asset.defaultRepresentation.url;
                    thumb.isVideo = true;
                }
            }
        }
    }
    
    
    self.photos = photos;
    self.thumbs = thumbs;
    // Create browser
    if (!self.browser) {
        self.browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    }
    self.browser.displayActionButton = displayActionButton;
    self.browser.displayNavArrows = displayNavArrows;
    self.browser.displaySelectionButtons = displaySelectionButtons;
    self.browser.alwaysShowControls = displaySelectionButtons;
    self.browser.zoomPhotosToFill = YES;
    self.browser.enableGrid = enableGrid;
    self.browser.startOnGrid = startOnGrid;
    self.browser.enableSwipeToDismiss = NO;
    self.browser.autoPlayOnAppear = autoPlayOnAppear;
    [self.browser setCurrentPhotoIndex:0];
    
    //    browser.customImageSelectedIconName = @"ImageSelected.png";
    //    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    
    // Reset selections
    if (displaySelectionButtons) {
        if(!_selections){
            _selections = [NSMutableArray new];
            for (int i = 0; i < photos.count; i++) {
                [_selections addObject:[NSNumber numberWithBool:NO]];
            }
        }
    }
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
}

-(void)back:(id)sender
{
    [self dissmissController];
}

-(void)getSelectImage:(NSArray *)imageArr
{
    self.imgSelectArray  = [NSMutableArray arrayWithArray:imageArr];
    
    for (UIView* v in self.imgContentView.subviews){
        if (![v isKindOfClass:UIButton.class]) {
            [v removeFromSuperview];
        }
    }
    UIImageView* imgView;
    float pos_x =0,pos_y=10;
    
    float w = (WIDTH(self.view)-50)/4;
    if (self.imgSelectArray.count > 0) {
        for (int i = 0; i < self.imgSelectArray.count; i ++) {
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(pos_x, pos_y, w,w)];
            imgView.tag = i;
            imgView.userInteractionEnabled  = YES;
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImage:)]];
            [self.imgContentView addSubview:imgView];
            imgView.image = [self.imgSelectArray objectAtIndex:i];
            
            pos_x += w +10;
            
            if ((i+1)%4==0) {
                pos_x = 0;
                pos_y += w +10;
            }
        }
        
        CGRect frame = self.btnSelect.frame;
        [self.btnSelect removeFromSuperview];
        if (self.imgSelectArray.count<9) {
           
            frame.origin.x = pos_x;
            frame.origin.y = pos_y;
            [self.btnSelect setFrame:frame];
            [self.imgContentView addSubview:self.btnSelect];
        }
        
         [self.imgContentView setFrame:CGRectMake(self.imgContentView.frame.origin.x, self.imgContentView.frame.origin.y, self.imgContentView.frame.size.width, frame.size.height+frame.origin.y+20)];
    }
}

-(void)showImage:(UITapGestureRecognizer*)sender
{
    UIImageView* imageView = (UIImageView*)(sender.view);
    self.isSelectPic = NO;
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    BOOL autoPlayOnAppear = NO;
    
    
    displayActionButton = NO;
    displaySelectionButtons = YES;
    startOnGrid = YES;
    enableGrid = YES;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:imageView.tag];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if (self.isSelectPic) {
        return _photos.count;
    }else{
        return self.imgSelectArray.count;
    }
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (self.isSelectPic) {
        if (index < _photos.count)
            return [_photos objectAtIndex:index];
        return nil;
    }else{
        return [self.imgSelectAssetArray objectAtIndex:index];
    }
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
    int count = 0;
    for (int i = 0; i < _selections.count; i++) {
        if ([_selections[i] boolValue]) {
            count ++;
        }
    }
    
    if (count<=9) {
        if (count<9) {
            photoBrowser.limit  =NO;
        }else{
            photoBrowser.limit  =YES;
        }
    }
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    NSMutableArray* array = [NSMutableArray new];
    for (int i = 0; i < _selections.count; i++) {
        if ([_selections[i] boolValue]) {
            if (!self.imgSelectAssetArray) {
                self.imgSelectAssetArray = [NSMutableArray new];
            }
            [self.imgSelectAssetArray addObject:[_photos objectAtIndex:i]];
            UIImage* image;
            if (NSClassFromString(@"PHAsset")) {
                PHAsset* photo = [_assets objectAtIndex:i];
                
                // 在资源的集合中获取第一个集合，并获取其中的图片
                PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
                [imageManager requestImageForAsset:photo
                                        targetSize:PHImageManagerMaximumSize
                                       contentMode:PHImageContentModeDefault
                                           options:nil
                                     resultHandler:^(UIImage *result, NSDictionary *info) {
                                         
                                         // 得到一张 UIImage，展示到界面上
                                         if (result) {
                                             [array addObject:result];
                                         }
                                         
                                         [self getSelectImage:array];
                                     }];
            }else{
                ALAsset* asset = _assets[i];
                image = [self fullResolutionImageFromALAsset:asset];
                [array addObject:image];
            }
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}
#pragma mark - Load Assets

- (void)loadAssets {
    if (NSClassFromString(@"PHAsset")) {
        
        // Check library permissions
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self performLoadAssets];
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) {
            [self performLoadAssets];
        }
        
    } else {
        
        // Assets library
        [self performLoadAssets];
        
    }
}

- (void)performLoadAssets {
    
    // Initialise
    _assets = [NSMutableArray new];
    
    // Load
    if (NSClassFromString(@"PHAsset")) {
        
        // Photos library iOS >= 8
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchOptions *options = [PHFetchOptions new];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResults = [PHAsset fetchAssetsWithOptions:options];
            [fetchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_assets addObject:obj];
            }];
        });
        
    } else {
        
        // Assets Library iOS < 8
        _ALAssetsLibrary = [[ALAssetsLibrary alloc] init];
        
        // Run in the background as it takes a while to get all assets from the library
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
            NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];
            
            // Process assets
            void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                    if ([assetType isEqualToString:ALAssetTypePhoto] || [assetType isEqualToString:ALAssetTypeVideo]) {
                        [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                        NSURL *url = result.defaultRepresentation.url;
                        [_ALAssetsLibrary assetForURL:url
                                          resultBlock:^(ALAsset *asset) {
                                              if (asset) {
                                                  @synchronized(_assets) {
                                                      [_assets addObject:asset];
                                                  }
                                              }
                                          }
                                         failureBlock:^(NSError *error){
                                             NSLog(@"operation was not successfull!");
                                         }];
                        
                    }
                }
            };
            
            // Process groups
            void (^ assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
                if (group != nil) {
                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
                    [assetGroups addObject:group];
                }
            };
            
            // Process!
            [_ALAssetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                            usingBlock:assetGroupEnumerator
                                          failureBlock:^(NSError *error) {
                                              NSLog(@"There is an error");
                                          }];
            
        });
        
    }
    
}

#pragma UploadPic
//*********************************************************照相机功能*****************************************************//


//照相功能

-(void)takePhoto:(NSDictionary*)dic
{
    [self showPicker];
}

- (void)showPicker
{
    CustomImagePickerController* picker = [[CustomImagePickerController alloc] init];
    
    //创建返回按钮
    UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NUMBERFORTY, NUMBERTHIRTY)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [leftButton setStyle:UIBarButtonItemStylePlain];
    //创建设置按钮
    btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NUMBERFORTY, NUMBERTHIRTY)];
    btn.tintColor=WriteColor;
    btn.titleLabel.textColor=WriteColor;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    picker.navigationItem.leftBarButtonItem=leftButton;
    picker.navigationItem.rightBarButtonItem=rightButton;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else{
        [picker setIsSingle:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    [picker setCustomDelegate:self];
    self.customPicker=picker;
    [self presentViewController:self.customPicker animated:YES completion:nil];
}

- (void)cameraPhoto:(UIImage *)imageCamera  //选择完图片
{
    [self openEditor:imageCamera];
}

- (void)openEditor:(UIImage*)imageCamera
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = imageCamera;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    MWPhoto* photo  = [MWPhoto photoWithImage:croppedImage];
    if (!self.imgSelectAssetArray) {
        self.imgSelectAssetArray = [[NSMutableArray alloc]init];
    }
    [self.imgSelectAssetArray addObject:photo];
    if (!self.imgSelectArray) {
        self.imgSelectArray = [[NSMutableArray alloc]init];
    }
    [self.imgSelectArray addObject:croppedImage];
    
    [self getSelectImage:self.imgSelectArray];
}


-(void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


//取消照相
-(void)cancelCamera
{
    
}


//*********************************************************照相机功能结束*****************************************************//
#pragma UITextView
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.textView.font  =SYSTEMBOLDFONT(18);
    textView.text =@"";
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        self.textView.font  =SYSTEMBOLDFONT(16);
        textView.text = PUBLISH_CONTENT;
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%@",textView.text);
}

- (BOOL)textView:(UITextView *)tv shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [tv resignFirstResponder];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

#pragma ASIHttpRequest
-(void)dissmissController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
}

@end
