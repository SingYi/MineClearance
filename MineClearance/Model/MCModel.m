//
//  MCModel.m
//  MineClearance
//
//  Created by 石燚 on 2017/8/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "MCModel.h"

#define ARRAYADDNUMBER(n) [array addObject:[NSNumber numberWithInteger:(n)]];

@interface MCModel ()

/** 每一局的地雷 */



@end

static MCModel *model = nil;
@implementation MCModel


+ (MCModel *)SharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[MCModel alloc] init];
    });
    return model;
}

#pragma mark - game logic
//重置游戏
- (NSArray *)gameReset {
    //清除所有数据
    [_modelArray removeAllObjects];

    return [_modelArray copy];
}

//开始游戏
- (NSArray *)gameStartWithSelectIndex:(NSInteger)idx {

    [self resetModelArray];
    BOOL isNext = [self getMineRandomWithIndex:idx];

    if (isNext) {
        //计算地雷周围的数子
        isNext = [self calculateTheNumbersAroundTheMines];
        if (isNext) {

        } else {
            NSLog(@"计算地雷周围数字出错");
        }
    } else {
        NSLog(@"随机生成地雷出错");
    }

//    NSLog(@"%@",self.modelArray);

    return self.modelArray;
}

/** 随机生成地雷 */
- (BOOL)getMineRandomWithIndex:(NSInteger)idx {
    /*
     *  1.首先计算出选中的下标和下标周围的下标都放到数组 array 里
     *  2.创建一个用于记录下标的数组 indexArray(key = index), indexArray 的 count 等于 modelArray的 count.移除 1. 里得到的下标
     *  3.随机生成地雷
     */

    //1.点击的格子和周围的八个格子
    NSArray *array = [self selectTheItemAround8itemsWithIndex:idx];

    if (array.count == 0) {
        NSLog(@"获取周围八个格子出错");
        return NO;
    }

    //2.将选中的下标和周围的下标移除随机地雷
    NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:_rowNumber * _columnNumber];
    for (NSInteger i = 0; i < _rowNumber * _columnNumber; i++) {
        [indexArray setObject:[NSNumber numberWithInteger:i] atIndexedSubscript:i];
    }

    [indexArray removeObject:[NSNumber numberWithInteger:idx]];

    for (NSNumber *obj in array) {
        [indexArray removeObject:obj];
    }

    if (indexArray.count != self.modelArray.count - array.count - 1) {
        NSLog(@"下标数组出错");
        return NO;
    }

    //3.计算地雷
    for (NSInteger i = 0; i < _mineNumber ; i++) {
        NSInteger indexArrayCount = indexArray.count;
        NSInteger random = arc4random() % indexArrayCount;
        NSNumber *indexNumber = indexArray[random];
        //下标对应的值修改为 10 表示为地雷.
        [self.modelArray replaceObjectAtIndex:indexNumber.integerValue withObject:[NSNumber numberWithInteger:10]];
        //修改完之后删除对应下标
        [indexArray removeObject:indexNumber];
    }

    if (self.modelArray.count == _rowNumber * _columnNumber) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)calculateTheNumbersAroundTheMines {
    /**
     *  循环数组,如果是地雷 , 就将周围的数组全部加1
     */
    if (_modelArray) {

        [_modelArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.integerValue == 10) {
                NSArray *array = [self selectTheItemAround8itemsWithIndex:idx];
                if (array.count != 0) {

                    for (NSNumber *index in array) {
                        if (index.integerValue < 0 || index.integerValue >= _rowNumber * _columnNumber) {
                            NSLog(@"row == %ld, col == %ld",_rowNumber,_columnNumber);
                            NSLog(@"idx == %ld",idx);
                            NSLog(@"modelarray[idx] == %@",_modelArray[idx]);
                            NSLog(@"%@",array);
                            break;
                        } else {
                            NSNumber *value = _modelArray[index.integerValue];
                            [_modelArray replaceObjectAtIndex:index.integerValue withObject:[self addOne:value]];
                        }
                    }

                }
            }
        }];
    }

    return YES;
}

//数字加一
- (NSNumber *)addOne:(NSNumber *)number {
    NSInteger i = number.integerValue;
    if (i == 10) {
        return number;
    } else {
        i++;
        return [NSNumber numberWithInteger:i];
    }
}


/** 翻开下标为0的周围所有格子,如果周围存在还有为0的格子,继续翻开下标为0的格子 */
- (NSSet *)clickNoMineCellWithIndex:(NSInteger)index {
    NSMutableSet<NSNumber *> *alreadySet = [NSMutableSet setWithObject:[NSNumber numberWithInteger:index]];
    NSMutableSet<NSNumber *> *allSet = [self findEmptyIndex:index];
    //判断是否计算完毕
    allSet = [self alreadySet:alreadySet allSet:allSet WithMineArray:self.modelArray];

    for (NSNumber *num in allSet) {
        [alreadySet unionSet:[self findAroundWihtIndex:num.integerValue]];
    }

    for (NSNumber *num in alreadySet) {
        self.showArray[num.integerValue] = [NSNumber numberWithInt:1];
    }

    return alreadySet;
}


//计算周围8个方向是否有空
- (NSMutableSet *)findEmptyIndex:(NSInteger)idx {

    NSMutableSet *set = [NSMutableSet set];

    if (self.modelArray[idx].integerValue == 0) {
        [set addObject:[NSNumber numberWithInteger:idx]];
    }

    NSArray *array = [self selectTheItemAround8itemsWithIndex:idx];

    [array enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.modelArray[obj.integerValue].integerValue == 0) {
            [set addObject:obj];
        }
    }];

    return set;

}

/** 判断是否计算完毕 */
- (NSMutableSet *)alreadySet:(NSMutableSet *)alreadySet allSet:(NSMutableSet *)allSet WithMineArray:(NSMutableArray *)mineArray {
    NSMutableSet<NSNumber *> *beingSet = [NSMutableSet setWithSet:allSet];
    [beingSet minusSet:alreadySet];

    if (beingSet.count == 0) {
        return allSet;
    } else {
        [alreadySet unionSet:beingSet];
        for (NSNumber *num in beingSet) {
            [allSet unionSet:[self findEmptyIndex:num.integerValue]];
        }
        allSet = [self alreadySet:alreadySet allSet:allSet WithMineArray:mineArray];
    }
    return allSet;
}

- (NSMutableSet *)findAroundWihtIndex:(NSInteger)idx {
    NSMutableSet *set = [NSMutableSet set];
    NSArray *array = [self selectTheItemAround8itemsWithIndex:idx];

    [array enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [set addObject:obj];
    }];

    return set;
}

//根据选中的下标,返回周围8个格子的坐标
- (NSArray *)selectTheItemAround8itemsWithIndex:(NSInteger)idx {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:8];

    if (idx == 0) {
        ARRAYADDNUMBER(idx + 1);
        ARRAYADDNUMBER(idx + _rowNumber);
        ARRAYADDNUMBER(idx + _rowNumber + 1);
    } else if (idx == _rowNumber - 1) {
        ARRAYADDNUMBER(idx + _rowNumber);
        ARRAYADDNUMBER(idx + _rowNumber - 1);
        ARRAYADDNUMBER(idx - 1);
    } else if (idx == (_rowNumber * _columnNumber) - 1) {
        ARRAYADDNUMBER(idx - _rowNumber);
        ARRAYADDNUMBER(idx - _rowNumber - 1);
        ARRAYADDNUMBER(idx - 1);
    } else if (idx == _rowNumber * (_columnNumber - 1)) {
        ARRAYADDNUMBER(idx + 1);
        ARRAYADDNUMBER(idx - _rowNumber + 1);
        ARRAYADDNUMBER(idx - _rowNumber);
    } else if (idx % _rowNumber == 0) {
        ARRAYADDNUMBER(idx - _rowNumber);
        ARRAYADDNUMBER(idx - _rowNumber + 1);
        ARRAYADDNUMBER(idx + 1);
        ARRAYADDNUMBER(idx + _rowNumber + 1);
        ARRAYADDNUMBER(idx + _rowNumber);
    } else if (idx % _rowNumber == (_rowNumber - 1)) {
        ARRAYADDNUMBER(idx - _rowNumber);
        ARRAYADDNUMBER(idx - _rowNumber - 1);
        ARRAYADDNUMBER(idx - 1);
        ARRAYADDNUMBER(idx + _rowNumber - 1);
        ARRAYADDNUMBER(idx + _rowNumber);
    } else if (idx / _rowNumber == 0) {
        ARRAYADDNUMBER(idx - 1);
        ARRAYADDNUMBER(idx + _rowNumber - 1);
        ARRAYADDNUMBER(idx + _rowNumber);
        ARRAYADDNUMBER(idx + _rowNumber + 1);
        ARRAYADDNUMBER(idx + 1);
    } else if ((idx / _rowNumber) == (_columnNumber - 1)){
        ARRAYADDNUMBER(idx - 1);
        ARRAYADDNUMBER(idx - _rowNumber - 1);
        ARRAYADDNUMBER(idx - _rowNumber);
        ARRAYADDNUMBER(idx - _rowNumber + 1);
        ARRAYADDNUMBER(idx + 1);
    } else {
        ARRAYADDNUMBER(idx - _rowNumber);
        ARRAYADDNUMBER(idx - _rowNumber + 1);
        ARRAYADDNUMBER(idx + 1);
        ARRAYADDNUMBER(idx + _rowNumber + 1);
        ARRAYADDNUMBER(idx + _rowNumber);
        ARRAYADDNUMBER(idx + _rowNumber - 1);
        ARRAYADDNUMBER(idx - 1);
        ARRAYADDNUMBER(idx - _rowNumber - 1);
    }
    return array;
}





#pragma mark - setter
- (void)setGameClass:(MCGameClass)gameClass {
    _gameClass = gameClass;
    switch (gameClass) {
        case MCPrimary: {
            _rowNumber = 9;
            _columnNumber = 9;
            _mineNumber = 10;
            break;
        }
        case MCMiddle: {
            _rowNumber = 16;
            _columnNumber = 16;
            _mineNumber = 40;
            break;
        }
        case MCHigh: {
            _rowNumber = 30;
            _columnNumber = 16;
            _mineNumber = 99;
            break;
        }
        case MCCustom: {
            break;
        }
        default:
            break;
    }

    _modelArray = [NSMutableArray arrayWithCapacity:_rowNumber * _columnNumber];
    _showArray = [NSMutableArray arrayWithCapacity:_rowNumber * _columnNumber];
}


/** 设置显示数组 */ 
- (NSMutableArray *)setShowArray {
    if (_rowNumber == 0 || _columnNumber == 0) {
        return nil;
    }

    if (self.showArray) {
        for (int i = 0; i < _rowNumber * _columnNumber; i++) {
            [self.showArray setObject:[NSNumber numberWithInt:0] atIndexedSubscript:i];
        }
    } else {
        NSLog(@"显示数组出错");
    }

    return self.showArray;
}

- (void)resetModelArray {
    //随机生成地雷
    if (_modelArray.count == 0) {
        for (NSInteger i = 0; i < _rowNumber * _columnNumber; i++) {
            [_modelArray setObject:[NSNumber numberWithInteger:0] atIndexedSubscript:i];
        }
    } else {
        [_modelArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_modelArray replaceObjectAtIndex:idx withObject:[NSNumber numberWithInteger:0]];
        }];
    }
}

#pragma mark - getter





@end











