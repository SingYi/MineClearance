//
//  MineCell.h
//  MineClearance
//
//  Created by 石燚 on 2017/8/9.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCell : UICollectionViewCell

/**
 *  显示标签
 */
@property (nonatomic, strong) UILabel *textLabel;

/**
 *  遮盖用view;
 */
@property (nonatomic, strong) UIView *coverView;

@end
