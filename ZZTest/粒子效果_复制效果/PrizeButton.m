//
//  PrizeButton.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/22.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "PrizeButton.h"

@interface PrizeButton ()

@property (nonatomic, strong) CAEmitterLayer *bomb;
@property (nonatomic, assign) BOOL animating;

@end

@implementation PrizeButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"praise_select"] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"praise_default"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(__prizeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)__prizeButtonClick {
    self.selected = !self.selected;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        if (_animating) {
            return;
        }
        _animating = YES;
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
        
        //bomb
        self.bomb.beginTime = CACurrentMediaTime();
        [self.bomb setValue:@500 forKeyPath:@"emitterCells.explosion.birthRate"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.bomb setValue:@0 forKeyPath:@"emitterCells.explosion.birthRate"];
            _animating = NO;
        });
    }
}

- (CAEmitterLayer *)bomb {
    if (!_bomb) {
        CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
        emitterCell.name = @"explosion";
        emitterCell.alphaRange = 0.2;
        emitterCell.alphaSpeed = -1.0;
        emitterCell.lifetime = 0.7;
        emitterCell.lifetimeRange = 0.2;
        emitterCell.birthRate = 0;
        emitterCell.velocity = 40;
        emitterCell.velocityRange = 10.0;
        emitterCell.scale = 0.05;
        emitterCell.scaleRange = 0.02;
        emitterCell.contents = (id)[UIImage imageNamed:@"sparkle"].CGImage;

        CAEmitterLayer *layer = [CAEmitterLayer layer];
        layer.emitterShape = kCAEmitterLayerCircle;
        layer.emitterMode = kCAEmitterLayerOutline;
        layer.emitterPosition = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        layer.emitterSize = CGSizeMake(25, 0);
        layer.renderMode = kCAEmitterLayerOldestFirst;
        layer.emitterCells = @[emitterCell];
        [self.layer addSublayer:layer];
        _bomb = layer;
    }
    return _bomb;
}

@end
