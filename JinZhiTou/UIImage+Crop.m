//
//  UIImage+Crop.m
//  JinZhiTou
//
//  Created by air on 15/10/21.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "UIImage+Crop.h"

#import "UIImage+Crop.h"


@implementation UIImage (Crop)

- (UIImage*) imageByCroppingToRect:(CGRect)rect

{
    
    //create a context to do our clipping in
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    
    
    //create a rect with the size we want to crop the image to
    
    //the X and Y here are zero so we start at the beginning of our
    
    //newly created context
    
    CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    CGContextClipToRect( currentContext, clippedRect);
    
    
    
    //create a rect equivalent to the full size of the image
    
    //offset the rect by the X and Y we want to start the crop
    
    //from in order to cut off anything before them
    
    CGRect drawRect = CGRectMake(rect.origin.x * -1,
                                 
                                 rect.origin.y * -1,
                                 
                                 self.size.width,
                                 
                                 self.size.height);
    
    
    
    //draw the image to our clipped context using our offset rect
    
    CGContextTranslateCTM(currentContext, 0.0, rect.size.height);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    CGContextDrawImage(currentContext, drawRect, self.CGImage);
    
    
    
    //pull the image from our cropped context
    
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    //pop the context to get back to the default
    
    UIGraphicsEndImageContext();
    
    
    
    //Note: this is autoreleased
    
    return cropped;
    
}

- (UIImage*) imageByCroppingSelf

{
    
    //create a context to do our clipping in
    
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    
    
    //create a rect with the size we want to crop the image to
    
    //the X and Y here are zero so we start at the beginning of our
    
    //newly created context
    
    CGRect clippedRect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextClipToRect( currentContext, clippedRect);
    
    
    
    //create a rect equivalent to the full size of the image
    
    //offset the rect by the X and Y we want to start the crop
    
    //from in order to cut off anything before them
    
    CGRect drawRect = CGRectMake(0,
                                 
                                 0,
                                 
                                 self.size.width,
                                 
                                 self.size.height);
    
    
    
    //draw the image to our clipped context using our offset rect
    
    CGContextTranslateCTM(currentContext, 0.0, self.size.height);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    CGContextDrawImage(currentContext, drawRect, self.CGImage);
    
    
    
    //pull the image from our cropped context
    
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    //pop the context to get back to the default
    
    UIGraphicsEndImageContext();
    
    
    
    //Note: this is autoreleased
    
    return cropped;
    
}

@end
