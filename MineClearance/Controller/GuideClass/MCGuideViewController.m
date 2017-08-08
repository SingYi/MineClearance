//
//  MCGuideViewController.m
//  MineClearance
//
//  Created by 石燚 on 2017/8/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "MCGuideViewController.h"
#import "MCGameViewController.h"

@interface MCGuideViewController ()

/** 游戏页面 */ 
@property (nonatomic, strong) MCGameViewController *gameViewController;

@end

@implementation MCGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *testButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    testButton.center = self.view.center;


    testButton.bounds = CGRectMake(0, 0, 100, 100);
    [testButton setTitle:@"初级游戏" forState:(UIControlStateNormal)];
    [testButton addTarget:self action:@selector(pushGameView) forControlEvents:(UIControlEventTouchUpInside)];

    [testButton setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:testButton];
}


- (void)pushGameView {

    self.gameViewController.gameClass = MCPrimary;
    [self.navigationController pushViewController:self.gameViewController animated:YES];

}


#pragma mark - getter
- (MCGameViewController *)gameViewController {
    if (!_gameViewController) {
        _gameViewController = [MCGameViewController new];
    }
    return _gameViewController;
}





@end











