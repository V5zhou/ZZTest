//
//  CoreGraphicsGradientView.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/23.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "CoreGraphicsGradientView.h"

@implementation CoreGraphicsGradientView

- (void)drawRect:(CGRect)rect {
    CGFloat radius = self.frame.size.width/2;
    //
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, radius, radius, radius, M_PI_4, M_PI_4*5, NO);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGPathRelease(path);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *colors = @[(__bridge id)[UIColor redColor].CGColor,
                        (__bridge id)[UIColor yellowColor].CGColor,
                        (__bridge id)[UIColor blueColor].CGColor];
    CGFloat locations[] = {0.2, 0.5, 0.8};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    CGContextSaveGState(context);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(radius*2, radius*2), kCGGradientDrawsBeforeStartLocation);
    CGContextDrawRadialGradient(context, gradient, CGPointMake(radius/1.2, radius/0.8), 0, CGPointMake(radius/1.2, radius/0.8), radius/4, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
