//
//  MineCell.m
//  MineClearance
//
//  Created by 石燚 on 2017/8/9.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1.f;
    }
    return self;
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];


}

#pragma mark - getter
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_textLabel];
    }
    return _textLabel;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor orangeColor];

        [self.contentView addSubview:_coverView];
        [self.contentView bringSubviewToFront:_coverView];
    }
    return _coverView;
}




@end

