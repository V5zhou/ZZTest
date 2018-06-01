//
//  FilterViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/25.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "FilterViewController.h"
#import "UIImage+QRcode.h"

@interface FilterViewController ()

@property (nonatomic, strong) CIImage *cImage;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    NSArray<UIView *> *shows = self.view.subviews;
    for (UIView *view in shows) {
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view.layer.contentsGravity = kCAGravityResizeAspect;
    }
    //条型码
    shows[0].layer.contents = (id)[UIImage barCodeWithInfo:@"4567888999"].CGImage;
    //二维码
    shows[1].layer.contents = (id)[UIImage QRCodeWithInfo:@"我是条形码888999" width:380].CGImage;
    //打印支持的滤镜
    zz_PrintSupportFilterName_attributes();
    //添加滤镜
    self.cImage = [CIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"fbb.jpeg"], 0.5)];
    [self.cImage filterWithName:@"CISepiaTone" intensity:((UISlider *)shows[6]).value result:^(UIImage *image) {
        ((UIImageView *)shows[2]).image = image;
    }];
}

- (IBAction)sliderChanged:(UISlider *)sender {
    NSArray<UIView *> *shows = self.view.subviews;
    [self.cImage filterWithName:@"CISepiaTone" intensity:sender.value result:^(UIImage *image) {
        ((UIImageView *)shows[2]).image = image;
    }];
}

- (void)dealloc {
    
}

@end

/*  在iOS 中使用滤镜效果，需要用到的重要类有三个：
 *  CIContext. 图片的所有处理工作都是在 CIContext中做的. 它有点类似于 Core Graphics 和 OpenGL context.
 *  CIImage. 这个类持有图片数据。可以用UIImage或者图片路径或者data来创建一个CIImage对象。
 *  CIFilter.滤镜类，它有一个用来设置各种参数的字典，API已经提供了setValue: forKey:方法来设置参数。
 *
 *  滤镜使用过程：1.创建一个CIImage对象->2.创建一个CIContext->3.创建一个滤镜->4.获取filter output
 *
 *  ...CIContext 可能是基于CPU，也可能是基于GPU的。所以创建CIContext会消耗资源，影响性能，我们应该尽可能多的复用它。
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 */
