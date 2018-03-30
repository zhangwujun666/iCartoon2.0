//
//  CommonUtils.h
//  iCartoon
//
//  Created by 寻梦者 on 15/10/8.
//  Copyright (c) 2015年 xuchengxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject

+ (UIImage *)fixedOrientationImage:(UIImage *)originalImage;

+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (NSString *)prettyDateWithReference:(NSString  *)referenceStr;

//判断中英混合的的字符串长度
+ (NSInteger)mixedLengthOfString:(NSString*)string;

//根据URL获取图片尺寸
- (CGSize)getImageSizeWithURL:(id)imageURL andData:(NSData *)data;

@end
