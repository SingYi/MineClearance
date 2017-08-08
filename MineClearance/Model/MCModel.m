//
//  MCModel.m
//  MineClearance
//
//  Created by 石燚 on 2017/8/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "MCModel.h"


@interface MCModel ()

/** 每一局的地雷 */



@end

static MCModel *model = nil;
@implementation MCModel


+ (MCModel *)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[MCModel alloc] init];
    });
    return model;
}








@end
