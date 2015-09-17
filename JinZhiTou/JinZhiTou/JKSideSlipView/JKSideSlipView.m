//
//  JKSideSlipView.m
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//
#define SLIP_WIDTH 250

#import "JKSideSlipView.h"
#import "GlobalDefine.h"
#import "UConstants.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

@implementation JKSideSlipView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(nil, @"please init with -initWithSender:sender");
    }
    return self;
    
}

- (instancetype)initWithSender:(UIViewController*)sender{
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect frame = CGRectMake(-SLIP_WIDTH, 0, SLIP_WIDTH, bounds.size.height);
    self = [super initWithFrame:frame];
    if (self) {
        [self buildViews:sender];
    }
    return self;
}
-(void)buildViews:(UIViewController*)sender{
    _sender = sender;
    //_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchMenu)];
    //_tap.numberOfTapsRequired = 1;
    
    _leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    _leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    _rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(show)];
    _rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    //[_sender.view addGestureRecognizer:_tap];
    [_sender.view addGestureRecognizer:_leftSwipe];
    [_sender.view addGestureRecognizer:_rightSwipe];
    
    
    _blurImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SLIP_WIDTH, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _blurImageView.alpha = 0;
    _blurImageView.userInteractionEnabled = NO;
    _blurImageView.backgroundColor = [UIColor grayColor];
    //_blurImageView.layer.borderWidth = 5;
    //_blurImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:_blurImageView];
    
}

-(void)setContentView:(UIView*)contentView{
    if (contentView) {
        _contentView = contentView;
    }
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_contentView];

}
-(void)show:(BOOL)show{
    UIImage *image =  [self imageFromView:_sender.view];
   
    if (!isOpen) {
        _blurImageView.alpha = 1;

    }
    
    CGFloat x = show?0:-SLIP_WIDTH;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
        if(!isOpen){
            _blurImageView.image = image;
            _blurImageView.image= [self blurryImage:_blurImageView.image withBlurLevel:0.2];
        }
    } completion:^(BOOL finished) {
        isOpen = show;
        if(!isOpen){
            
            _blurImageView.alpha = 0;
            _blurImageView.image = nil;
            NSLog(@"hidden");
        }

    }];
    self.isShow = show;
    
}


-(void)switchMenu{
    [self show:!isOpen];
}

-(void)show{
    [self show:YES];
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    BOOL isAmious = [[data valueForKey:@"isAnimous"] boolValue];
    if (isAmious) {
        self.isAmious = YES;
    }else{
        self.isAmious = NO;
    }
}

-(void)hide {
    [self show:NO];
}

#pragma mark - shot
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark - Blur


- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

-(void)setIsAmious:(BOOL)isAmious
{
    self->_isAmious = isAmious;
    if (self->_isAmious) {
        UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, WIDTH(self), HEIGHT(self)-kTopBarHeight-kStatusBarHeight)];
        view.tag =10001;
        //背景
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:view.bounds];
        imgView.image = IMAGENAMED(@"kuang");
        imgView.backgroundColor =WriteColor;
        [view addSubview:imgView];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)/2-80, HEIGHT(view)/2-100, 160, 160)];
        imgView.image = IMAGENAMED(@"yun");
        [view addSubview:imgView];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)/2-60, HEIGHT(view)/2-120, 140, 140)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = IMAGENAMED(@"diqiu-1");
        [view addSubview:imgView];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)/2-60, HEIGHT(view)/2-60, 80, 80)];
        imgView.image = IMAGENAMED(@"mail-1");
        [view addSubview:imgView];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)/2-30, HEIGHT(view)/2+10, 100, 50)];
        imgView.image = IMAGENAMED(@"anniu");
        [view addSubview:imgView];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(imgView)+10, WIDTH(view), 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = ColorTheme;
        label.text =@"去注册，开启互联金融新纪元";
        [view addSubview:label];
        
        UIButton* btnAction = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)/2-60, POS_Y(label)+20, 120, 40)];
        btnAction.layer.cornerRadius =20;
        btnAction.layer.borderColor =ColorTheme.CGColor;
        btnAction.layer.borderWidth =1;
        btnAction.backgroundColor = WriteColor;
        [btnAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnAction setTitle:@"去注册" forState:UIControlStateNormal];
        [btnAction setTitleColor:ColorTheme forState:UIControlStateNormal];
        
        [view addSubview:btnAction];
        
        [self addSubview:view];
    }else{
        UIView* view =[self viewWithTag:10001];
        [view removeFromSuperview];
    }
}

-(void)btnAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(slipView:amiousLogin:)]) {
        [_delegate slipView:nil amiousLogin:sender];
    }
}

@end