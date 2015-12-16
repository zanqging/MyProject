//
//  UIImage+Crop.h
//  JinZhiTou
//
//  Created by air on 15/10/21.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIImage (Crop)

- (UIImage*) imageByCroppingToRect:(CGRect)rect;

- (UIImage*) imageByCroppingSelf;

@end