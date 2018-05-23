//
//  ReplicatorLayer.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/22.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "ReplicatorLayer.h"

@interface ReplicatorLayer ()

@property (nonatomic, strong) CAShapeLayer *animate_layer;

@end

@implementation ReplicatorLayer

+ (instancetype)createWithType:(ReplicatorLayerType)type {
    ReplicatorLayer *layer = [ReplicatorLayer layer];
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer.type = type;
    return layer;
}

+ (instancetype)layer {
    ReplicatorLayer *layer = [[ReplicatorLayer alloc] init];
    return layer;
}

- (void)setType:(ReplicatorLayerType)type {
    if (type != _type) {
        [self.animate_layer removeAllAnimations];
        [self.animate_layer removeFromSuperlayer];
    }
    _type = type;
    switch (_type) {
        case ReplicatorLayerType_flip: {
            CGFloat margin = 5;
            CGFloat W = 180;
            CGFloat dotWidth = 30;
            
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.frame = CGRectMake(0, (W - dotWidth)/2, dotWidth, dotWidth);
            layer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, dotWidth, dotWidth)].CGPath;
            layer.fillColor = [UIColor brownColor].CGColor;
            self.animate_layer = layer;
            
            self.instanceRedOffset = -0.2;
            self.instanceBlueOffset = -0.1;
            self.instanceGreenOffset = -0.08;
            self.instanceDelay = 0.05;
            self.instanceCount = 5;
            self.instanceTransform = CATransform3DMakeTranslation(margin + dotWidth, 0, 0);
            [self addSublayer:self.animate_layer];
        }
            break;
            
        case ReplicatorLayerType_ripple: {
            CGFloat W = 180;
            
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.frame = CGRectMake(0, 0, W, W);
            layer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, W, W)].CGPath;
            layer.fillColor = [UIColor redColor].CGColor;
            layer.opacity = 0;
            self.animate_layer = layer;
            
            self.instanceDelay = 0.5;
            self.instanceCount = 8;
            [self addSublayer:self.animate_layer];
        }
            break;
            
        case ReplicatorLayerType_array: {
            CGFloat margin = 5.0;
            CGFloat cols = 5;
            CGFloat W = 180;
            CGFloat dotW = (W - margin * (cols - 1)) / cols;
            
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.frame = CGRectMake(0, 0, dotW, dotW);
            layer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, dotW, dotW)].CGPath;
            layer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.3].CGColor;
            layer.transform = CATransform3DMakeScale(0.8, 0.8, 1);
            self.animate_layer = layer;
            
            CAReplicatorLayer *replay_x = [CAReplicatorLayer layer];
            replay_x.frame = CGRectMake(0, 0, W, W);
            replay_x.instanceDelay = 1.0/cols;
            replay_x.instanceCount = cols;
            replay_x.instanceTransform = CATransform3DMakeTranslation(dotW + margin, 0, 0);
            [replay_x addSublayer:layer];
            
            self.instanceDelay = 1.0/cols;
            self.instanceCount = cols;
            self.instanceTransform = CATransform3DMakeTranslation(0, dotW + margin, 0);
            [self addSublayer:replay_x];
        }
            break;
            
        default:
            break;
    }
}

- (void)startAnimation {
    switch (_type) {
        case ReplicatorLayerType_flip: {
            CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
            anima.fromValue = @(0);
            anima.toValue = @(M_PI*2);
            anima.duration = 1;
            anima.repeatCount = HUGE;
            [self.animate_layer addAnimation:anima forKey:nil];
        }
            break;
            
        case ReplicatorLayerType_ripple: {
            CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacity.fromValue = @(0.3);
            opacity.toValue = @(0);
            
            CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scale.fromValue = @(0);
            scale.toValue = @(1);
            
            CAAnimationGroup *group = [CAAnimationGroup animation];
            group.duration = 4;
            group.animations = @[opacity, scale];
            group.autoreverses = NO;
            group.repeatCount = HUGE;
            [self.animate_layer addAnimation:group forKey:nil];
        }
            break;
            
        case ReplicatorLayerType_array: {
            CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnima.fromValue = @0.8;
            scaleAnima.toValue = @0.2;
            scaleAnima.duration = 1;
            scaleAnima.repeatCount = HUGE;
            scaleAnima.autoreverses = YES;
            [self.animate_layer addAnimation:scaleAnima forKey:nil];
        }
            break;
            
        default:
            break;
    }
}

@end
