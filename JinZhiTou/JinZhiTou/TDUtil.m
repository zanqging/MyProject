//
//  TDUtil.m
//  WeiNI
//
//  Created by air on 14/12/3.
//  Copyright (c) 2014年 weini. All rights reserved.
//

#import "TDUtil.h"
#import "GlobalDefine.h"
#import "NSString+MD5.h"
#import "UConstants.h"
#import "MJRefresh.h"

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

+(NSMutableArray*)dayWithOneWeek
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    int count;
    if ([TDUtil isArrivedTime:TODAY_MEAL_LATEST_TIME]) {
        count=1;
    }else{
        count=0;
    }
    for (int i=count; i<count+7; i++) {
        [array addObject:[NSString stringWithFormat:@"%ld",(long)[self dayWithNextNum:i]]];
    }
    return array;
}

+(NSInteger)weekWithNextNum:(int)num
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    NSInteger unitFlags =NSCalendarUnitWeekday;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSinceNow:3600*24*num]];
    return [comps weekday];
}

+(NSMutableArray*)weekWithOneWeek
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    int count;
    if ([TDUtil isArrivedTime:TODAY_MEAL_LATEST_TIME]) {
        count=1;
    }else{
        count=0;
    }
    for (int i=count; i<count+7; i++) {
        [array addObject:[NSString stringWithFormat:@"%ld",(long)[self weekWithNextNum:i]]];
    }
    return array;
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

//倒计时时间
+(NSInteger)leftSecond
{
    //当前时间
    NSDate* now =[NSDate new];
    //周六周天
    int num=[self BoxModelDaytime];
    if (num==0) {
        num=1;
    }
    NSString* dateStr=[self dateTimeWithOps:num startHourStr:ORIGIN_START_TIME];
    //结束时间
    NSDate* targetDate =[self dateFromString:dateStr];
    //计算与指定时间秒数之差
    NSInteger seconds = [targetDate timeIntervalSinceDate:now];
    return seconds;
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
    return [[PaddingView alloc] initWithFrame:CGRectMake(150, 10, 25, 25)];
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
        //文件不存在
        [self saveContentToFile:filePath content:image fileName:fileName  fileManager:fileManager];
    }else{
        //文件已存在
        [self saveContentToFile:filePath content:image fileName:fileName  fileManager:fileManager];
    }
    return TRUE;
}

+(BOOL)saveCameraPicture:(UIImage *)image fileName:(NSString *)fileName
{
    NSString* filePath=[self currentContentFilePath];  //获取路劲
    NSFileManager * fileManager=[NSFileManager defaultManager];  //文件管理
    //filePath=[filePath stringByAppendingFormat:@"/image/%@",fileName];
    [self saveContentToFile:filePath content:image fileName:fileName  fileManager:fileManager];
    return TRUE;
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
    }else{
        //文件已存在
    }
    return filePath;
}

+(void)saveContentToFile:(NSString*)filePath content:(UIImage*)image fileName:(NSString*)fileName fileManager:(NSFileManager*)fileManager
{
    NSError* error;
    
    NSData *data;
    
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
        
    } else {
        data = UIImagePNGRepresentation(image);
        
    }
    filePath=[filePath stringByAppendingString:@"/image/"];
    BOOL success=[fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
    filePath=[filePath stringByAppendingString:fileName];
    success= [fileManager createFileAtPath:filePath contents:data attributes:nil];
    if(!success){
        NSLog(@"Unable to save file:%@\nError:%@",filePath,error);
    }else{
        NSLog(@"文件保存成功！");
    }
}
+(UIImage *) getImageFromURL:(NSString *)fileURL {
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    result = [UIImage imageWithData:data];
    return result;
    
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
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189，177
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
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

#pragma mark - AES加密
//将string转成带密码的data
+(NSData*)encryptAESData:(NSString*)string {
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES256EncryptWithKey:APP_PUBLIC_PASSWORD];
    return encryptedData;
}

//将带密码的data转成string
+(NSString*)decryptAESData:(NSData*)data {
    //使用密码对data进行解密
    NSData *decryData = [data AES256DecryptWithKey:APP_PUBLIC_PASSWORD];
    //将解了密码的nsdata转化为nsstring
    NSString *string = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    return string;
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
@end