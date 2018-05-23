//
//  SnowEmitterLayer.h
//  ZZTest
//
//  Created by 多米智投 on 2018/5/21.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, SnowEmitterType) {
    SnowEmitterType_snow,
    SnowEmitterType_spray,
    SnowEmitterType_bomb,
};
@interface SnowEmitterLayer : CAEmitterLayer

@property (nonatomic, assign) SnowEmitterType type;

+ (instancetype)createWithType:(SnowEmitterType)type;

@end
