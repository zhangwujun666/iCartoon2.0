//
//  CustomImagePickerController.h
//  iCartoon
//
//  Created by 许成雄 on 16/4/23.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomImagePickerControllerSourceType) {
    CustomImagePickerControllerSourceTypePhotoLibrary,
    CustomImagePickerControllerSourceTypeCamera
};

@class CustomImagePickerController;

@protocol CustomImagePickerControllerDelegate <NSObject>

- (void)imagePickerController:(CustomImagePickerController *)imagePickerController selectedImages:(NSArray *)selectedImages soureType:(CustomImagePickerControllerSourceType)type;

@end

@interface CustomImagePickerController : UIViewController

@property (strong, nonatomic) NSMutableArray *selectedPictureArray;

@property (assign, nonatomic) id<CustomImagePickerControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger maxNumOfPictures;
@property (assign, nonatomic) NSString * from;

@end
