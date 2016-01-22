//
//  TDUtil.m
//  WeiNI
//
//  Created by air on 14/12/3.
//  Copyright (c) 2014年 weini. All rights reserved.
//

#import "TDUtil.h"

#import "NSString+MD5.h"
#import "UConstants.h"
#import "MJRefresh.h"
#import "Reachability.h"
@implementation TDUtil
+ (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+(float)ConvertSingl:(float)l1 l2:(float)l2 l3:(float)l3
{
    return (l2*l3)/l1;
}
+(UIImage*)GraceImage:(UIImage*)image inputRadius:(NSNumber*)inputRadius
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    // create gaussian blur filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:inputRadius forKey:@"inputRadius"];
    // blur image
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    
    return [UIImage imageWithCGImage:cgImage];
}
+(NSString*)Gender:(int)index
{
    switch (index) {
        case 0:
            return @"女";
            break;
        case 1:
            return @"男";
        default:
            return nil;
            break;
    }
}
//根据自负获取索引
+(int)GenderIndex:(NSString*)gender{
    if ([gender isEqualToString:@"男"]) {
        return 1;
    }else{
        return 0;
    }
}
//根据index获取图片名称
+(NSString*)imageNameByIndex:(int)index
{
    switch (index) {
        case 1:
            return [NSString stringWithFormat:@"%d",index];
            break;
            
        default:
            return nil;
            break;
    }
}

//获取当前时间
+(NSString*)CurrentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *destDate= [dateFormatter stringFromDate:[NSDate new]];
    return destDate;
    
}

+(NSString*)CurrentDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *destDate= [dateFormatter stringFromDate:[NSDate new]];
    return destDate;
    
}

+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}



//输入的日期字符串形如：@"1992-05-21 13:08:08"

+(NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //2015-02-06 10:00:00.0
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}

+(NSDate *)dateFromStringYMD:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //2015-02-06 10:00:00.0
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}

//输入的日期字符串形如：@"13:08"

+(NSString *)dateTimeFromString:(NSString *)dateString{
    //2015-02-06 10:00:00.0
    
    dateString=[dateString substringToIndex:19];
    NSDate *destDate= [self dateFromString:dateString];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitHour|NSCalendarUnitSecond) fromDate:destDate];
    
    NSString* str;
    int hour=(int)components.hour;
    int second=(int)components.second;
    if (hour<10) {
        str=[NSString stringWithFormat:@"0%d:",hour];
    }else{
        str=[NSString stringWithFormat:@"%d:",hour];
    }
    
    if (second<10) {
        str=[str stringByAppendingString:[NSString stringWithFormat:@"0%d",second]];
    }else{
        str=[str stringByAppendingString:[NSString stringWithFormat:@"%d",second]];
    }
    return str;
    
}

+(NSDate *)dateFromString:(NSString *)dateString format:(NSString*)format{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}

+(NSDate *)dateFromDate:(NSDate *)date format:(NSString*)format{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:format];
    NSString *destDate= [dateFormatter stringFromDate:date];
    NSDate* uiDate=[dateFormatter dateFromString:destDate];
    return uiDate;
    
}

+(NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

+(NSInteger)monthWithDateString:(NSString*)uiDate withFormat:(NSString*)format
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate* date=[self dateFromString:uiDate format:format];
    NSDateComponents *components = [cal components:(NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    return components.month;
}

+(NSInteger)yearWithDateString:(NSString*)uiDate withFormat:(NSString*)format
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate* date=[self dateFromString:uiDate format:format];
    NSDateComponents *components = [cal components:(NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    return components.year;
}

+(NSInteger)dayWithDateString:(NSString*)uiDate withFormat:(NSString*)format
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate* date=[self dateFromString:uiDate format:format];
    NSDateComponents *components = [cal components:(NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    return components.day;
}

+(NSInteger)currentDay
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitDay) fromDate:[NSDate date]];
    return components.day;
}

+(NSInteger)currentYear
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitYear) fromDate:[NSDate date]];
    return components.year;
}

+(NSInteger)currentMonth
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitMonth) fromDate:[NSDate date]];
    return components.month;
}

+(NSInteger)dayWithNextNum:(int)num
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    num=24*60*60*num;
    NSDate* date=[NSDate dateWithTimeInterval:num sinceDate:[NSDate date]];
    NSDateComponents *components = [cal components:(NSCalendarUnitDay) fromDate:date];
    return components.day;
}


+(NSInteger)weekWithNextNum:(int)num
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    NSInteger unitFlags =NSCalendarUnitWeekday;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSinceNow:3600*24*num]];
    return [comps weekday];
}


+(NSInteger)maxNumOfMonth
{
    
    NSDate *today = [NSDate date];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:today];
    
    return days.length;
    
}

+(NSString*)currentDayString:(int)index
{
    switch (index) {
        case 7:
            return @"周六";
            break;
        case 1:
            return @"周天";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        default:
            return @"周一";
            break;
    }
}


+(int)BoxModelDaytime
{
    NSMutableArray* weekNumArray=[TDUtil weekWithOneWeek];
    NSInteger weekIndex;
    int num=0;
    for (int i=0; i<7; i++) {
        weekIndex=[[weekNumArray objectAtIndex:i] integerValue];
        if (weekIndex==7 &&i<2) {
            num++;
        }else if(weekIndex==1 &&i<2){
            num++;
        }
    }
    return num;
}


//是否到达指定时间
+(BOOL)isArrivedTime:(NSString*)compareTimeStr
{
    //当前时间
    NSDate* now =[NSDate new];
    //假设超过指定时间
    //    now=[self dateFromString:[self dateTimeWithOps:0 startHourStr:TODAY_MEAL_END_TIME]];
    
    NSString* dateStr=[self dateTimeWithOps:0 startHourStr:compareTimeStr];
    //结束时间
    NSDate* targetDate =[self dateFromString:dateStr];
    //计算与指定时间秒数之差
    NSInteger seconds = [targetDate timeIntervalSinceDate:now];
    if (seconds>0) {
        return false;
    }else{
        return true;
    }
}

//增加天数，指定开始小时字符串，输出时间字符串
+(NSString*)dateTimeWithOps:(int)dayAdd
{
    
    //当前年
    NSInteger year=[TDUtil currentYear];
    //当前月
    NSInteger month=[TDUtil currentMonth];
    //当天日期
    NSInteger day=[TDUtil currentDay];
    
    //下一天
    day+=dayAdd;
    NSInteger maxDays=[self maxNumOfMonth];
    if (day>maxDays) {
        day=1;
        month++;
    }
    
    //格式化时间字符串
    NSString* dateStr=[NSString stringWithFormat:@"%ld",(long)year];
    if (month<10) {
        dateStr=[dateStr stringByAppendingString:[NSString stringWithFormat:@"-0%ld",(long)month]];
    }else{
        dateStr=[dateStr stringByAppendingString:[NSString stringWithFormat:@"-%ld",(long)month]];
    }
    
    
    if (day<10) {
        dateStr=[dateStr stringByAppendingString:[NSString stringWithFormat:@"-0%ld",(long)day]];
    }else{
        dateStr=[dateStr stringByAppendingString:[NSString stringWithFormat:@"-%ld",(long)day]];
    }
    
    return dateStr;
}

//增加天数，指定开始小时字符串，输出时间字符串
+(NSString*)dateTimeWithOps:(int)dayAdd startHourStr:(NSString*)hourStr
{
    
    //当前年
    NSInteger year=[TDUtil currentYear];
    //当前月
    NSInteger month=[TDUtil currentMonth];
    //当天日期
    NSInteger day=[TDUtil currentDay];
    
    //下一天
    day+=dayAdd;
    NSInteger maxDays=[self maxNumOfMonth];
    if (day>maxDays) {
        day=1;
        month++;
    }
    
    //格式化时间字符串
    NSString* dateStr=[NSString stringWithFormat:@"%ld",(long)year];
    if (month<10) {
        dateStr=[dateStr stringByAppendingString:[NSString stringWithFormat:@"-0%ld",(long)month]];
    }else{
        dateStr=[dateStr stringByAppendingString:[NSString stringWithFormat:@"-%ld",(long)month]];
    }
    
    
    if (day<10) {
        dateStr=[dateStr stringByAppendingString:[NSString stringWithFormat:@"-0%ld",(long)day]];
    }else{
        dateStr=[dateStr stringByAppendingString:[NSString stringWithFormat:@"-%ld",(long)day]];
    }
    
    dateStr=[dateStr stringByAppendingString:hourStr];
    return dateStr;
}
//=================================================================公共方法===========================================//
+(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}

+(PaddingView*)textFieldPaddingView{
    return [[PaddingView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
}

+(void)setTextFieldLeftPadding:(UITextField *)textField forImage:(NSString *)image
{
    PaddingView* paddingView=[self textFieldPaddingView];
    paddingView.image=[UIImage imageNamed:image];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}

//判断是否中文
+(BOOL)isChinese:(NSString*)c{
    int strlength = 0;
    char* p = (char*)[c cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[c lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return ((strlength/2)==1)?YES:NO;
}

//从数组中检索
+(NSMutableArray*)arrayWithIndexFromArray:(NSMutableArray *)array from:(NSInteger)index limit:(NSInteger)limit
{
    NSMutableArray* arrayData=[[NSMutableArray alloc]init];
    NSInteger count=array.count;
    for (int i=0; i<count; i++) {
        if (i>=index) {
            if (limit>0) {
                [arrayData addObject:array[i]];
            }
            limit--;
        }
    }
    return arrayData;
}


+(NSString*)currentContentFilePath
{
    NSArray* documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory=[documentDirectories objectAtIndex:0];
    return documentDirectory;
}

+(BOOL)saveContent:(UIImage *)image fileName:(NSString *)fileName
{
    NSString* filePath=[self currentContentFilePath];  //获取路劲
    NSFileManager * fileManager=[NSFileManager defaultManager];  //文件管理
    //filePath=[filePath stringByAppendingFormat:@"/image/%@",fileName];
    if (![fileManager fileExistsAtPath:[filePath stringByAppendingFormat:@"/image/%@",fileName]]) {
        return  [self saveContentToFile:filePath content:image fileName:fileName  fileManager:fileManager];
    }else{
        //文件已存在
        return  [self saveContentToFile:filePath content:image fileName:fileName  fileManager:fileManager];
    }
}

+(BOOL)saveCameraPicture:(UIImage *)image fileName:(NSString *)fileName
{
    NSString* filePath=[self currentContentFilePath];  //获取路劲
    NSFileManager * fileManager=[NSFileManager defaultManager];  //文件管理
    //filePath=[filePath stringByAppendingFormat:@"/image/%@",fileName];
    return  [self saveContentToFile:filePath content:image fileName:fileName  fileManager:fileManager];
}

//删除图片
+(BOOL)removeContent:(NSString *)fileName
{
    NSString* filePath=[self currentContentFilePath];  //获取路劲
    NSFileManager * fileManager=[NSFileManager defaultManager];  //文件管理
    filePath=[filePath stringByAppendingFormat:@"/image/%@",fileName];
    NSError* error;
    if ([fileManager fileExistsAtPath:filePath]) {
        //文件不存在
        [fileManager removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"无法删除文件:%@",error);
        }
    }
    return YES;
}

//加载图片
+(UIImage*)loadContent:(NSString *)fileName
{
    NSString* filePath=[self currentContentFilePath];  //获取路劲
    NSFileManager * fileManager=[NSFileManager defaultManager];  //文件管理
    filePath=[filePath stringByAppendingFormat:@"/image/%@",fileName];
    UIImage* image;
    if (![fileManager fileExistsAtPath:filePath]) {
        //文件不存在
    }else{
        //文件已存在
        image=[[UIImage alloc]initWithContentsOfFile:filePath];
    }
    return image;
}

//根据路径加载图片
+(NSString*)loadContentPath:(NSString *)fileName
{
    NSString* filePath=[self currentContentFilePath];  //获取路劲
    NSFileManager * fileManager=[NSFileManager defaultManager];  //文件管理
    filePath=[filePath stringByAppendingFormat:@"/image/%@",fileName];
    if (![fileManager fileExistsAtPath:filePath]) {
        //文件不存在
        NSLog(@"%@文件不存在",filePath);
    }else{
        //文件已存在
        //        NSLog(@"%@文件存在",filePath);
    }
    return filePath;
}

+(BOOL)saveContentToFile:(NSString*)filePath content:(UIImage*)image fileName:(NSString*)fileName fileManager:(NSFileManager*)fileManager
{
    NSError* error;
    
    NSData *data;
    if ([self isValidPNGByImageData:image]) {
        data = UIImageJPEGRepresentation(image, 1);
    }else if([self isValidJPGByImageData:image]){
        data = UIImagePNGRepresentation(image);
    }
    if (data) {
        filePath=[filePath stringByAppendingString:@"/image/"];
        BOOL success=[fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        filePath=[filePath stringByAppendingString:fileName];
        success= [fileManager createFileAtPath:filePath contents:data attributes:nil];
        if(!success){
            NSLog(@"Unable to save file:%@\nError:%@",filePath,error);
            return NO;
        }else{
            NSLog(@"文件保存成功！");
            return YES;
        }
    }else{
        NSLog(@"文件保存失败！");
        return NO;
    }
    
}
+(UIImage *) getImageFromURL:(NSString *)fileURL {
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    result = [UIImage imageWithData:data];
    return result;
    
}

/**
 *  校验图片是否为有效的PNG图片
 *
 *  @param imageData 图片文件直接得到的NSData对象
 *
 *  @return 是否为有效的PNG图片
 */
+ (BOOL)isValidPNGByImageData:(UIImage*)image
{
    //UIImage* image = [UIImage imageWithData:imageData];
    //第一种情况：通过[UIImage imageWithData:data];直接生成图片时，如果image为nil，那么imageData一定是无效的
    if (image == nil) {
        return NO;
    }
    
    //第二种情况：图片有部分是OK的，但是有部分坏掉了，它将通过第一步校验，那么就要用下面这个方法了。将图片转换成PNG的数据，如果PNG数据能正确生成，那么这个图片就是完整OK的，如果不能，那么说明图片有损坏
    NSData* tempData = UIImagePNGRepresentation(image);
    if (tempData == nil) {
        return NO;
    } else {
        return YES;
    }
}

/**
 *  校验图片是否为有效的JPG图片
 *
 *  @param imageData 图片文件直接得到的NSData对象
 *
 *  @return 是否为有效的PNG图片
 */
+ (BOOL)isValidJPGByImageData:(UIImage*)image
{
    //第一种情况：通过[UIImage imageWithData:data];直接生成图片时，如果image为nil，那么imageData一定是无效的
    if (image == nil) {
        
        return NO;
    }
    
    //第二种情况：图片有部分是OK的，但是有部分坏掉了，它将通过第一步校验，那么就要用下面这个方法了。将图片转换成PNG的数据，如果PNG数据能正确生成，那么这个图片就是完整OK的，如果不能，那么说明图片有损坏
    NSData* tempData = UIImageJPEGRepresentation(image,0);
    if (tempData == nil) {
        return NO;
    } else {
        return YES;
    }
}

+(BOOL)checkImageExists:(NSString *)fileName
{
    NSString* filePath=[self currentContentFilePath];  //获取路劲
    NSFileManager * fileManager=[NSFileManager defaultManager];  //文件管理
    filePath=[filePath stringByAppendingFormat:@"/image/%@",fileName];
    if ([fileManager fileExistsAtPath:filePath]) {
        //文件存在
        return TRUE;
    }else{
        //文件不存在
        return FALSE;
    }
}
//截屏
+ (UIImage *)capture:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


//修改图片尺寸
+ (UIImage*) drawInRectImage:(UIImage*)startImage size:(CGSize)imageSize
{
    float  w = CGImageGetWidth(startImage.CGImage);
    
    float  h = CGImageGetHeight(startImage.CGImage);
    
    float wt = imageSize.width/w;
    
    float ht = imageSize.height/h;
    
    CGRect targetRect;
    
    if (wt<ht) {
        
        targetRect = CGRectMake(0, (imageSize.height-h*wt)/2, imageSize.width, h*wt);
    }else {
        
        targetRect = CGRectMake((imageSize.width-w*ht)/2, 0, w*ht, imageSize.height);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, imageSize.width, imageSize.height,
                                                 8,
                                                 0,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
    
    
    CGContextDrawImage(context, targetRect, startImage.CGImage);
    
    CGContextSaveGState(context);
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    
    UIImage* resultImage =[UIImage imageWithCGImage:newCGImage];
    
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    
    return  resultImage;
    
}

+ (BOOL)validateMobile:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1\\d{10}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//对图片尺寸进行压缩--
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+(NSMutableArray*)soreAsc:(NSMutableDictionary*)arr
{
    NSArray *myKeys = [arr allKeys];
    NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray *sortedValues = [[NSMutableArray alloc] init];
    
    for(id key in sortedKeys) {
        id object = [arr objectForKey:key];
        [sortedValues addObject:object];
    }
    
    return sortedValues;
}

//短信验证码加密方法
+(NSString*)ConfirmPhoneNum:(NSInteger)phoneNum
{
    
    return nil;
}


#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)encodeBase64Data:(NSData *)data {
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64Data:(NSData *)data {
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}


+(NSString*)encryptPhoneNum:(NSString *)phoneNum
{
    NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
    int index=0;
    NSString* str;  //截取字符串
    for (int i=1; i<=phoneNum.length; i++) {
        str=[phoneNum substringWithRange:NSMakeRange(index, 1)];
        [dic setValue:str forKey:[NSString stringWithFormat:@"%d",i]];
        index++;
    }
    
    //开始转换
    NSString* str2;
    NSString* middleNum;
    NSMutableDictionary* dicLeftNum=[[NSMutableDictionary alloc]init];
    NSMutableDictionary* dicRightNum=[[NSMutableDictionary alloc]init];
    NSInteger length=phoneNum.length;
    
    float temp=length/2.;
    for (int i=1; i<=phoneNum.length; i++) {
        str=[dic valueForKey:[NSString stringWithFormat:@"%d",i]];
        if (i<temp) {
            [dicLeftNum setValue:str forKey:[NSString stringWithFormat:@"%d",i]];
        }else if (i==6){
            middleNum=str;
        }else{
            [dicRightNum setValue:str forKey:[NSString stringWithFormat:@"%d",i-6]];
        }
    }
    
    str=@"";
    str2=@"";
    for (int i=1; i<=phoneNum.length; i++) {
        if(i<6){
            str=[str stringByAppendingString:[dicLeftNum valueForKey:[NSString stringWithFormat:@"%d",i]]];
        }else{
            if (i!=6) {
                str2= [str2 stringByAppendingString:[dicRightNum valueForKey:[NSString stringWithFormat:@"%d",i-6]]];
            }
        }
    }
    NSString* encryptPhoneNum=[str2 stringByAppendingString:middleNum];
    encryptPhoneNum=[encryptPhoneNum stringByAppendingString:str];
    return encryptPhoneNum;
}


#pragma mark - MD5加密
/**
 *	@brief	对string进行md5加密
 *
 *	@param 	string 	未加密的字符串
 *
 *	@return	md5加密后的字符串
 */
+ (NSString*)encryptMD5String:(NSString*)string {
    return [string md5Encrypt];
}

+(NSString*)encryptPhoneNumWithMD5:(NSString *)phoneNum passString:(NSString *)passStr
{
    NSString* str =[NSString  stringWithFormat:@"%@%@%@",passStr,phoneNum,APP_PRIVATE_KEY];
    str = [TDUtil encryptMD5String:str];;
    str = [str lowercaseString];
    return str;
}

//普通字符串转换为十六进制的。

+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

+(UIColor*)convertColorWithString:(NSString *)colorStr
{
    NSInteger length =colorStr.length;
    float redColor=[[colorStr substringWithRange:NSMakeRange(0, 3)] floatValue];
    float greenColor=[[colorStr substringWithRange:NSMakeRange(3, 3)] floatValue];
    float blueColor;
    
    if (length<9) {
        blueColor=[[colorStr substringWithRange:NSMakeRange(6, 2)] floatValue];
    }else{
        blueColor=[[colorStr substringWithRange:NSMakeRange(6, 3)] floatValue];
    }
    
    
    return [UIColor colorWithRed:redColor/255 green:greenColor/255 blue:blueColor/255 alpha:1];
}


+(NSString*)convertGBKDataToUTF8String:(NSData *)data
{
    return [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
}


+(NSString*)convertGBKStringToUTF8String:(NSString *)str
{
    return [[NSString alloc] initWithBytes:(__bridge const void *)(str) length:[str length] encoding:NSUTF8StringEncoding];
}

+(DialogView*)shareInstanceDialogView:(UIView *)view
{
    DialogView* v =[[DialogView alloc]initWithFrame:view.frame];
    return v;
}

+(BOOL)isValidString:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return NO;
    }
    return YES;
}


#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (NSString *)ToHex:(NSInteger)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

+(void)tableView:(UITableView *)tableView  target:(id)target refreshAction:(SEL)refreshAction loadAction:(SEL)loadAction
{
    NSMutableArray* imgArrays =[[NSMutableArray alloc]init];
    
    NSString* fileName=@"";
    
    UIImage* image;
    
    for (int i = 0; i<7; i++) {
        
        fileName = [NSString stringWithFormat:@"person%d",i+1];
        
        image = IMAGENAMED(fileName);
        
        [imgArrays addObject:image];
        
    }
    
    
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:refreshAction];
    
    // 设置普通状态的动画图片
    
    [header setImages:imgArrays forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    
    [header setImages:imgArrays forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    
    [header setImages:imgArrays forState:MJRefreshStateRefreshing];
    
    
    
    
    
    tableView.header = header;
    
    
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:target refreshingAction:loadAction];
    
    // 设置普通状态的动画图片
    
    [footer setImages:imgArrays forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    
    [footer setImages:imgArrays forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    
    [footer setImages:imgArrays forState:MJRefreshStateRefreshing];
    
    // 上拉刷新
    
    tableView.footer = footer;
    
}

+(void)collectView:(UICollectionView *)collectionView target:(id)target refreshAction:(SEL)refreshAction loadAction:(SEL)loadAction
{
    NSMutableArray* imgArrays =[[NSMutableArray alloc]init];
    
    NSString* fileName=@"";
    
    UIImage* image;
    
    for (int i = 0; i<7; i++) {
        
        fileName = [NSString stringWithFormat:@"person%d",i+1];
        
        image = IMAGENAMED(fileName);
        
        [imgArrays addObject:image];
        
    }
    
    
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:refreshAction];
    
    // 设置普通状态的动画图片
    
    [header setImages:imgArrays forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    
    [header setImages:imgArrays forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    
    [header setImages:imgArrays forState:MJRefreshStateRefreshing];
    
    
    
    
    
    collectionView.header = header;
    
    
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:target refreshingAction:loadAction];
    
    // 设置普通状态的动画图片
    
    [footer setImages:imgArrays forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    
    [footer setImages:imgArrays forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    
    [footer setImages:imgArrays forState:MJRefreshStateRefreshing];
    
    // 上拉刷新
    
    collectionView.footer = footer;
}

+(void)label:(UILabel *)label font:(UIFont *)font content:(NSString *)content alignLabel:(UILabel *)lb
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGSize labelsize = [content sizeWithAttributes:attributes];
    CGRect rect;
    if (lb) {
        rect =CGRectMake(POS_X(lb)+5, Y(lb), labelsize.width,HEIGHT(lb));
    }else{
        rect =CGRectMake(X(label), Y(label), labelsize.width, labelsize.height );
    }
    label.frame =rect;
    label.text = content;
    label.font = font;
    
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //
    //    //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
    //
    //    [paragraphStyle setLineSpacing:0.f];//调整行间距
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    //
    //    label.attributedText = attributedString;//ios 6
    //
    //    [label sizeToFit];
    
}

+  (int)convertToInt:(NSString*)strtemp {
    int strlength = 0;
    // 这里一定要使用gbk的编码方式，网上有很多用Unicode的，但是混合的时候都不行
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    char* p = (char*)[strtemp cStringUsingEncoding:gbkEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:gbkEncoding] ;i++) {
        if (p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength/2;
}

+ ( CameraMoveDirection )determineCameraDirectionIfNeeded:( CGPoint )translation direction:(CameraMoveDirection)direction

{
    
    if (direction != kCameraMoveDirectionNone)
        
        return direction;
    
    // determine if horizontal swipe only if you meet some minimum velocity
    
    if (fabs(translation.x) > gestureMinimumTranslation)
        
    {
        
        BOOL gestureHorizontal = NO;
        
        if (translation.y == 0.0 )
            
            gestureHorizontal = YES;
        
        else
            
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
        
        if (gestureHorizontal)
            
        {
            
            if (translation.x > 0.0 )
                
                return kCameraMoveDirectionRight;
            
            else
                
                return kCameraMoveDirectionLeft;
            
        }
        
    }
    
    // determine if vertical swipe only if you meet some minimum velocity
    
    else if (fabs(translation.y) > gestureMinimumTranslation)
        
    {
        
        BOOL gestureVertical = NO;
        
        if (translation.x == 0.0 )
            
            gestureVertical = YES;
        
        else
            
            gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
        
        if (gestureVertical)
            
        {
            
            if (translation.y > 0.0 )
                
                return kCameraMoveDirectionDown;
            
            else
                
                return kCameraMoveDirectionUp;
            
        }
        
    }
    
    return direction;
}

+(BOOL)isValideTime:(NSString *)timeString
{
    
    NSString *regex = @"^\\d{4}(\\-|\\/|\\.)\\d{1,2}\\1\\d{1,2}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:timeString];
    return isValid;
    
}


+(void)setLabelMutableText:(UILabel*)label content:(NSString*)content lineSpacing:(float)lineSpacing headIndent:(CGFloat)indent
{
    if (content) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
        
        [paragraphStyle setLineSpacing:lineSpacing];//调整行间距
        //    [paragraphStyle setAlignment:NSTextAlignmentLeft];
        [paragraphStyle setHeadIndent:indent];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
        
        label.attributedText = attributedString;//ios 6
        [label sizeToFit];
    }
}

+ (CGFloat)getTextViewHeight:(NSIndexPath*)indexPath content:(NSString*)content width:(CGFloat)width
{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:content];
    UITextView* textViewTemple = [[UITextView alloc]initWithFrame:CGRectZero];
    textViewTemple.attributedText = attrStr;
    textViewTemple.text = content;
    NSRange range = NSMakeRange(0, attrStr.length);
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];   // 获取该段attributedString的属性字典
    // 计算文本的大小  ios7.0
    CGSize textSize = [textViewTemple.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                                     attributes:dic        // 文字的属性
                                                        context:nil].size;
    return textSize.height;
}

/**
 *  根据服务器返回状态值做各种行为
 *
 *  @param controller 当前发起请求所在的UIViewController
 *  @param code       返回状态击级别
 *  @param dic        服务器返回值
 */
+(void)serverResultJudge:(id )controller dic:(NSMutableDictionary *)dic
{
    
    RootViewController* c =(RootViewController*)controller;
    //默认不显示系统错误
    c.isNetRequestError = NO;
    
    int code = [[dic valueForKey:@"code"] intValue];
    
    c.code  = code ;
    
    switch (code) {
        case -2:
            //系统错误
            c.isNetRequestError = YES;
            break;
        case -1:
            //没有登录，重新登录
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
            break;
        case 0:
            //加载正常
            c.dataDic=dic;
            break;
        case 1:
            //业务错误
            break;
        case 2:
            //列表加载完成
            break;
        default:
            //系统错误
            c.isNetRequestError = YES;
            break;
    }
}

//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+ (NetStatus)checkNetworkState {
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        NSLog(@"有wifi");
        return NetStatusWifi;
        
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
        return  NetStatusSelfNet;
        
    } else { // 没有网络
        NSLog(@"没有网络");
        return NetStatusNone;
    }
}
@end