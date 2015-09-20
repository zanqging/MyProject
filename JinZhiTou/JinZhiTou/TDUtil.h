//
//  TDUtil.h
//  WeiNI
//
//  Created by air on 14/12/3.
//  Copyright (c) 2014年 weini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMBase64.h"
#import "NSData+AES.h"
#import "PaddingView.h"
#import "DialogView.h"
@interface TDUtil : UIView

/**
 *  使用颜色创建图片对象
 *
 *  @param color UIColor 颜色
 *  @param rect  生成图片大小
 *
 *  @return 返回UIImage对象
 */

+ (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect;

/**
 *  转换对象
 *
 *  @param l1 参数1
 *  @param l2 参数2
 *  @param l3 参数3
 *
 *  @return float 转换值
 */

+(float)ConvertSingl:(float)l1 l2:(float)l2 l3:(float)l3;

/**
 *  高斯模糊处理图片
 *
 *  @param image       要处理图片
 *  @param inputRadius 处理区域半径
 *
 *  @return 高斯模糊处理后图片
 */

+(UIImage*)GraceImage:(UIImage*)image inputRadius:(NSNumber*)inputRadius;

/**
 *  根据index获取图片名称
 *
 *  @param index 索引整形值
 *
 *  @return 索引值相对应图片名称
 */

+(NSString*)imageNameByIndex:(int)index;

/**
 *  获取男女性别
 *
 *  @param index 男女索引值
 *
 *  @return 性别：男：女
 */

+(NSString*)Gender:(int)index;

/**
 *  获取男女性别index
 *
 *  @param gender 性别：男：女
 *
 *  @return int 性别：男：女所对应索引值
 */

+(int)GenderIndex:(NSString*)gender;

/**
 *  获取当前时间
 *
 *
 *  @return 当前时间字符串
 */

+(NSString*)CurrentDate;
//从字符串转换时间
+(NSDate*) convertDateFromString:(NSString*)uiDate;

+(NSDate *)dateFromStringYMD:(NSString *)dateString;
//获取本月最大天数
+(NSInteger)maxNumOfMonth;

+(NSString *)dateTimeFromString:(NSString *)dateString;

+(NSInteger)monthWithDateString:(NSString*)uiDate withFormat:(NSString*)format;

+(NSInteger)yearWithDateString:(NSString*)uiDate withFormat:(NSString*)format;

+(NSInteger)dayWithDateString:(NSString*)uiDate withFormat:(NSString*)format;

//增加天数，指定开始小时字符串，输出时间字符串
+(NSString*)dateTimeWithOps:(int)dayAdd startHourStr:(NSString*)hourStr;

//通过指定格式返回时间字符串
+(NSDate *)dateFromString:(NSString *)dateString format:(NSString*)format;

//通过指定时间转换时间
+(NSDate *)dateFromDate:(NSDate *)date format:(NSString*)format;
//从字符串返回日期字符串
+ (NSDate *)dateFromString:(NSString *)dateString;
//yyyy-MM-dd HH:mm:ss zzz"
+(NSString *)stringFromDate:(NSDate *)date;
+(NSString*)currentDayString:(int)index;
//返回当天日期
+(NSInteger)currentDay;
//当前年
+(NSInteger)currentYear;
//当月
+(NSInteger)currentMonth;
//返回自定义时间
+(NSInteger)dayWithNextNum:(int)num;
//返回一周日期
+(NSMutableArray*)dayWithOneWeek;
//返回周
+(NSMutableArray*)weekWithOneWeek;
//返回个性化日
+(NSString*)dateTimeWithOps:(int)dayAdd;
/**
 *	@brief	保存照相机图片
 *
 *	@param 	image  图片
 *  @param  filename 保存文件名称
 *
 *	@return	是否保存成功 YES:相机照片保存成功 NO:图片保存失败
 */
+(BOOL)saveCameraPicture:(UIImage *)image fileName:(NSString *)fileName;

/**
 *	@brief	根据名称加载图片路径
 *
 *	@param 	fileName:加载图片名称
 *
 *	@return	以fileName 命名本地图片路径
 */
+(NSString*)loadContentPath:(NSString *)fileName;

/**
 *	@brief	根据名称加载图片
 *
 *	@param 	fileName:加载图片名称
 *
 *	@return	以fileName 命名本地图片
 */
+(UIImage*)loadContent:(NSString*)fileName;   //加载图片

/**
 *	@brief 检测该名称图片是否在本地存在
 *
 *	@param 	fileName:加载图片名称
 *
 *	@return	YES：表示文件存在 NO：表示文件不存在
 */
+(BOOL)checkImageExists:(NSString*)fileName;

/**
 *	@brief 获取当前应用沙箱路径
 *
 *	@return	当前应用沙箱路径
 */
+(NSString*)currentContentFilePath;

/**
 *	@brief	保存图片
 *
 *	@param 	image  图片
 *  @param  filename 保存文件名称
 *
 *	@return	是否保存成功 YES:团片保存成功 NO:图片保存失败
 */
+(BOOL)saveContent:(UIImage*)image fileName:(NSString*)fileName;  //保存图片

/**
 *	@brief 删除图片
 *
 *	@param 	image  图片
 *  @param  filename 保存文件名称
 *
 *	@return	是否删除成功 YES:图片删除成功 NO:图片删除失败
 */
+(BOOL)removeContent:(NSString*)fileName;   //删除图片

/**
 *	@brief	从互联网网络地址获取图片
 *
 *	@param 	fileURL  图片网络地址
 *
 *	@return	互联网图片
 */
+(UIImage *) getImageFromURL:(NSString *)fileURL; //从网络上获取图片

/**
 *	@brief	截屏当前视图
 *
 *	@param 	fileURL  图片网络地址
 *
 *	@return	互联网图片
 */
+(UIImage *)capture:(UIView *)view;
/**
 *	@brief	调整图片大小
 *
 *	@param 	 startImage 	原始图片素材
 *    @param       imageSize  调整好图片大小
 *
 *	@return	调整后图片
 */
+ (UIImage*) drawInRectImage:(UIImage*)startImage size:(CGSize)imageSize;
/**
 *	@brief	验证手机号码
 *
 *	@param 	 startImage 	原始图片素材
 *    @param       imageSize  调整好图片大小
 *
 *	@return bool
 */
+ (BOOL)validateMobile:(NSString *)mobileNum;
/**
 *	@brief	排序
 *
 *	@param 	 startImage 	原始图片素材
 *    @param       imageSize  调整好图片大小
 *
 *	@return	调整后图片
 */
+(NSMutableArray*)soreAsc:(NSMutableDictionary*)arr;
//=====================================================================================================//
//距次日6点整相差秒数
+(NSInteger)leftSecond;
+(int)BoxModelDaytime;
//是否到达指定时间: 参数compareTimeStr 格式:@" 14:00:00"
+(BOOL)isArrivedTime:(NSString*)compareTimeStr;
+(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth;
+(PaddingView*)textFieldPaddingView;
+(void)setTextFieldLeftPadding:(UITextField *)textField forImage:(NSString*)image;
//判断是否中文
+(BOOL)isChinese:(NSString*)c;
//从数组中指定位置，指定数量检索
+(NSMutableArray*)arrayWithIndexFromArray:(NSMutableArray*)array from:(NSInteger)index limit:(NSInteger)limit;
//=====================================================================================================//
//===============================================短信验证加密方法======================================================//
+(NSString*)ConfirmPhoneNum:(NSInteger)phoneNum;
#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;


#pragma mark - AES加密

/**
 *  AES加密算法加密
 *
 *  @param string 需要加密字符串
 *
 *  @return 加密后字符串
 */

+ (NSData*)encryptAESData:(NSString*)string;

/**
 *  将带密码的data转成string
 *
 *  @param data 数据
 *
 *  @return 加密数据字符串
 */

+ (NSString*)decryptAESData:(NSData*)data;
//自己写的加密算法
+(NSString*)encryptPhoneNum:(NSString*)phoneNum;
#pragma mark - MD5加密
/**
 *	@brief	对string进行md5加密
 *
 *	@param 	string 	未加密的字符串
 *
 *	@return	md5加密后的字符串
 */
+ (NSString*)encryptMD5String:(NSString*)string;
+(NSString*)encryptPhoneNumWithMD5:(NSString *)phoneNum passString:(NSString*)passStr;

/**
 *  适用字符串转换颜色值
 *
 *  @param colorStr 118118118 9位
 *
 *  @return 颜色值
 */
+(UIColor*)convertColorWithString:(NSString*)colorStr;
/**
 *  用于网络请求编码
 *
 *  @param  data:NSData
 *
 *  @return UTF-8 编码字符串
 */
+(NSString*)convertGBKDataToUTF8String:(NSData*)data;

/**
 *  用于网络请求
 *
 *  @param str 待编码字符串
 *
 *  @return 编码之后字符
 */
+(NSString*)convertGBKStringToUTF8String:(NSString*)str;
/**
 *  用于实例化弹出提示框
 *
 *  @param  view:视图
 *
 *  @return loadingView
 */
+(DialogView*)shareInstanceDialogView:(UIView*)view;


/**
 *  检测字符串是否为空，或者null
 *
 *  @param str 检验字符串
 *
 *  @return true，false
 */
+(BOOL)isValidString:(NSString*)str;

/**
 *  十六进制颜色值转UIColor
 *
 *  @param color
 *
 *  @return UIcolor 目标颜色
 */
+ (UIColor *) colorWithHexString: (NSString *)color;
/**
 *  十进制转换为十六进制
 *
 *  @param tmpid 十进制
 *
 *  @return 十六进制
 */
+ (NSString *)ToHex:(NSInteger)tmpid;
/**
 *  UITableView  封装刷新方法
 *
 *  @param tableView     UITableView
 *  @param refreshAction 刷新事件
 *  @param loadAction    加载更多事件
 */
+(void)tableView:(UITableView*)tableView  target:(id)target refreshAction:(SEL)refreshAction loadAction:(SEL)loadAction;
/**
 *  UICollectionView  封装刷新方法
 *
 *  @param tableView     UITableView
 *  @param refreshAction 刷新事件
 *  @param loadAction    加载更多事件
 */
+(void)collectView:(UICollectionView*)collectionView  target:(id)target refreshAction:(SEL)refreshAction loadAction:(SEL)loadAction;
/**
 *  是否已注册
 *
 *  @param observer observer
 *
 *  @return
 */
+(BOOL)isHasObserver:(NSString*)observer;

/**
 *  UILabel自适应宽度和高度
 *
 *  @param label UILabel
 *  @param font  字体样式
 *  @param content  内容
 */
+(void)label:(UILabel*)label font:(UIFont*)font content:(NSString*)content alignLabel:(UILabel*)lb;
/**
 *  计算文本长度
 *
 *  @param strtemp 文本
 *
 *  @return 长度
 */
+  (int)convertToInt:(NSString*)strtemp;
@end
