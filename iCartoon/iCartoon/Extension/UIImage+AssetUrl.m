//
//  UIImage+AssetUrl.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/2.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "UIImage+AssetUrl.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIImage (AssetUrl)

+ (void)imageForAssetUrl:(NSString *)assetUrl success:(void(^)(UIImage *))successBlock fail:(void(^)())failBlock {
    __block UIImage *image;
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:[NSURL URLWithString:assetUrl] resultBlock:^(ALAsset *asset) {
        // 使用asset来获取本地图片
        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
        CGImageRef imgRef = [assetRep fullResolutionImage];
        image = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:(UIImageOrientation)assetRep.orientation];
        if(nil == image) { // 获取图片失败
            failBlock();
            return;
        }
        successBlock(image);
     } failureBlock:^(NSError *error) {
         // 说明获取图片失败.
        failBlock();
     }];
}

@end
