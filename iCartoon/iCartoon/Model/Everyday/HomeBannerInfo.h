//
//  HomeBannerInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/17.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface HomeBannerInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *relatedType;
@property (strong, nonatomic) NSString *relatedId;
@property (strong, nonatomic) NSString *link;

@end
