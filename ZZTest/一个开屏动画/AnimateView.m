//
//  AnimateView.m
//  OpenScreenAnimate
//
//  Created by 多米智投 on 2018/3/15.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "AnimateView.h"
#import "UIColor+Extend.h"

#define smallCircleWidth 50.0
#define fullCircleWidth 100.0
#define triangleWidth 55.0
#define KAnimationDuration1 0.5
#define KAnimationDuration2 1
#define KAnimationDuration3 1
#define KAnimationDuration4 1
#define KAnimationDuration5 1
#define KAnimationDuration6 1
#define KAnimationDuration7 0.5
@interface AnimateView() <CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *triangleLayer;
@property (nonatomic, strong) CAShapeLayer *rectangleLayer;
@property (nonatomic, strong) CAShapeLayer *waterFlowLayer;
@property (nonatomic, strong) CATextLayer *welcomeLayer;

@end

@implementation AnimateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self run];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self run];
    }
    return self;
}

- (void)run {
    [self addCircleLayer];
    [self circleExpand];
}

#pragma mark - UIBezierPath
//小圆
- (UIBezierPath *)circleSmallPath {
    CGRect rect = CGRectOffset(CGRectMake(0, 0, smallCircleWidth, smallCircleWidth), (CGRectGetWidth(self.layer.bounds)-smallCircleWidth)/2, (CGRectGetHeight(self.layer.bounds)-smallCircleWidth)/2);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    return path;
}

//大圆
- (UIBezierPath *)circleFullPath {
    CGRect rect = CGRectOffset(CGRectMake(0, 0, fullCircleWidth, fullCircleWidth), (CGRectGetWidth(self.layer.bounds)-fullCircleWidth)/2, (CGRectGetHeight(self.layer.bounds)-fullCircleWidth)/2);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    return path;
}

//竖直捏
- (UIBezierPath *)circleVerticalSquishPath {
    CGRect rect = CGRectOffset(CGRectMake(0, 0, fullCircleWidth, fullCircleWidth), (CGRectGetWidth(self.layer.bounds)-fullCircleWidth)/2, (CGRectGetHeight(self.layer.bounds)-fullCircleWidth)/2);
    rect = CGRectInset(rect, 0, fullCircleWidth/15);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    return path;
}

//水平捏
- (UIBezierPath *)circleHorizontalSquishPath {
    CGRect rect = CGRectOffset(CGRectMake(0, 0, fullCircleWidth, fullCircleWidth), (CGRectGetWidth(self.layer.bounds)-fullCircleWidth)/2, (CGRectGetHeight(self.layer.bounds)-fullCircleWidth)/2);
    rect = CGRectInset(rect, fullCircleWidth/15, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    return path;
}

//制作三角
- (UIBezierPath *)trianglePath:(NSArray *)points {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointFromString(points[0])];
    [path addLineToPoint:CGPointFromString(points[1])];
    [path addLineToPoint:CGPointFromString(points[2])];
    [path closePath];
    return path;
}

//每个步骤的三个角
- (NSArray *)pointsAtStep:(NSInteger)step {
    switch (step) {
        case 0:
            return @[
                     NSStringFromCGPoint(CGPointMake(self.layer.position.x, self.layer.position.y + - 1/2.0 * triangleWidth)),
                     NSStringFromCGPoint(CGPointMake(self.layer.position.x - sqrt(3)/2.0/2.0 * triangleWidth, self.layer.position.y + 1/2.0/2.0 * triangleWidth)),
                     NSStringFromCGPoint(CGPointMake(self.layer.position.x + sqrt(3)/2.0/2.0 * triangleWidth, self.layer.position.y + 1/2.0/2.0 * triangleWidth)),
                     ];
            break;
        case 1:
            return @[
                     NSStringFromCGPoint(CGPointMake(self.layer.position.x, self.layer.position.y + - 1/2.0 * triangleWidth)),
                     NSStringFromCGPoint(CGPointMake(self.layer.position.x - sqrt(3)/2.0/2.0 * triangleWidth, self.layer.position.y + 1/2.0/2.0 * triangleWidth)),
                     NSStringFromCGPoint(CGPointMake(self.layer.position.x + sqrt(3)/2.0 * triangleWidth, self.layer.position.y + 1/2.0 * triangleWidth)),
                     ];
            break;
        case 2:
            return @[
                     NSStringFromCGPoint(CGPointMake(self.layer.position.x, self.layer.position.y + - 1/2.0 * triangleWidth)),
                     NSStringFromCGPoint(CGPointMake(self.layer.position.x - sqrt(3)/2.0 * triangleWidth, self.layer.position.y + 1/2.0 * triangleWidth)),
                     NSStringFromCGPoint(CGPointMake(self.layer.position.x + sqrt(3)/2.0 * triangleWidth, self.layer.position.y + 1/2.0 * triangleWidth)),
                     ];
            break;
        case 3:
            return @[
                     NSStringFromCGPoint(CGPointMake(self.layer.position.x, self.layer.position.y + - 1 * triangleWidth)),
                     NSStringFromCGPoint(CGPointMake(self.layer.position.x - sqrt(3)/2.0 * triangleWidth, self.layer.position.y + 1/2.0 * triangleWidth)),
                     NSStringFromCGPoint(CGPointMake(self.layer.position.x + sqrt(3)/2.0 * triangleWidth, self.layer.position.y + 1/2.0 * triangleWidth)),
                     ];
            break;
            
        default:
            return nil;
            break;
    }
}

//正方形
- (UIBezierPath *)rectanglePath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, sqrt(3)*(triangleWidth + 10))];
    [path addLineToPoint:CGPointMake(sqrt(3)*(triangleWidth + 10), sqrt(3)*(triangleWidth + 10))];
    [path addLineToPoint:CGPointMake(sqrt(3)*(triangleWidth + 10), 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path closePath];
    return path;
}

//注水动画的path
- (UIBezierPath *)waterFolowPath:(NSInteger)index {
    NSArray *points = [self waterFolowPoints:index];
    if (!points) {
        return nil;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointFromString(points[0])];
    [path addCurveToPoint:CGPointFromString(points[1]) controlPoint1:CGPointFromString(points[2]) controlPoint2:CGPointFromString(points[3])];
    [path addLineToPoint:CGPointFromString(points[4])];
    [path addLineToPoint:CGPointFromString(points[5])];
    [path closePath];
    return path;
}

- (NSArray *)waterFolowPoints:(NSInteger)index {
    CGFloat W = sqrt(3)*(triangleWidth + 10);
    CGFloat Y = W - index/4.0*W;
    switch (index) {
        case 0:
            return @[NSStringFromCGPoint(CGPointMake(0, Y)),
                     NSStringFromCGPoint(CGPointMake(W, Y)),
                     NSStringFromCGPoint(CGPointMake(W/3.0, Y)),
                     NSStringFromCGPoint(CGPointMake(W/3.0*2, Y)),
                     NSStringFromCGPoint(CGPointMake(W, W)),
                     NSStringFromCGPoint(CGPointMake(0, W))];
            break;
        case 1:
            return @[NSStringFromCGPoint(CGPointMake(0, Y)),
                     NSStringFromCGPoint(CGPointMake(W, Y)),
                     NSStringFromCGPoint(CGPointMake(W/3.0, Y + W/2.0)),
                     NSStringFromCGPoint(CGPointMake(W/3.0*2, Y - W/2.0)),
                     NSStringFromCGPoint(CGPointMake(W, W)),
                     NSStringFromCGPoint(CGPointMake(0, W))];
            break;
        case 2:
            return @[NSStringFromCGPoint(CGPointMake(0, Y)),
                     NSStringFromCGPoint(CGPointMake(W, Y)),
                     NSStringFromCGPoint(CGPointMake(W/3.0, Y - W/2.0)),
                     NSStringFromCGPoint(CGPointMake(W/3.0*2, Y + W/2.0)),
                     NSStringFromCGPoint(CGPointMake(W, W)),
                     NSStringFromCGPoint(CGPointMake(0, W))];
            break;
        case 3:
            return @[NSStringFromCGPoint(CGPointMake(0, Y)),
                     NSStringFromCGPoint(CGPointMake(W, Y)),
                     NSStringFromCGPoint(CGPointMake(W/3.0, Y + W/2.0)),
                     NSStringFromCGPoint(CGPointMake(W/3.0*2, Y - W/2.0)),
                     NSStringFromCGPoint(CGPointMake(W, W)),
                     NSStringFromCGPoint(CGPointMake(0, W))];
            break;
        case 4:
            return @[NSStringFromCGPoint(CGPointMake(0, Y)),
                     NSStringFromCGPoint(CGPointMake(W, Y)),
                     NSStringFromCGPoint(CGPointMake(W/3.0, Y)),
                     NSStringFromCGPoint(CGPointMake(W/3.0*2, Y)),
                     NSStringFromCGPoint(CGPointMake(W, W)),
                     NSStringFromCGPoint(CGPointMake(0, W))];
            break;
            
        default:
            break;
    }
    return nil;
}

#pragma mark - Layers
- (CALayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.bounds = self.layer.bounds;
        _circleLayer.position = self.layer.position;
        _circleLayer.path = [self rectanglePath].CGPath;
        _circleLayer.fillColor = [UIColorHex(#d820a6) CGColor];
    }
    return _circleLayer;
}

- (CALayer *)triangleLayer {
    if (!_triangleLayer) {
        _triangleLayer = [CAShapeLayer layer];
        _triangleLayer.bounds = self.layer.bounds;
        _triangleLayer.position = self.layer.position;
        _triangleLayer.path = [self trianglePath:[self pointsAtStep:0]].CGPath;
        _triangleLayer.fillColor = [UIColorHex(#d820a6) CGColor];
        _triangleLayer.strokeColor = [UIColorHex(#d820a6) CGColor];
        _triangleLayer.lineCap = kCALineCapRound;
        _triangleLayer.lineJoin = kCALineJoinRound;
        _triangleLayer.lineWidth = 12;
    }
    return _triangleLayer;
}

- (CAShapeLayer *)rectangleLayer {
    if (!_rectangleLayer) {
        _rectangleLayer = [CAShapeLayer layer];
        _rectangleLayer.bounds = CGRectMake(0, 0, sqrt(3)* (triangleWidth + 10), sqrt(3)* (triangleWidth + 10));
        _rectangleLayer.position = CGPointMake(self.layer.position.x, self.layer.position.y - (sqrt(3)-1)/2.0*(triangleWidth + 10));
        _rectangleLayer.path = [self rectanglePath].CGPath;
        _rectangleLayer.lineCap = kCALineCapSquare;
        _rectangleLayer.lineWidth = 6;
        _rectangleLayer.strokeColor = [UIColorHex(#3fe0b0) CGColor];
        _rectangleLayer.fillColor = [[UIColor clearColor] CGColor];
    }
    return _rectangleLayer;
}

- (CAShapeLayer *)waterFlowLayer {
    if (!_waterFlowLayer) {
        _waterFlowLayer = [CAShapeLayer layer];
        _waterFlowLayer.bounds = CGRectMake(0, 0, sqrt(3)* (triangleWidth + 10), sqrt(3)* (triangleWidth + 10));
        _waterFlowLayer.position = CGPointMake(self.layer.position.x, self.layer.position.y - (sqrt(3)-1)/2.0*(triangleWidth + 10));
        _waterFlowLayer.path = [self waterFolowPath:0].CGPath;
        _waterFlowLayer.fillColor = [UIColorHex(#3fe0b0) CGColor];
        _waterFlowLayer.strokeColor = [UIColorHex(#3fe0b0) CGColor];
    }
    return _waterFlowLayer;
}

- (CALayer *)welcomeLayer {
    if (!_welcomeLayer) {
        _welcomeLayer = [CATextLayer layer];
        _welcomeLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame), 40);
        _welcomeLayer.position = self.layer.position;
        _welcomeLayer.contentsScale = [UIScreen mainScreen].scale;
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"Welcome!"
                                                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:40],
                                                                                                           NSForegroundColorAttributeName: [UIColor whiteColor]}];
        _welcomeLayer.string = attribute;
        _welcomeLayer.alignmentMode = @"center";
    }
    return _welcomeLayer;
}

#pragma mark - 动画组
#pragma mark - 1. 添加圓并放大
- (void)addCircleLayer {
    [self.layer addSublayer:self.circleLayer];
}

- (void)circleExpand {
    CABasicAnimation *expand = [CABasicAnimation animationWithKeyPath:@"path"];
    expand.delegate = self;
    expand.fromValue = (__bridge id _Nullable)([self circleSmallPath].CGPath);
    expand.toValue = (__bridge id _Nullable)([self circleFullPath].CGPath);
    expand.duration = KAnimationDuration1;
    expand.fillMode = kCAFillModeForwards;
    expand.removedOnCompletion = false;
    [self.circleLayer addAnimation:expand forKey:@"__expand__"];
}

#pragma mark - 2. 水平与竖直捏
- (void)squishCircle {
    CAKeyframeAnimation *squish = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    squish.delegate = self;
    squish.values = @[
                     (__bridge id _Nullable)([self circleFullPath].CGPath),
                     (__bridge id _Nullable)([self circleVerticalSquishPath].CGPath),
                     (__bridge id _Nullable)([self circleHorizontalSquishPath].CGPath),
                     (__bridge id _Nullable)([self circleVerticalSquishPath].CGPath),
                     (__bridge id _Nullable)([self circleFullPath].CGPath),
                     ];
    squish.duration = KAnimationDuration2;
    squish.fillMode = kCAFillModeForwards;
    squish.removedOnCompletion = NO;
    [self.circleLayer addAnimation:squish forKey:@"__squish__"];
}

#pragma mark - 3. 伸出三只脚

- (void)addTriangleLayer {
    [self.circleLayer addSublayer:self.triangleLayer];
}

- (void)triangleAnimate {
    //三步动画
    CAKeyframeAnimation *triangle = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    triangle.delegate = self;
    triangle.values = @[
                        (__bridge id _Nullable)([self trianglePath:[self pointsAtStep:0]].CGPath),
                        (__bridge id _Nullable)([self trianglePath:[self pointsAtStep:1]].CGPath),
                        (__bridge id _Nullable)([self trianglePath:[self pointsAtStep:2]].CGPath),
                        (__bridge id _Nullable)([self trianglePath:[self pointsAtStep:3]].CGPath),
                        ];
    triangle.fillMode = kCAFillModeForwards;
    triangle.removedOnCompletion = NO;
    [self.triangleLayer addAnimation:triangle forKey:@"__triangle__"];
}

#pragma mark - 4. 旋转

- (void)rotate {
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.delegate = self;
    rotate.toValue = @(M_PI*2);
    rotate.duration = KAnimationDuration4;
    rotate.fillMode = kCAFillModeForwards;
    rotate.removedOnCompletion = YES;
    [self.circleLayer addAnimation:rotate forKey:nil];
    
    //收起圆
    CABasicAnimation *toSmall = [CABasicAnimation animationWithKeyPath:@"path"];
    toSmall.delegate = self;
    toSmall.fromValue = (__bridge id _Nullable)([self circleFullPath].CGPath);
    toSmall.toValue = (__bridge id _Nullable)([self circleSmallPath].CGPath);
    toSmall.duration = KAnimationDuration4;
    toSmall.fillMode = kCAFillModeForwards;
    toSmall.removedOnCompletion = NO;
    [self.circleLayer addAnimation:toSmall forKey:@"__toSmall__"];
}

#pragma mark - 5. 方形圈线
- (void)addSquareLine {
    [self.layer addSublayer:self.rectangleLayer];
}

- (void)rectangleAnimate {
    CABasicAnimation *square = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    square.delegate = self;
    square.fromValue = @0;
    square.toValue = @1;
    square.fillMode = kCAFillModeForwards;
    square.removedOnCompletion = NO;
    square.duration = KAnimationDuration5;
    [self.rectangleLayer addAnimation:square forKey:@"__square__"];
}

#pragma mark - 6. 注水动画
- (void)addWaterLayer {
    [self.layer addSublayer:self.waterFlowLayer];
}

- (void)waterFlowAnimate {
    CAKeyframeAnimation *flow = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    flow.delegate = self;
    flow.values = @[
                        (__bridge id _Nullable)([self waterFolowPath:0].CGPath),
                        (__bridge id _Nullable)([self waterFolowPath:1].CGPath),
                        (__bridge id _Nullable)([self waterFolowPath:2].CGPath),
                        (__bridge id _Nullable)([self waterFolowPath:3].CGPath),
                        (__bridge id _Nullable)([self waterFolowPath:4].CGPath),
                        ];
    flow.duration = KAnimationDuration6;
    flow.fillMode = kCAFillModeForwards;
    flow.removedOnCompletion = NO;
    [self.waterFlowLayer addAnimation:flow forKey:@"__flow__"];
}

#pragma mark - 7. 放大并弹出welcome
- (void)addWelcomeLayer {
    [self.layer addSublayer:self.welcomeLayer];
}

- (void)transfromScale {
    CGFloat offsetY = self.layer.position.y - _waterFlowLayer.position.y;
    CATransform3D transform = CATransform3DMakeTranslation(0, offsetY, 0);
    transform = CATransform3DScale(transform, CGRectGetWidth(self.frame)/CGRectGetWidth(self.waterFlowLayer.bounds), CGRectGetHeight(self.frame)/CGRectGetHeight(self.waterFlowLayer.bounds), 1);
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.delegate = self;
    scale.toValue = [NSValue valueWithCATransform3D:transform];
    scale.duration = KAnimationDuration7;
    scale.fillMode = kCAFillModeForwards;
    scale.removedOnCompletion = NO;
    [self.waterFlowLayer addAnimation:scale forKey:@"__transfromScale__"];
}

- (void)textScale {
    CAKeyframeAnimation *scaleText = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleText.delegate = self;
    scaleText.values = @[
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                    ];
    scaleText.keyTimes = @[@0.0, @0.7, @1.0];
    scaleText.duration = KAnimationDuration7;
    scaleText.fillMode = kCAFillModeForwards;
    scaleText.removedOnCompletion = NO;
    [self.welcomeLayer addAnimation:scaleText forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [self.circleLayer animationForKey:@"__expand__"]) {
        [self squishCircle];
    }
    else if (anim == [self.circleLayer animationForKey:@"__squish__"]) {
        [self addTriangleLayer];
        [self triangleAnimate];
    }
    else if (anim == [self.triangleLayer animationForKey:@"__triangle__"]) {
        [self rotate];
    }
    else if (anim == [self.circleLayer animationForKey:@"__toSmall__"]) {
        [self addSquareLine];
        [self rectangleAnimate];
    }
    else if (anim == [self.rectangleLayer animationForKey:@"__square__"]) {
        [self addWaterLayer];
        [self waterFlowAnimate];
    }
    else if (anim == [self.waterFlowLayer animationForKey:@"__flow__"]) {
        [self transfromScale];
    }
    else if (anim == [self.waterFlowLayer animationForKey:@"__transfromScale__"]) {
        [self addWelcomeLayer];
        [self textScale];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.circleLayer removeAllAnimations];
    [self.circleLayer removeFromSuperlayer];
    [self.triangleLayer removeAllAnimations];
    [self.triangleLayer removeFromSuperlayer];
    [self.rectangleLayer removeAllAnimations];
    [self.rectangleLayer removeFromSuperlayer];
    [self.waterFlowLayer removeAllAnimations];
    [self.waterFlowLayer removeFromSuperlayer];
    [self.welcomeLayer removeAllAnimations];
    [self.welcomeLayer removeFromSuperlayer];
    [self run];
}

@end
