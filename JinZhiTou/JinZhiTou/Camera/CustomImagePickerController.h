//
//  CustomImagePickerController.h
//  MeiJiaLove
//
//  Created by 陈生珠 on 13-7-9.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomImagePickerControllerDelegate;

@interface CustomImagePickerController : UIImagePickerController
<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    __unsafe_unretained id<CustomImagePickerControllerDelegate> _customDelegate;
}
@property(nonatomic)BOOL isSingle;
@property(nonatomic,assign)id<CustomImagePickerControllerDelegate> customDelegate;
@end

//协议
@protocol CustomImagePickerControllerDelegate <NSObject>

/**
 *	@brief 协议	获取照相机照片
 *
 *	@param 	image 获取到通过照相机功能拍的图片
 *
 *	@return	void
 */
- (void)cameraPhoto:(UIImage *)image;
/**
 *	@brief 协议	取消照相功能
 *
 *	@return	void
 */
- (void)cancelCamera;
@end
