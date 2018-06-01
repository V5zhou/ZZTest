//
//  TransparencyView.m
//  Test
//
//  Created by 多米智投 on 2018/5/11.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "TransparencyView.h"

@implementation TransparencyView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(context, CGSizeMake(-10, -10), 4, [UIColor purpleColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, self.bounds);
    
    CGContextBeginTransparencyLayer(context, NULL);
    
    CGFloat wd = CGRectGetWidth(self.frame);
    CGFloat ht = CGRectGetHeight(self.frame);
    CGContextSetRGBFillColor(context, 0, 1, 0, 1);
    CGContextFillRect(context, CGRectMake (wd/6, ht/3, wd/2, ht/2));
    CGContextSetRGBFillColor(context, 0, 0, 1, 1);
    CGContextFillRect(context, CGRectMake (wd/2, ht/12, wd/2, ht/2));
    CGContextSetRGBFillColor(context, 1, 0, 0, 1);
    CGContextFillRect(context, CGRectMake (wd/2 - wd/12, ht/2, wd/2, ht/2));
    
    CGContextEndTransparencyLayer(context);
}

@end
