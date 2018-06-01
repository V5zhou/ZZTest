//
//  CGShading_Radial.m
//  Test
//
//  Created by 多米智投 on 2018/5/11.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "CGShading_Radial.h"

@implementation CGShading_Radial

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    myPaintRadialShading(context, self.bounds);
}

static void  myCalculateShadingValues(void *info, const CGFloat *in, CGFloat *out) {
    size_t k, components;
    double frequency[4] = {55, 220, 110, 0};
    components = (size_t)info;
    for(k = 0; k < components - 1; k++)
        *out++ = (1 + sin(*in * frequency[k])) / 2;
    *out = 1;
}

static CGFunctionRef myGetFunction(CGColorSpaceRef colorspace) {
    static const CGFloat input_value_range[2] = {0, 1};
    static const CGFloat output_value_ranges[8] = {0, 1, 0, 1, 0, 1, 0, 1};
    static const CGFunctionCallbacks callbacks = {0, &myCalculateShadingValues, NULL};
    size_t numComponents = 1 + CGColorSpaceGetNumberOfComponents(colorspace);
    return CGFunctionCreate((void *)numComponents,
                            1, input_value_range,
                            numComponents, output_value_ranges,
                            &callbacks);
}

void myPaintRadialShading(CGContextRef myContext, CGRect bounds) {
    CGPoint startPoint,
    endPoint;
    CGFloat startRadius,
    endRadius;
    CGAffineTransform myTransform;
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    
    startPoint = CGPointMake(0.25,0.3);
    startRadius = .1;
    endPoint = CGPointMake(.7,0.7);
    endRadius = .25;
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFunctionRef myShadingFunction = myGetFunction(colorspace);
    
    CGShadingRef shading = CGShadingCreateRadial(colorspace,
                                                 startPoint, startRadius,
                                                 endPoint, endRadius,
                                                 myShadingFunction,
                                                 false, false);
    
    myTransform = CGAffineTransformMakeScale(width, height);
    CGContextConcatCTM(myContext, myTransform);
    CGContextSaveGState(myContext);
    
    CGContextClipToRect(myContext, CGRectMake(0, 0, 1, 1));
    CGContextSetRGBFillColor(myContext, 1, 1, 1, 1);
    CGContextFillRect(myContext, CGRectMake(0, 0, 1, 1));
    
    CGContextDrawShading(myContext, shading);
    CGColorSpaceRelease(colorspace);
    CGShadingRelease(shading);
    CGFunctionRelease(myShadingFunction);
    
    CGContextRestoreGState(myContext);
}

@end
