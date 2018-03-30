//
//  MD5File.h
//  ReactContainer
//
//  Created by oo_life on 15/12/21.
//  Copyright © 2015年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5File : NSObject
+(NSString*)md5:(NSString*)str;
+(NSString *)file_md5:(NSString*) path;
@end
