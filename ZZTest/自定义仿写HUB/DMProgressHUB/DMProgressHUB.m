//
//  DMProgressHUB.m
//  DMZT_V2
//
//  Created by 多米智投 on 2018/4/23.
//  Copyright © 2018年 lihuihan. All rights reserved.
//

#import "DMProgressHUB.h"
#import "DMRadiaView.h"
#import "DMProgressAnimateImage.h"

typedef NS_ENUM(NSUInteger, DMProgressHUBShowType) {    //当前显示类型：D表示Delay
    DMProgressHUBShowType_None = 0,
    //提示语
    DMProgressHUBShowType_Message,
    DMProgressHUBShowType_Message_D,
    //转圈圈
    DMProgressHUBShowType_Activity,
    DMProgressHUBShowType_Activity_Message,
    //自定义图片
    DMProgressHUBShowType_Image_Message,
    DMProgressHUBShowType_Image_Message_D,
    //成功/失败/警告
    DMProgressHUBShowType_AnimateSuccess_Message_D,
    DMProgressHUBShowType_AnimateFail_Message_D,
    DMProgressHUBShowType_AnimateInfo_Message_D,
};

#define DMProgressHUB_superView ([[UIApplication sharedApplication].delegate window])
#define DMProgressHUB_screen_width ([UIScreen mainScreen].bounds.size.width)
#define DMProgressHUB_screen_height ([UIScreen mainScreen].bounds.size.height)
@interface DMProgressHUB () {
#pragma mark - 内部变量
    NSInteger activityCount;            //activity计数
    NSTimer *timer;                     //timer
    
    DMRadiaView *radiaView;             //转圈圈组件
    UIImageView *imageView;             //图片
    UILabel *infoLabel;                 //info
    UIActivityIndicatorView *activity;  //activity
    DMProgressAnimateImage *resultView; //成功/失败/警告
}

//
@property (nonatomic, assign) DMProgressHUBShowType curShowType;  //当前显示类型

//背景
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) UIEdgeInsets backInsets;
@property (nonatomic, assign) CGFloat minEdgeSpace;   //距边距离

//info
@property (nonatomic, strong) UIFont *infoFont;
@property (nonatomic, strong) UIColor *infoColor;
@property (nonatomic, assign) CGFloat infoTop;

//activity
@property (nonatomic, assign) DMProgressHUBStyle activityStyle;
@property (nonatomic, assign) CGFloat activityWidth;
@property (nonatomic, assign) CGFloat activityStrokeWidth;
@property (nonatomic, strong) UIColor *activityColor;
@property (nonatomic, assign) NSUInteger activityDashNum;

//image
@property (nonatomic, assign) CGFloat imageWidth;

//delay
@property (nonatomic, assign) NSTimeInterval delay;

@end

@implementation DMProgressHUB

+ (instancetype)shareInstance {
    static DMProgressHUB *hub = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hub = [[DMProgressHUB alloc] init];
        [hub setDefaultSetting];
    });
    return hub;
}

- (void)setDefaultSetting {
    self.backColor = [UIColor colorWithRed:41/255.0 green:43/255.0 blue:63/255.0 alpha:0.9];
    self.backInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.infoFont = [UIFont systemFontOfSize:12];
    self.infoColor = [UIColor brownColor];
    self.infoTop = 8;
    self.minEdgeSpace = 15;
    self.activityWidth = 40;
    self.activityColor = [UIColor brownColor];
    self.activityStyle = DMProgressHUBStyle_Flat;
    self.activityStrokeWidth = 4;
    self.activityDashNum = 3;
    self.imageWidth = 50;
    self.delay = 1;
    self.userInteractionEnabled = NO;
    self.backgroundColor = _backColor;
    self.layer.cornerRadius = 3;
}

#pragma mark - 公开方法
#pragma mark - activity
//转圈圈
+ (void)showActivity {
    [DMProgressHUB shareInstance].curShowType = DMProgressHUBShowType_Activity;
    [[DMProgressHUB shareInstance] showWithimage:nil message:nil];
}
+ (void)showActivity:(NSString *)message {
    [DMProgressHUB shareInstance].curShowType = DMProgressHUBShowType_Activity_Message;
    [[DMProgressHUB shareInstance] showWithimage:nil message:message];
}
//count--
+ (void)popActivity {
    [DMProgressHUB shareInstance]->activityCount--;
    if ([DMProgressHUB shareInstance]->activityCount <= 0) {
        [[DMProgressHUB shareInstance] animateHidden];
    }
}
//消失
+ (void)dismiss {
    [DMProgressHUB shareInstance]->activityCount = 0;
    [[DMProgressHUB shareInstance] animateHidden];
}
//延迟消失
+ (void)dismissWithDelay:(NSTimeInterval)delay {
    if ([DMProgressHUB shareInstance]->timer) {
        [[DMProgressHUB shareInstance]->timer invalidate];
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [DMProgressHUB shareInstance]->timer = timer;
}

#pragma mark - Message
//提示信息
+ (void)showMessage:(NSString *)message {
    [DMProgressHUB shareInstance].curShowType = DMProgressHUBShowType_Message;
    [[DMProgressHUB shareInstance] showWithimage:nil message:message];
}
//延迟消失提示信息
+ (void)showAutoHideMessage:(NSString *)message {
    [DMProgressHUB shareInstance].curShowType = DMProgressHUBShowType_Message_D;
    [[DMProgressHUB shareInstance] showWithimage:nil message:message];
    [self dismissWithDelay:[DMProgressHUB delayForText:message]];
}
//提示信息+图片
+ (void)showMessage:(NSString *)message image:(UIImage *)image {
    [DMProgressHUB shareInstance].curShowType = DMProgressHUBShowType_Image_Message;
    [[DMProgressHUB shareInstance] showWithimage:image message:message];
}
//延迟消失提示信息+图片
+ (void)showAutoHideMessage:(NSString *)message image:(UIImage *)image {
    [DMProgressHUB shareInstance].curShowType = DMProgressHUBShowType_Image_Message_D;
    [[DMProgressHUB shareInstance] showWithimage:image message:message];
    [self dismissWithDelay:[DMProgressHUB delayForText:message]];
}

#pragma mark - 成功/失败/警告
+ (void)showSuccess:(NSString *)success {
    [DMProgressHUB shareInstance].curShowType = DMProgressHUBShowType_AnimateSuccess_Message_D;
    [[DMProgressHUB shareInstance] showWithimage:nil message:success];
    [self dismissWithDelay:[DMProgressHUB delayForText:success]];
}
+ (void)showError:(NSString *)error {
    [DMProgressHUB shareInstance].curShowType = DMProgressHUBShowType_AnimateFail_Message_D;
    [[DMProgressHUB shareInstance] showWithimage:nil message:error];
    [self dismissWithDelay:[DMProgressHUB delayForText:error]];
}
+ (void)showTips:(NSString *)tips {
    [DMProgressHUB shareInstance].curShowType = DMProgressHUBShowType_AnimateInfo_Message_D;
    [[DMProgressHUB shareInstance] showWithimage:nil message:tips];
    [self dismissWithDelay:[DMProgressHUB delayForText:tips]];
}

#pragma mark - 创建与显示逻辑
//生成view
- (void)showWithimage:(UIImage *)image
              message:(NSString *)message {
    //clear
    [self clear];
    [DMProgressHUB_superView addSubview:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        //创建
        CGSize imageSize = CGSizeZero;
        CGSize infoSize = CGSizeZero;
        CGSize limitSize = CGSizeMake(DMProgressHUB_screen_width - _minEdgeSpace*2, DMProgressHUB_screen_height - _minEdgeSpace*2 - _imageWidth - _infoTop);
        switch (self.curShowType) {
            case DMProgressHUBShowType_None:
                break;
            case DMProgressHUBShowType_Message:
            case DMProgressHUBShowType_Message_D:{
                infoSize = [self sizeForText:message font:_infoFont limitSize:limitSize];
                [self showInfoLabel:message];
            }
                break;
            case DMProgressHUBShowType_Activity:{
                imageSize = CGSizeMake(_activityWidth, _activityWidth);
                [self showRadiaView];
            }
                break;
            case DMProgressHUBShowType_Activity_Message:{
                imageSize = CGSizeMake(_activityWidth, _activityWidth);
                [self showRadiaView];
                infoSize = [self sizeForText:message font:_infoFont limitSize:limitSize];
                [self showInfoLabel:message];
            }
                break;
            case DMProgressHUBShowType_Image_Message:
            case DMProgressHUBShowType_Image_Message_D:{
                infoSize = [self sizeForText:message font:_infoFont limitSize:limitSize];
                imageSize = CGSizeMake(_imageWidth, _imageWidth);
                [self showImageView:image];
                [self showInfoLabel:message];
            }
                break;
            case DMProgressHUBShowType_AnimateSuccess_Message_D:
            case DMProgressHUBShowType_AnimateFail_Message_D:
            case DMProgressHUBShowType_AnimateInfo_Message_D:{
                infoSize = [self sizeForText:message font:_infoFont limitSize:limitSize];
                imageSize = CGSizeMake(_activityWidth, _activityWidth);
                [self showResultView];
                [self showInfoLabel:message];
            }
                break;
        }
        
        //刷新布局
        [self refreshFrameWithImageSize:imageSize messageSize:infoSize];
        //动态显示
        [self animateShow];
    });
}

//刷新布局
- (void)refreshFrameWithImageSize:(CGSize)imageSize
                      messageSize:(CGSize)messageSize {
    
    //space
    CGFloat image_message_space = 0;
    if (messageSize.height > 0 && imageSize.height > 0) {
        image_message_space = _infoTop;
    }
    //总视图大小
    CGFloat self_W = MAX(messageSize.width, imageSize.width) + _backInsets.left + _backInsets.right;
    CGFloat self_H = messageSize.height + imageSize.height;
    self_H += (_backInsets.top + _backInsets.bottom + image_message_space);
    self.bounds = CGRectMake(0, 0, self_W, self_H);
    self.center = DMProgressHUB_superView.center;
    //activity
    if (self->activity.superview) {
        self->activity.center = CGPointMake(self_W/2, _backInsets.top + _activityWidth/2);
    }
    //radia
    if (self->radiaView.superview) {
        self->radiaView.center = CGPointMake(self_W/2, _backInsets.top + _activityWidth/2);
    }
    //resultView
    if (self->resultView.superview) {
        self->resultView.bounds = CGRectMake(0, 0, _activityWidth, _activityWidth);
        self->resultView.center = CGPointMake(self_W/2, _backInsets.top + _activityWidth/2);
    }
    //image
    if (self->imageView.superview) {
        self->imageView.bounds = CGRectMake(0, 0, _imageWidth, _imageWidth);
        self->imageView.center = CGPointMake(self_W/2, _backInsets.top + _imageWidth/2);
    }
    //message
    if (self->infoLabel.superview) {
        self->infoLabel.frame = CGRectMake(_backInsets.left, imageSize.height + (imageSize.height > 0 ? _infoTop : 0) + _backInsets.top, messageSize.width, messageSize.height);
    }
}

//计算文本宽高
- (CGSize)sizeForText:(NSString *)text font:(UIFont *)font limitSize:(CGSize)limitSize {
    if (!text || text.length < 1) {
        return CGSizeZero;
    }
    NSAttributedString *atttribute = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : font}];
    CGSize size = [atttribute boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin context:NULL].size;
    return size;
}

//页面停留时间
+ (NSTimeInterval)delayForText:(NSString *)text {
    return [DMProgressHUB shareInstance].delay + text.length/20.0 * 1;    //1s读20个字
}

#pragma mark - 控件创建
- (void)showRadiaView {
    if (!self->radiaView) {
        self->radiaView = [[DMRadiaView alloc] init];
    }
    self->radiaView.radiaW = _activityWidth/2;
    self->radiaView.strokeWidth = _activityStrokeWidth;
    self->radiaView.strokeColor = _activityColor;
    self->radiaView.dashNum = _activityDashNum;
    [self->radiaView reloadRadiaView];
    
    [self addSubview:self->radiaView];
    [self->radiaView run];
}

- (void)showActivity {
    if (!self->activity) {
        self->activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    self->activity.color = _activityColor;
    [self addSubview:self->activity];
    [self->activity startAnimating];
}

- (void)showImageView:(UIImage *)image {
    if (!self->imageView) {
        self->imageView = [[UIImageView alloc] init];
    }
    self->imageView.image = image;
    [self addSubview:self->imageView];
}

- (void)showInfoLabel:(NSString *)message {
    if (!self->infoLabel) {
        self->infoLabel = [[UILabel alloc] init];
        self->infoLabel.textAlignment = NSTextAlignmentCenter;
        self->infoLabel.numberOfLines = 0;
    }
    self->infoLabel.font = _infoFont;
    self->infoLabel.textColor = _infoColor;
    self->infoLabel.text = message;
    [self addSubview:self->infoLabel];
}

- (void)showResultView {
    if (!self->resultView) {
        self->resultView = [[DMProgressAnimateImage alloc] init];
    }
    self->resultView.radiaW = _activityWidth/2;
    self->resultView.strokeWidth = _activityStrokeWidth;
    self->resultView.strokeColor = _activityColor;
    switch (self.curShowType) {
        case DMProgressHUBShowType_AnimateSuccess_Message_D:
            [self->resultView showSuccess];
            break;
        case DMProgressHUBShowType_AnimateFail_Message_D:
            [self->resultView showError];
            break;
        case DMProgressHUBShowType_AnimateInfo_Message_D:
            [self->resultView showTips];
            break;
        default:
            break;
    }
    [self addSubview:self->resultView];
}

#pragma mark - show/hidden/clear
- (void)animateShow {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        //usingSpringWithDamping的范围为0.0f到1.0f，数值越小「弹簧」的振动效果越明显
        //initialSpringVelocity则表示初始的速度，数值越大一开始移动越快。
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    });
}

- (void)animateHidden {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.20 animations:^{
            self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            [self clear];
        }];
    });
}

- (void)clear {
    [self->radiaView stop];
    [self->radiaView removeFromSuperview];
    [self->resultView removeFromSuperview];
    [self->imageView removeFromSuperview];
    [self->infoLabel removeFromSuperview];
    [self->activity stopAnimating];
    [self->activity removeFromSuperview];
    [self->timer invalidate];
    self->timer = nil;
    [self removeFromSuperview];
}

#pragma mark - setter/getter
- (void)setCurShowType:(DMProgressHUBShowType)curShowType {
    if (curShowType == DMProgressHUBShowType_Activity ||
        curShowType == DMProgressHUBShowType_Activity_Message) {
        if (curShowType != _curShowType)
            self->activityCount = 0;    //类型切换，重新计0
        self->activityCount++;
    }
    else {
        self->activityCount = 0;
    }
    _curShowType = curShowType;
}

#pragma mark - 外界设置
+ (void)setBackgroundColor:(UIColor *)backColor {
    [DMProgressHUB shareInstance].backColor = backColor;
    [DMProgressHUB shareInstance].backgroundColor = backColor;
}

+ (void)setBackInsets:(UIEdgeInsets)backInsets {
    [DMProgressHUB shareInstance].backInsets = backInsets;
}

+ (void)setInfoFont:(UIFont *)infoFont {
    [DMProgressHUB shareInstance].infoFont = infoFont;
}

+ (void)setInfoColor:(UIColor *)infoColor {
    [DMProgressHUB shareInstance].infoColor = infoColor;
}

+ (void)setInfoTop:(CGFloat)infoTop {
    [DMProgressHUB shareInstance].infoTop = infoTop;
}

+ (void)setActivityWidth:(CGFloat)activityWidth {
    [DMProgressHUB shareInstance].activityWidth = activityWidth;
}

+ (void)setActivityStrokeWidth:(NSInteger)activityStrokeWidth {
    [DMProgressHUB shareInstance].activityStrokeWidth = activityStrokeWidth;
}

+ (void)setActivityColor:(UIColor *)activityColor {
    [DMProgressHUB shareInstance].activityColor = activityColor;
}

+ (void)setActivityStyle:(DMProgressHUBStyle)activityStyle {
    [DMProgressHUB shareInstance].activityStyle = activityStyle;
}

+ (void)setActivityDashNum:(NSUInteger)activityDashNum {
    [DMProgressHUB shareInstance].activityDashNum = activityDashNum;
}

+ (void)setImageWidth:(CGFloat)imageWidth {
    [DMProgressHUB shareInstance].imageWidth = imageWidth;
}

+ (void)setDelay:(NSTimeInterval)delay {
    [DMProgressHUB shareInstance].delay = delay;
}

@end
