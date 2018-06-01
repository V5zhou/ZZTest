//
//  UIImage+QRcode.h
//  ZZTest
//
//  Created by 多米智投 on 2018/5/25.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QRcode)

/**
 条形码
 */
+ (UIImage *)barCodeWithInfo:(NSString *)info;

/**
 二维码
 */
+ (UIImage *)QRCodeWithInfo:(NSString *)info width:(CGFloat)width;

@end

@interface CIImage (zz_filter)

/**
 滤镜效果
 intensity 强度
 */
- (BOOL)filterWithName:(NSString *)name intensity:(CGFloat)intensity result:(void(^)(UIImage * image))result;

@end

/**
 打印支持的滤镜/参数
 */
void zz_PrintSupportFilterName_attributes(void);

/**
 把图片从滤镜中取出
 */
UIImage *zz_OutImageFromFilter(CIFilter *filter);
