//
//  MCGameViewController.h
//  MineClearance
//
//  Created by 石燚 on 2017/8/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MCPrimary,
    MCMiddle,
    MCHigh,
    MCCustom
} MCGameClass;

@interface MCGameViewController : UIViewController

@property (nonatomic, assign) MCGameClass gameClass;

@end
