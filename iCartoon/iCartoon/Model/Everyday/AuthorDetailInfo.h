//
//  AuthorDetailInfo.h
//  iCartoon
//
//  Created by 许成雄 on 16/4/3.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface AuthorDetailInfo : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *signature;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *bloodType;
@property (strong, nonatomic) NSString *deviceId;
@property (strong, nonatomic) NSString *isFollowed;


@end
