//
//  MyTaskItem.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface MyTaskInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *tid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *time;

@end
