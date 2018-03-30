//
//  CommentInfo.h
//  GaoZhi
//
//  Created by 寻梦者 on 15/11/7.
//  Copyright © 2015年 GlenN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface CommentInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *commentId;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *senderId;
@property (strong, nonatomic) NSString *senderName;
@property (strong, nonatomic) NSString *senderAvatar;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *advertisementId;
@property (strong, nonatomic) NSString *favorNum;
@property (strong, nonatomic) NSString *favorStatus;

@end
