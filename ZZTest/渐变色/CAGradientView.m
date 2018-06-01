//
//  CAGradientView.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/23.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "CAGradientView.h"

@implementation CAGradientView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CAGradientLayer *layer = (CAGradientLayer *)self.layer;
        layer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor yellowColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor];
        layer.locations = @[@0.2, @0.5, @0.8];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(1, 0);
        
        //是否开启mask
        layer.mask = [self circleMaskLayer];
    }
    return self;
}

- (CALayer *)circleMaskLayer {
    CGFloat edge = 5;
    CGFloat lineWidth = edge*2;
    CGRect rect = CGRectMake(edge, edge, self.frame.size.width - edge*2, self.frame.size.height - edge*2);
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = rect;
    mask.path = [UIBezierPath bezierPathWithOvalInRect:rect].CGPath;
    mask.strokeColor = [UIColor whiteColor].CGColor;
    mask.fillColor = [UIColor clearColor].CGColor;
    mask.lineWidth = lineWidth;
    mask.lineDashPattern = @[@(lineWidth), @(lineWidth)];
    return mask;
}

@end
