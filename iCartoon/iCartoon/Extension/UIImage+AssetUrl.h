//
//  UIImage+AssetUrl.h
//  iCartoon
//
//  Created by 许成雄 on 16/4/2.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AssetUrl)

+ (void)imageForAssetUrl:(NSString *)assetUrl success:(void(^)(UIImage *))successBlock fail:(void(^)())failBlock;

@end
