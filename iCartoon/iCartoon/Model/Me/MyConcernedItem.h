//
//  MyConcerndeItem.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface MyConcernedItem : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *theme;

@end
