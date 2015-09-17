//
//  CustomImagePickerController.m
//  MeiJiaLove
//
//  Created by 陈生珠 on 13-7-9.
//  Copyright (c) 2013年 陈生珠. All rights reserved.
//

#import "CustomImagePickerController.h"
#import "IphoneScreen.h"
#import "UIImage+Cut.h"
#import "GlobalDefine.h"
@interface CustomImagePickerController ()

@end

@implementation CustomImagePickerController
@synthesize customDelegate = _customDelegate;

#pragma mark get/show the UIView we want
/**
 *	@brief	获取指定名称视图
 *
 *	@param 	aＶiew  父视图，需要从该视图子视图中查找
 *  @param  name   需要查找视图名称，拥有该名称得视图从aＶiew视图子视图中获取
 *
 *	@return	UIView 从aView子视图中获取到名称为name的视图
 */
- (UIView *)findView:(UIView *)aView withName:(NSString *)name {
	Class cl = [aView class];
	NSString *desc = [cl description];
	//判断是否aView视图为name属性，若是直接返回aView
	if ([name isEqualToString:desc])
		return aView;
    //遍历aView子视图，以便从中获取name属性视图
	for (NSUInteger i = 0; i < [aView.subviews count]; i++) {
		UIView *subView = [aView.subviews objectAtIndex:i];
		subView = [self findView:subView withName:name];
		if (subView)
			return subView;
	}
	return nil;
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *backgroundImage = [UIImage imageNamed:@"titlebar"];
    navigationController.navigationItem.title=@"照相啊";
    if (version >= 5.0) {//titlebar
        [navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [navigationController.navigationBar insertSubview:[[UIImageView alloc] initWithImage:backgroundImage] atIndex:1];
    }
    
    if(self.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *deviceImage = [UIImage imageNamed:@"camera_button_switch_camera.png"];
        UIButton *deviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deviceBtn setBackgroundImage:deviceImage forState:UIControlStateNormal];
        [deviceBtn addTarget:self action:@selector(swapFrontAndBackCameras:) forControlEvents:UIControlEventTouchUpInside];
        [deviceBtn setFrame:CGRectMake(250, 20, deviceImage.size.width, deviceImage.size.height)];
        
        UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];
        if (PLCameraView) {
            [PLCameraView addSubview:deviceBtn];
        }
        
        
        [self setShowsCameraControls:NO];
        
        UIView *overlyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,ScreenHeight)];
        [overlyView setBackgroundColor:[UIColor clearColor]];
        
        [overlyView addSubview:deviceBtn];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backImage = [UIImage imageNamed:@"camera_cancel.png"];
        [backBtn setImage: backImage forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setFrame:CGRectMake(8,  ScreenHeight - 39, backImage.size.width, backImage.size.height)];
        [overlyView addSubview:backBtn];
        
        UIImage *camerImage = [UIImage imageNamed:@"camera_shoot.png"];
        UIButton *cameraBtn = [[UIButton alloc] initWithFrame:
                               CGRectMake(110,  ScreenHeight - 39, camerImage.size.width, camerImage.size.height)];
        [cameraBtn setImage:camerImage forState:UIControlStateNormal];
        [cameraBtn addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        [overlyView addSubview:cameraBtn];
        
        UIImage *photoImage = [UIImage imageNamed:@"camera_album.png"];
        UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, ScreenHeight - 39, 70, 40)];
        [photoBtn setImage:photoImage forState:UIControlStateNormal];
        [photoBtn addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchUpInside];
        [overlyView addSubview:photoBtn];
        
        self.cameraOverlayView = overlyView;

        
        //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
        NSDictionary * dict = [NSDictionary dictionaryWithObject:WriteColor forKey:NSForegroundColorAttributeName];
        
        //大功告成
        navigationController.navigationBar.titleTextAttributes = dict;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.view.backgroundColor  =ColorTheme;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - ButtonAction Methods

- (IBAction)swapFrontAndBackCameras:(id)sender {
    if (self.cameraDevice ==UIImagePickerControllerCameraDeviceRear ) {
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }else {
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}


- (void)closeView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)takePicture
{
    [super takePicture];
}

- (void)showPhoto
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image clipImageWithScaleWithsize:CGSizeMake(320, 480)];
    [picker dismissViewControllerAnimated:NO completion:^{
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    #else
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    #endif
        //获取到照相机图片
        [_customDelegate cameraPhoto:image];
    }];
}
//取消照相
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    #else
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    #endif
    if(_isSingle){
        //[picker dismissModalViewControllerAnimated:YES];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else{
        if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
            self.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            //[picker dismissModalViewControllerAnimated:YES];
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

@end
