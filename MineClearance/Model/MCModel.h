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
@property (nonatomic, strong, readonly) NSArray *modelArray;

/** 行数 */
@property (nonatomic, assign) NSInteger rowNumber;
/** 列数 */
@property (nonatomic, assign) NSInteger ColumnNumber;



+ (MCModel *)sharedModel;


@end
