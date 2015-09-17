//
//  NSData+AES.h
//  WeiNI
//
//  Created by air on 15/3/13.
//  Copyright (c) 2015年 weini. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

@end