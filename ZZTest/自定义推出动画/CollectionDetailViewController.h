//
//  CollectionDetailViewController.h
//  ZZTest
//
//  Created by 多米智投 on 2018/5/22.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
