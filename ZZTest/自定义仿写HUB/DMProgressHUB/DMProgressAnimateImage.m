//
//  DMProgressAnimateImage.m
//  Test
//
//  Created by 多米智投 on 2018/5/14.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "DMProgressAnimateImage.h"

@implementation DMProgressAnimateImage

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void)showTips {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(_radiaW, _radiaW) radius:_radiaW - _strokeWidth/2.0 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [path moveToPoint:CGPointMake(_radiaW, _strokeWidth + 4)];
    [path addLineToPoint:CGPointMake(_radiaW, _radiaW*2 - _strokeWidth - 10)];
    [path moveToPoint:CGPointMake(_radiaW, _radiaW*2 - _strokeWidth - 4)];
    [path addLineToPoint:CGPointMake(_radiaW, _radiaW*2 - _strokeWidth - 4)];
    [self drawAnimate:path];
}
- (void)showError {
    CGFloat offsetCenter = (_radiaW - _strokeWidth - 3) * sin(M_PI/4);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(_radiaW, _radiaW) radius:_radiaW - _strokeWidth/2.0 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [path moveToPoint:CGPointMake(_radiaW + offsetCenter, _radiaW - offsetCenter)];
    [path addLineToPoint:CGPointMake(_radiaW - offsetCenter, _radiaW + offsetCenter)];
    [path moveToPoint:CGPointMake(_radiaW - offsetCenter, _radiaW - offsetCenter)];
    [path addLineToPoint:CGPointMake(_radiaW + offsetCenter, _radiaW + offsetCenter)];
    [self drawAnimate:path];
}
- (void)showSuccess {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(_radiaW, _radiaW) radius:_radiaW - _strokeWidth/2.0 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [path moveToPoint:CGPointMake(_strokeWidth + 3, _radiaW)];
    [path addLineToPoint:CGPointMake(_radiaW/4*3, _radiaW/2*3)];
    [path addLineToPoint:CGPointMake(_radiaW + (_radiaW - _strokeWidth - 3) * cos(M_PI/6), _radiaW - (_radiaW - _strokeWidth - 3) * sin(M_PI/6))];
    [self drawAnimate:path];
}

//外界传入path绘制
- (void)drawAnimate:(UIBezierPath *)path {
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.path = path.CGPath;
    layer.lineWidth = _strokeWidth;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = _strokeColor.CGColor;
    
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animate.fromValue = @0;
    animate.toValue = @1;
    animate.duration = 1;
    animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:animate forKey:@"drawPath"];
}

@end
