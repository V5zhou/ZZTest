//
//  EmitterViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/21.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "EmitterViewController.h"
#import "SnowEmitterLayer.h"
#import "ReplicatorLayer.h"
#import "PrizeButton.h"

@interface EmitterViewController ()

@property (nonatomic, strong) CAEmitterLayer *explosionLayer;

@end

@implementation EmitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    SnowEmitterLayer *layer1 = [SnowEmitterLayer createWithType:SnowEmitterType_snow];
    layer1.frame = CGRectMake(20, 20, 180, 180);
    [self.view.layer addSublayer:layer1];
    
    SnowEmitterLayer *layer2 = [SnowEmitterLayer createWithType:SnowEmitterType_spray];
    layer2.frame = CGRectMake(220, 20, 180, 180);
    [self.view.layer addSublayer:layer2];
    
    SnowEmitterLayer *layer3 = [SnowEmitterLayer createWithType:SnowEmitterType_bomb];
    layer3.frame = CGRectMake(20, 220, 180, 180);
    [self.view.layer addSublayer:layer3];
    
    ReplicatorLayer *layer4 = [ReplicatorLayer createWithType:ReplicatorLayerType_flip];
    layer4.frame = CGRectMake(220, 220, 180, 180);
    [self.view.layer addSublayer:layer4];
    [layer4 startAnimation];
    
    ReplicatorLayer *layer5 = [ReplicatorLayer createWithType:ReplicatorLayerType_ripple];
    layer5.frame = CGRectMake(20, 420, 180, 180);
    [self.view.layer addSublayer:layer5];
    [layer5 startAnimation];
    
    ReplicatorLayer *layer6 = [ReplicatorLayer createWithType:ReplicatorLayerType_array];
    layer6.frame = CGRectMake(220, 420, 180, 180);
    [self.view.layer addSublayer:layer6];
    [layer6 startAnimation];
    
    PrizeButton *prize = [PrizeButton buttonWithType:UIButtonTypeCustom];
    prize.bounds = CGRectMake(0, 0, 30, 30);
    prize.center = CGPointMake(210, 210);
    [self.view addSubview:prize];
}

@end
