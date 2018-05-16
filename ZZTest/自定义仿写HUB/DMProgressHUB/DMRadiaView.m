//
//  DMRadiaView.m
//  DMZT_V2
//
//  Created by 多米智投 on 2018/4/23.
//  Copyright © 2018年 lihuihan. All rights reserved.
//

#import "DMRadiaView.h"

@interface DMRadiaView ()

@property (nonatomic, strong) NSString *savePath;
@property (nonatomic, strong) NSString *fileName;

@end

@implementation DMRadiaView

- (void)run {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = @0;
    animation.fromValue = @(M_PI*2);
    animation.duration = 1.2;
    animation.repeatCount = HUGE_VAL;
    animation.autoreverses = NO;
    [self.layer addAnimation:animation forKey:@"rotation-z"];
}

- (void)stop {
    [self.layer removeAnimationForKey:@"rotation-z"];
}

//刷新
- (void)reloadRadiaView {
    self.frame = CGRectMake(0, 0, _radiaW*2, _radiaW*2);
    __weak typeof(self) weakSelf = self;
    [self asynRadiaImage:^(UIImage *image) {
        weakSelf.layer.contents = (id)image.CGImage;
    }];
}

//生成图形：有图就取出，无就生成
- (void)asynRadiaImage:(void(^)(UIImage *image))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //mask
        UIImage *image = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.savePath]) {
            image = [[UIImage alloc] initWithContentsOfFile:self.savePath];
        }
        else {
            image = [self circleImage];
            //保存到指定路径
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData *data = UIImagePNGRepresentation(image);
                [data writeToFile:self.savePath atomically:YES];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(image);
            }
        });
    });
}

//生成图形
//- (UIImage *)circleImage {
//    CGFloat W = _radiaW*2;
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(W, W), NO, [[UIScreen mainScreen] scale]);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    //mask
//    UIImage *maskImage = [UIImage imageNamed:@"angle-mask"];
//    CGContextClipToMask(context, CGRectMake(0, 0, W, W), maskImage.CGImage);
//
//    //画圆
//    CGFloat eachLength = 2.0 * M_PI * (W/2 - _strokeWidth/2.0) / (2*_dashNum);
//    CGFloat lengths[] = {eachLength,eachLength};
//    CGContextSetLineDash(context, 0, lengths, 2);
//    CGContextSetStrokeColorWithColor(context, _strokeColor.CGColor);
//    CGContextSetLineWidth(context, _strokeWidth);
//    CGContextAddArc(context, W/2, W/2, W/2 - _strokeWidth/2.0, M_PI_2, M_PI_2*5, NO);
//    CGContextStrokePath(context);
//
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return image;
//}

- (UIImage *)circleImage {
    CGFloat W = _radiaW*2;
    CGFloat strokeW = _strokeWidth;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(W, W), NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, strokeW);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSInteger count = 1000;
    for (NSInteger i = 0; i < count; i++) {
        CGContextSaveGState(context);
        CGContextAddArc(context, W/2, W/2, W/2 - strokeW/2, M_PI*2*i/count, M_PI*2*(i+1)/count, NO);
        CGContextSetStrokeColorWithColor(context, CGColorCreateCopyWithAlpha(_strokeColor.CGColor, ((CGFloat)i)/count));
        CGContextDrawPath(context, kCGPathStroke);
        CGContextRestoreGState(context);
    }
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - setter_getter
- (NSString *)savePath {
    if (!_savePath) {
        _savePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _savePath = [_savePath stringByAppendingPathComponent:@"DMRadiaView"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_savePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_savePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _savePath = [_savePath stringByAppendingPathComponent:self.fileName];
        _savePath = [_savePath stringByAppendingString:@".png"];
    }
    return _savePath;
}

- (NSString *)fileName {
    if (!_fileName) {
        _fileName = [NSString stringWithFormat:@"%ld-%@-%.1lf-%.1lf", _dashNum, hexFromUIColor(_strokeColor), _strokeWidth, _radiaW];
    }
    return _fileName;
}

static NSString *hexFromUIColor(UIColor *color) {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%.2X%.2X%.2X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

@end
