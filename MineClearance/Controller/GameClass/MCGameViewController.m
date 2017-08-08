//
//  MCGameViewController.m
//  MineClearance
//
//  Created by 石燚 on 2017/8/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "MCGameViewController.h"
#import "MCGameViewModel.h"

@interface MCGameViewController ()

/** viewModel */
@property (nonatomic, strong) MCGameViewModel *viewModel;

@end

@implementation MCGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
}

#pragma mark - getter


@end
