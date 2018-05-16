//
//  HUBViewController.m
//  Test
//
//  Created by 多米智投 on 2018/4/24.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "HUBViewController.h"
#import "DMProgressHUB.h"

@interface HUBViewController ()

@end

@implementation HUBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor whiteColor];
    [DMProgressHUB setActivityDashNum:3];
    [DMProgressHUB setActivityColor:[UIColor brownColor]];
}
- (IBAction)showInfo:(id)sender {
    [DMProgressHUB showMessage:@"加载中。。。"];
}
- (IBAction)showAutoInfo:(id)sender {
    [DMProgressHUB showAutoHideMessage:@"我会自动消失"];
}
- (IBAction)showImageInfo:(id)sender {
    [DMProgressHUB showMessage:@"这是一张会换行的\npghjknsadpghjknsadpghjknsadpg\nhjknsadpghjknsadpghjknsadpghjk" image:[UIImage imageNamed:@"2.jpg"]];
}
- (IBAction)showAutoImageInfo:(id)sender {
    [DMProgressHUB showAutoHideMessage:@"一张图片,会自动消失" image:[UIImage imageNamed:@"2.jpg"]];
}
- (IBAction)showInfoActivity:(id)sender {
    [DMProgressHUB showActivity:@"加载中。。。"];
}
- (IBAction)showActivity:(id)sender {
    [DMProgressHUB showActivity];
}
- (IBAction)showAnimateSuccess:(id)sender {
    [DMProgressHUB showSuccess:@"登录成功！"];
}
- (IBAction)showAnimateFail:(id)sender {
    [DMProgressHUB showError:@"验证失败！"];
}
- (IBAction)showAnimateInfo:(id)sender {
    [DMProgressHUB showTips:@"暂无更多信息！"];
}
- (IBAction)close:(id)sender {
    [DMProgressHUB popActivity];
}
- (IBAction)dismiss:(id)sender {
    [DMProgressHUB dismiss];
}

@end
