//
//  MCModel.h
//  MineClearance
//
//  Created by 石燚 on 2017/8/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MCPrimary,
    MCMiddle,
    MCHigh,
    MCCustom
} MCGameClass;

@interface MCModel : NSObject

/** 显示数组 */
@property (nonatomic, strong) NSMutableArray<NSNumber *> *modelArray;

/** 行数 */
@property (nonatomic, assign) NSInteger rowNumber;
/** 列数 */
@property (nonatomic, assign) NSInteger columnNumber;
/** 地雷数目 */
@property (nonatomic, assign) NSInteger mineNumber;

/** 游戏等级 */
@property (nonatomic, assign) MCGameClass gameClass;


+ (MCModel *)SharedModel;


#pragma mark - game logic
/** 重置游戏 */
- (NSArray *)gameReset;

/** 根据点击的下标开始游戏 */
- (NSArray *)gameStartWithSelectIndex:(NSInteger)idx;

#pragma mark - set map
/** 设置显示数组 */
- (NSMutableArray *)setShowArray;







@end










