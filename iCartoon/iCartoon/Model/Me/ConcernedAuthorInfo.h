//
//  ConcernedAuthor.h
//  iCartoon
//
//  Created by 许成雄 on 16/4/1.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface ConcernedAuthorInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *authorId;       //ID
@property (strong, nonatomic) NSString *account;        //用户账户
@property (strong, nonatomic) NSString *nickname;       //昵称
@property (strong, nonatomic) NSString *avatarUrl;      //头像URL
@property (strong, nonatomic) NSString *signature;      //签名

@end
