//
//  CGShading_Axial.m
//  Test
//
//  Created by 多米智投 on 2018/5/11.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "CGShading_Axial.h"

@implementation CGShading_Axial

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    myPaintAxialShading(context, self.bounds);
}

static void myCalculateShadingValues(void *info, const CGFloat *in, CGFloat *out) {
    CGFloat v;
    size_t k, components;
    static const CGFloat c[] = {1, 0, .5, 0};
    components = (size_t)info;
    v = *in;
    for(k = 0; k < components -1; k++)
        *out++ = c[k] * v;
    *out = 1;
}

static CGFunctionRef myGetFunction (CGColorSpaceRef colorspace) {
    static const CGFloat input_value_range[2] = {0, 1};
    static const CGFloat output_value_ranges[8] = {0, 1, 0, 1, 0, 1, 0, 1};
    static const CGFunctionCallbacks callbacks = {0, &myCalculateShadingValues, NULL};
    size_t  numComponents = 1 + CGColorSpaceGetNumberOfComponents (colorspace);
    return CGFunctionCreate((void *)numComponents,
                            1, input_value_range,
                            numComponents, output_value_ranges,
                            &callbacks);
}

void myPaintAxialShading(CGContextRef myContext, CGRect bounds) {
    CGPoint startPoint, endPoint;
    CGAffineTransform myTransform;
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    
    startPoint = CGPointMake(0,0.5);
    endPoint = CGPointMake(1,0.5);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFunctionRef myShadingFunction = myGetFunction(colorspace);
    
    CGShadingRef shading = CGShadingCreateAxial(colorspace,
                                                startPoint, endPoint,
                                                myShadingFunction,
                                                false, false);
    
    myTransform = CGAffineTransformMakeScale(width, height);
    CGContextConcatCTM(myContext, myTransform);
    CGContextSaveGState(myContext);
    
    CGContextClipToRect(myContext, CGRectMake(0, 0, 1, 1));
    CGContextSetRGBFillColor(myContext, 1, 1, 1, 1);
    CGContextFillRect(myContext, CGRectMake(0, 0, 1, 1));
    
    CGContextBeginPath(myContext);
    CGContextAddArc(myContext, .5, .5, .3, 0, M_PI, 0);
    CGContextClosePath(myContext);
    CGContextClip(myContext);
    
    CGContextDrawShading(myContext, shading);
    CGColorSpaceRelease(colorspace);
    CGShadingRelease(shading);
    CGFunctionRelease(myShadingFunction);
    
    CGContextRestoreGState(myContext);
}


@end
