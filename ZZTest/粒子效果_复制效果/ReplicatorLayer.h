//
//  ReplicatorLayer.h
//  ZZTest
//
//  Created by 多米智投 on 2018/5/22.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, ReplicatorLayerType) {
    ReplicatorLayerType_flip,
    ReplicatorLayerType_ripple,
    ReplicatorLayerType_array,
};
@interface ReplicatorLayer : CAReplicatorLayer

@property (nonatomic, assign) ReplicatorLayerType type;

+ (instancetype)createWithType:(ReplicatorLayerType)type;
- (void)startAnimation;

@end
