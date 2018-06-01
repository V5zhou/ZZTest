//
//  UIImage+QRcode.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/25.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "UIImage+QRcode.h"

@implementation UIImage (QRcode)

/**
 条形码
 */
+ (UIImage *)barCodeWithInfo:(NSString *)info {
    if (!info) {
        return nil;
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    // 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    //取出图片
    return zz_OutImageFromFilter(filter);
}

/**
 二维码
 */
+ (UIImage *)QRCodeWithInfo:(NSString *)info width:(CGFloat)width {
    if (!info) {
        return nil;
    }
    NSData *strData = [info dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    //创建二维码滤镜
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:strData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *qrImage = qrFilter.outputImage;
    //颜色滤镜
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorFilter setValue:qrImage forKey:kCIInputImageKey];
    [colorFilter setValue:[CIColor colorWithRed:0.1 green:0.2 blue:0.4] forKey:@"inputColor0"];
    [colorFilter setValue:[CIColor colorWithRed:1 green:1 blue:1] forKey:@"inputColor1"];
    //返回二维码
    return zz_OutImageFromFilter(colorFilter);
}

@end

@implementation CIImage (zz_filter)

/**
 滤镜效果
 intensity 强度
 */
- (BOOL)filterWithName:(NSString *)name intensity:(CGFloat)intensity result:(void(^)(UIImage * image))result {
    NSSet *filterNames = [NSSet setWithArray:[CIFilter filterNamesInCategory:kCICategoryBuiltIn]];
    if (!name || name.length < 1 || ![filterNames member:name]) {
        NSLog(@"不支持的滤镜类型"); return nil;
    }
    CIFilter *filter = [CIFilter filterWithName:name];
    [filter setValue:self forKey:kCIInputImageKey];
    [filter setValue:@(intensity) forKey:kCIInputIntensityKey];

    UIImage *image = zz_OutImageFromFilter(filter);
    if (image) {
        if (result) result(image);
        return YES;
    }
    else {
        return NO;
    }
    return NO;
}

@end

/**
 打印支持的滤镜/参数
 */
void zz_PrintSupportFilterName_attributes(void) {
    NSArray *filterNames = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    for (NSString *filterName in filterNames) {
        CIFilter *filter = [CIFilter filterWithName:filterName];
        NSLog(@"滤镜%@->%@", filterName, filter.attributes);
    }
}

/**
 把图片从滤镜中取出
 */
UIImage *zz_OutImageFromFilter(CIFilter *filter) {
    CIImage *cImage = filter.outputImage;
    static CIContext *zz_ctx_CI;
    if (!zz_ctx_CI) {
        zz_ctx_CI = [CIContext contextWithOptions:nil];
    }
    CGImageRef imageRef = [zz_ctx_CI createCGImage:cImage fromRect:cImage.extent];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return image;
}
