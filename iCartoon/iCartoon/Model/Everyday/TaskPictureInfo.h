//
//  TaskPictureInfo.h
//  iCartoon
//
//  Created by 许成雄 on 16/5/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface TaskPictureInfo :MTLModel<MTLJSONSerializing>

@property (strong, nonnull) NSString *url;
@property (strong, nonnull) NSString *title;
@property (strong, nonnull) NSString *userName;
@property (strong, nonnull) NSString *content;
@end
