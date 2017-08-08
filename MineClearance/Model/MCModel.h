//
//  MCModel.h
//  MineClearance
//
//  Created by 石燚 on 2017/8/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCModel : NSObject

/** 显示数组 */
@property (nonatomic, strong) NSArray *showArray;


+ (MCModel *)sharedModel;


@end
