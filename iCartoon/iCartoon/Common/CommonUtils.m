//
//  CommonUtils.m
//  iCartoon
//
//  Created by 寻梦者 on 15/10/8.
//  Copyright (c) 2015年 xuchengxiong. All rights reserved.
//

#import "CommonUtils.h"
@interface CommonUtils ()
@property (nonatomic,strong)NSMutableData * data;

@end

@implementation CommonUtils
+ (UIImage *)fixedOrientationImage:(UIImage *)originalImage {
    // No-op if the orientation is already correct
    if (originalImage.imageOrientation == UIImageOrientationUp)
        return originalImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (originalImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, originalImage.size.width, originalImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, originalImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, originalImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (originalImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, originalImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, originalImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, originalImage.size.width, originalImage.size.height,
                                             CGImageGetBitsPerComponent(originalImage.CGImage), 0,
                                             CGImageGetColorSpace(originalImage.CGImage),
                                             CGImageGetBitmapInfo(originalImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (originalImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,originalImage.size.height,originalImage.size.width), originalImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,originalImage.size.width,originalImage.size.height), originalImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;

}

+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat newWidth = 0.0f;
    CGFloat newHeight = 0.0f;
    if(newSize.width / newSize.height > imageWidth / imageHeight) {
        newWidth = newSize.height * imageWidth / imageHeight;
        newWidth = ceil(newWidth);
        newHeight = ceil(newSize.height);
    } else {
        newHeight = newSize.width * imageHeight / imageWidth;
        newHeight = ceil(newHeight);
        newWidth = ceil(newSize.width);
    }
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    
    // Get the new image from the context
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

/**
 * Given the reference date and return a pretty date string to show
 *
 * @param refrence the date to refrence
 *
 * @return a pretty date string, like "just now", "1 minute ago", "2 weeks ago", etc
 */
+ (NSString *)prettyDateWithReference:(NSString  *)referenceStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *reference = [formatter dateFromString:referenceStr];
    NSString *suffix = @"现在";
    float different = [reference timeIntervalSinceDate:[NSDate date]];
    if (different < 0) {
        different = -different;
        suffix = @"前";
    }
    
    // days = different / (24 * 60 * 60), take the floor value
    float dayDifferent = floor(different / 86400);
    
    int days   = (int)dayDifferent;
    int weeks  = (int)floor(dayDifferent / 7);
    int months = (int)floor(dayDifferent / 30);
    int years  = (int)floor(dayDifferent / 365);
    
    // It belongs to today
    if (dayDifferent <= 0) {
        // lower than 60 seconds
        if (different < 60) {
            return @"刚刚";
        }
        
        // lower than 120 seconds => one minute and lower than 60 seconds
        if (different < 120) {
            return [NSString stringWithFormat:@"1分钟%@", suffix];
        }
        
        // lower than 60 minutes
        if (different < 60 * 60) {
            return [NSString stringWithFormat:@"%d分钟%@", (int)floor(different / 60), suffix];
        }
        
        // lower than 60 * 2 minutes => one hour and lower than 60 minutes
//        if (different < 7200) {
//            return [NSString stringWithFormat:@"1小时%@", suffix];
//        }
//        
        // lower than one day
//        if (different < 86400) {
//            return [NSString stringWithFormat:@"%d小时%@", (int)floor(different / 3600), suffix];
//        }
    }
    // lower than one week
    else if (days < 7) {
//        return [NSString stringWithFormat:@"%d天%@", days, suffix];
    }
    // lager than one week but lower than a month
    else if (weeks < 4) {
//        return [NSString stringWithFormat:@"%d天%@", days, suffix];
    }
    // lager than a month and lower than a year
    else if (months < 12) {
//        return [NSString stringWithFormat:@"%d个月%@", months, suffix];
//        return [referenceStr substringWithRange:NSMakeRange(5, 5)];
    }
    // lager than a year
    else {
//        return [NSString stringWithFormat:@"%d年%@", years, suffix];
//        return [referenceStr substringWithRange:NSMakeRange(5, 5)];
    }
    return self.description;
}

//判断中英混合的的字符串长度
+ (NSInteger)mixedLengthOfString:(NSString*)string {
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [string dataUsingEncoding:encoding];
    return [data length];
    
//    int strlength = 0;
//    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
//    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
//        if (*p) {
//            p++;
//            strlength++;
//        }
//        else {
//            p++;
//        }
//        
//    }
//    return strlength;
}

//根据URL获取图片尺寸
- (CGSize)getImageSizeWithURL:(id)imageURL andData:(NSData *)data{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil) {
        return CGSizeZero;                  // url不正确返回CGSizeZero
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
        
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]) {
        size = [self getPNGImageSizeWithRequest:request];
    } else if([pathExtendsion isEqual:@"gif"]) {
        size =  [self getGIFImageSizeWithRequest:request];
    } else {
        size = [self getJPGImageSizeWithData:data];
    }
    if(CGSizeEqualToSize(CGSizeZero, size)) {
        //如果获取文件头信息失败,发送异步请求请求原图
        NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image) {
            size = image.size;
        }
    }
    return size;
}

//获取PNG图片的大小
- (CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request {
   
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8) {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

//获取gif图片的大小
- (CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request {
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4) {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

// 获取jpg图片的大小
- (CGSize)getJPGImageSizeWithData:(NSData*)data {
//    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
//    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    if([self.data length] <= 0x58) {
        return CGSizeZero;
    }
    if([self.data length] < 210) {
        //肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [self.data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [self.data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [self.data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [self.data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [self.data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if(word == 0xdb) {
            [self.data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if(word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [self.data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [self.data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [self.data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [self.data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [self.data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [self.data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [self.data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [self.data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}
    
@end
