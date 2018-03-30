//
//  UserInteractionInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/13.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface UserInteractionInfo : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *favorNum;
@property (strong, nonatomic) NSString *postNum;
@property (strong, nonatomic) NSString *concernedNum;

@end
