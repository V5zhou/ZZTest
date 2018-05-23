//
//  CollectionViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/22.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionDetailViewController.h"
#import "zz_AnimatedTransitioning.h"
#import "zz_PopInteractiveTransition.h"

@interface CollectionViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) zz_PopInteractiveTransition *interactive;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static CGFloat kScreenWidth;

- (instancetype)init {
    NSInteger col = 5;
    kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flow.minimumLineSpacing = 5;
    flow.minimumInteritemSpacing = 5;
    flow.itemSize = CGSizeMake((kScreenWidth - (5 * (col-1)) - 5 - 5)/col, (kScreenWidth - (5 * (col-1)) - 5 - 5)/col);
    
    self = [super initWithCollectionViewLayout:flow];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.contentView.layer.contents = (id)[UIImage imageNamed:@"2.jpg"].CGImage;
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionDetailViewController *ctl = [[CollectionDetailViewController alloc] init];
    ctl.indexPath = indexPath;
    self.interactive = [[zz_PopInteractiveTransition alloc] init];
    [_interactive addPopGesture:ctl];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ((fromVC == self && [toVC isKindOfClass:[CollectionDetailViewController class]]) ||
        (toVC == self && [fromVC isKindOfClass:[CollectionDetailViewController class]])) {
        zz_AnimatedTransitioning *anima = [[zz_AnimatedTransitioning alloc] init];
        anima.isPush = (fromVC == self);
        return anima;
    }
    else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return _interactive.interacting ? _interactive : nil;
}

@end
