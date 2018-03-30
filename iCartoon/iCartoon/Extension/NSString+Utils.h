//
//  NSString+Utils.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;

//判断是否是空字符窜
+ (BOOL)isBlankString:(NSString *)string;

//去除文本中的html标签
+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;

//是否含有表情字符
+ (BOOL)isContainsEmoji:(NSString *)string;

@end
