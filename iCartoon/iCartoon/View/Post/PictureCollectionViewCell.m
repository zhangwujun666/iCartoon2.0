//
//  PictureCollectionViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/28.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "PictureCollectionViewCell.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface PictureCollectionViewCell()

@property (strong, nonatomic) UIImageView *pictureImageView;
@property (strong, nonatomic) UIImageView *selectImageView;

@end

@implementation PictureCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        CGFloat width = (SCREEN_WIDTH - 4 * TRANS_VALUE(4.0f)) / 3;
        CGFloat height = width;
        self.pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.pictureImageView];
        self.pictureImageView.image = [UIImage imageNamed:@"bg_post_picture"];
        self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - TRANS_VALUE(28.0f), TRANS_VALUE(4.0f), TRANS_VALUE(24.0f), TRANS_VALUE(24.0f))];
        self.selectImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.selectImageView.image = [UIImage imageNamed:@"ic_picture_unselected"];
        [self.contentView addSubview:self.selectImageView];
        
        self.contentView.backgroundColor = [UIColor colorWithRed:230.0f/255 green:230.0f/255 blue:230.0f/255 alpha:1.0f];
    }
    self.backgroundColor = [UIColor colorWithRed:230.0f/255 green:230.0f/255 blue:230.0f/255 alpha:1.0f];
    
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    if(imageUrl) {
        [self.pictureImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        self.pictureImageView.contentMode =  UIViewContentModeScaleAspectFill;
        self.pictureImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.pictureImageView.clipsToBounds  = YES;
        self.selectImageView.hidden = NO;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            // 处理耗时操作的代码块...
            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            NSURL *url=[NSURL URLWithString:imageUrl];
//            //通知主线程刷新
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //回调或者说是通知主线程刷新，
                [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
                    UIImage *image = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
                    self.pictureImageView.image = image;
                } failureBlock:^(NSError *error) {
                    NSLog(@"error=%@",error);
                }];
//            });
//        });
       
        
    } else {
        self.pictureImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.pictureImageView.image = [UIImage imageNamed:@"ic_capture"];
        self.selectImageView.hidden = YES;
    }
}

- (void)setHasSelected:(BOOL)hasSelected {
    _hasSelected = hasSelected;
    if(_hasSelected) {
        self.selectImageView.image = [UIImage imageNamed:@"ic_picture_selected"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"ic_picture_unselected"];
    }
}


@end
