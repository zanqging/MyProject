//
//  UserInfoHeader.h
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpUtils.h"
#import "ASIFormDataRequest.h"
@interface UserInfoHeader : UIView<ASIHTTPRequestDelegate>
{
    HttpUtils* httpUtil;
}
@end
