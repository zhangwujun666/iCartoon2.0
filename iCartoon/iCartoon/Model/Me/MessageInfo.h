//
//  MessageInfo.h
//  iCartoon
//
//  Created by 许成雄 on 16/4/3.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface MessageInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *mid;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *sendTime;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *status;

@property (assign, nonatomic) BOOL isSelected;

@end
