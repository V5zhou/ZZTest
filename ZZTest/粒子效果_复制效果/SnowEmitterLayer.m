//
//  SnowEmitterLayer.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/21.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "SnowEmitterLayer.h"

@implementation SnowEmitterLayer

+ (instancetype)createWithType:(SnowEmitterType)type {
    SnowEmitterLayer *layer = [SnowEmitterLayer layer];
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer.type = type;
    return layer;
}

+ (instancetype)layer {
    SnowEmitterLayer *layer = [[SnowEmitterLayer alloc] init];
    layer.type = SnowEmitterType_snow;
    return layer;
}

- (void)setType:(SnowEmitterType)type {
    if (type != _type) {
        for (CALayer *layer in self.sublayers) {
            [layer removeAllAnimations];
            [layer removeFromSuperlayer];
        }
    }
    _type = type;
    switch (_type) {
        case SnowEmitterType_snow: {
            self.emitterPosition = CGPointMake(90, -30);
            self.emitterSize = CGSizeMake(180, 0);
            self.emitterShape = kCAEmitterLayerLine;
            self.emitterMode = kCAEmitterLayerOutline;
            
            self.masksToBounds = YES;
            
            CAEmitterCell *snowCell = [CAEmitterCell emitterCell];
            snowCell.birthRate = 2.0; //每秒出现多少个粒子
            snowCell.lifetime = 120.0; // 粒子的存活时间
            snowCell.velocity = -10; //速度
            snowCell.velocityRange = 10; // 运动速度的浮动值
            snowCell.yAcceleration = 2;//粒子在y方向上的加速度
            snowCell.emissionRange = 0.5 * M_PI; //发射的弧度
            snowCell.spinRange = 0.25 * M_PI; // 粒子的平均旋转速度
            snowCell.alphaSpeed = 2.0f; //粒子透明度在生命周期内的改变速度
            snowCell.contents = (id)[UIImage imageNamed:@"snow"].CGImage;
            snowCell.contentsScale = 30;
            self.emitterCells = @[snowCell];
        }
            break;
            
        case SnowEmitterType_spray: {
            //发射点的位置
            self.emitterPosition = CGPointMake(90, 170);
            //
            self.emitterSize = CGSizeMake(5.0, 0.0);
            self.emitterShape = kCAEmitterLayerLine;
            self.emitterMode = kCAEmitterLayerOutline;
            
            CAEmitterCell *snowCell = [CAEmitterCell emitterCell];
            snowCell.birthRate = 50.0;
            snowCell.lifetime = 10.0;
            snowCell.velocity = 40;
            snowCell.velocityRange = 10;
            snowCell.yAcceleration = 2;
            snowCell.emissionRange =  M_PI / 9;
            snowCell.scale = 0.1; //缩小比例
            snowCell.scaleRange = 0.08;// 平均缩小比例
            snowCell.contents = (id)[UIImage imageNamed:@"sparkle"].CGImage;
            snowCell.color = [UIColor greenColor].CGColor; //[UIColor colorWithRed:0.6 green:0.658 blue:0.743 alpha:1.0].CGColor;
            
            self.emitterCells = @[snowCell];
        }
            break;
            
        case SnowEmitterType_bomb: {
            //configure emitter
            self.renderMode = kCAEmitterLayerAdditive;
            self.emitterPosition = CGPointMake(90, 90);
            self.emitterSize = CGSizeMake(10, 10);
            
            //create a particle template
            CAEmitterCell *cell = [[CAEmitterCell alloc] init];
            cell.contents = (id)[UIImage imageNamed:@"sparkle"].CGImage;
            cell.birthRate = 80;
            cell.lifetime = 4.0;
            cell.alphaSpeed = -0.3;
            cell.velocity = 50;
            cell.velocityRange = 50;
            cell.scale = 0.1;
            cell.scaleRange = 0.08;
            cell.emissionRange = M_PI * 2.0;
            cell.color = [UIColor brownColor].CGColor;
            
            self.emitterCells = @[cell];
        }
            break;
            
        default:
            break;
    }
}

@end
