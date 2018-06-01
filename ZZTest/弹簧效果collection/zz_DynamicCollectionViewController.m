//
//  zz_DynamicCollectionViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/25.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "zz_DynamicCollectionViewController.h"
#import "zz_DynamicCollectionLayout.h"

@interface zz_DynamicCollectionViewController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@end

@implementation zz_DynamicCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self.collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"test"];
    self.collection.dataSource = self;
    self.collection.collectionViewLayout = [[zz_DynamicCollectionLayout alloc] init];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 300;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"test" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor brownColor];
    return cell;
}

@end
