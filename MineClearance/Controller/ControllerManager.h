//
//  ControllerManager.h
//  MineClearance
//
//  Created by 石燚 on 2017/8/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ControllerManager : NSObject

/** rootViewController (NavigationController) */
@property (nonatomic, strong) UINavigationController *rootViewController;


/** ControllerManager */
+ (ControllerManager *)SharedManager;



@end
