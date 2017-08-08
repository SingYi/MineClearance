//
//  ControllerManager.m
//  MineClearance
//
//  Created by 石燚 on 2017/8/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "ControllerManager.h"
#import "MCGuideViewController.h"

@interface ControllerManager ()

@property (nonatomic, strong) MCGuideViewController *guideViewController;

@end

static ControllerManager *manager = nil;

@implementation ControllerManager

+ (ControllerManager *)SharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ControllerManager alloc] init];
    });
    return manager;
}

#pragma mark - getter
- (UINavigationController *)rootViewController {
    if (!_rootViewController) {
        _rootViewController = [[UINavigationController alloc] initWithRootViewController:self.guideViewController];

        _rootViewController.navigationBarHidden = YES;
    }
    return _rootViewController;
}

- (MCGuideViewController *)guideViewController {
    if (!_guideViewController) {
        _guideViewController = [[MCGuideViewController alloc] init];
    }
    return _guideViewController;
}


@end














