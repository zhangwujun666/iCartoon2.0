//
//  DES3Util.h
//  shsm
//
//  Created by w3studio on 13-3-29.
//  Copyright (c) 2013年 w3studio. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface DES3Util : NSObject {
    
}

// 加密方法
+ (NSString*)encrypt:(NSData*)data;

// 解密方法
+ (NSString*)decrypt:(NSData*)encryptData;

@end
