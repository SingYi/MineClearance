//
//  MCGameViewController.m
//  MineClearance
//
//  Created by 石燚 on 2017/8/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "MCGameViewController.h"
#import "MCGameViewModel.h"
#import "MineCell.h"

#define CELLIDE @"MINECOLLECTIONCELL"
#define CELL_WIDTH kSCREEN_WIDTH / 9

@interface MCGameViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

/** viewModel */
@property (nonatomic, strong) MCGameViewModel *viewModel;

/** gameMap */
@property (nonatomic, strong) UICollectionView *mapCollectionView;
@property (nonatomic, strong) UIScrollView *mapBackground;

/** showArray */
@property (nonatomic, strong) NSMutableArray<NSNumber *> *showArray;
/** mineArray */
@property (nonatomic, strong) NSMutableArray<NSNumber *> *mineArray;

/** game end */
@property (nonatomic, assign) BOOL gameEnd;
/** game Start */
@property (nonatomic, assign) BOOL gameFirstClick;

/** long press */
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@property (nonatomic, strong) UIButton *startButton;

@end

@implementation MCGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];

    NSLog(@" ==== %lf",CELL_WIDTH);
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.mapBackground];
    [self.mapBackground addSubview:self.mapCollectionView];
    [self.view addSubview:self.startButton];
}


#pragma mark - game logic
- (void)startGame {
    //初始化地图
    //设置显示数组
    [[MCModel SharedModel] setShowArray];
    //设置地雷数组
    [[MCModel SharedModel] resetModelArray];

    [self.mapCollectionView reloadData];

    
    _gameEnd = NO;
    _gameFirstClick = YES;
}

#pragma mark - collectionView delegate And DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    MineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLIDE forIndexPath:indexPath];

   UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(findMineWithLongPress:)];
    longPress.minimumPressDuration = 0.2;

    [cell addGestureRecognizer:longPress];

    if (self.mineArray.count != 0) {

        //如果 雷 数组indexpath.row的值为10 表示为雷,
        if (self.mineArray[indexPath.row].integerValue == 10) {
            cell.textLabel.text = @"雷";
            cell.backgroundColor = [UIColor whiteColor];
        } else {
            if (self.mineArray[indexPath.row].integerValue == 0) {
                cell.textLabel.text = @"";
            } else {
                cell.textLabel.text = [NSString stringWithFormat:@"%@",[self mineArray][indexPath.row]];
            }
            cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        }
    }

    //配置显示状态
    if (self.showArray[indexPath.row].integerValue == 2) {
        //找到的地雷
        cell.coverView.hidden = NO;
        cell.coverView.backgroundColor = [UIColor redColor];
    } else if (self.showArray[indexPath.row].integerValue == 1) {
        //显示的方块
        cell.coverView.hidden = YES;

    } else if (self.showArray[indexPath.row].integerValue == 10) {

    } else {
        //未显示的方块
        cell.coverView.hidden = NO;
        cell.coverView.backgroundColor = [UIColor orangeColor];
    }



    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (_gameEnd) {

    } else {
        //游戏进行时
        if (_gameFirstClick) {
            //初始化地雷 防止第一个点到地雷
            [[MCModel SharedModel] gameStartWithSelectIndex:indexPath.row];
//            [collectionView reloadData];
            _gameFirstClick = NO;
        } else {
            //如果不是第一点击则把点击位置的 cell 标记为1,表示已经点过
            [self.showArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:1]];
        }

        //判断点击的位置是否为地雷
        if (self.mineArray[indexPath.row].integerValue == 0) {
            //如果不是地雷,则沿着周围的方向依次翻开不是地雷的方块(只为数字)
            NSSet *set = [[MCModel SharedModel] clickNoMineCellWithIndex:indexPath.row];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:set.count];
            [set enumerateObjectsUsingBlock:^(NSNumber * obj, BOOL * _Nonnull stop) {

                NSIndexPath *arrayindexpath = [NSIndexPath indexPathForItem:obj.integerValue inSection:indexPath.section];
                [array addObject:arrayindexpath];

            }];

            [collectionView reloadItemsAtIndexPaths:array];

        } else  {
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            if (self.mineArray[indexPath.row].integerValue == 10) {
                //如果为地雷,则游戏结束
                // [self showAlertViewWithTitle:@"游戏结束" Message:@"重新开始" Cancel:NO];

            }
        }

    }

    NSLog(@"did select item index : %ld", indexPath.row);
}

- (void)findMineWithLongPress:(UILongPressGestureRecognizer *)sender {

    if (sender.state == UIGestureRecognizerStateBegan) {

        CGPoint point = [sender locationInView:self.mapCollectionView];
        NSIndexPath * indexPath = [self.mapCollectionView indexPathForItemAtPoint:point];

        if (self.showArray[indexPath.row].integerValue == 1) {

        }  else if (_showArray[indexPath.row].integerValue == 2) {
            self.showArray[indexPath.row] = [NSNumber numberWithInt:0];
        } else {
            self.showArray[indexPath.row] = [NSNumber numberWithInt:2];
        }

        [self.mapCollectionView reloadItemsAtIndexPaths:@[indexPath]];

    }

}

#pragma mark - setter
- (void)setGameClass:(MCGameClass)gameClass {
    _gameClass = gameClass;
    [MCModel SharedModel].gameClass = gameClass;

        //设置地图大小
    if (gameClass == MCPrimary) {
        self.mapCollectionView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH);
    } else {
        self.mapCollectionView.frame = CGRectMake(0, 0, CELL_WIDTH * [MCModel SharedModel].rowNumber, CELL_WIDTH * [MCModel SharedModel].columnNumber);
    }
    //设置滑动范围
    self.mapBackground.contentSize = CGSizeMake(CELL_WIDTH * [MCModel SharedModel].rowNumber, CELL_WIDTH * [MCModel SharedModel].columnNumber);

    //开始游戏
    [self startGame];
}

#pragma mark - getter
- (UIScrollView *)mapBackground {
    if (!_mapBackground) {
        _mapBackground = [[UIScrollView alloc] init];
        _mapBackground.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH);
        _mapBackground.center = self.view.center;
        _mapBackground.bounces = NO;
        _mapBackground.backgroundColor = [UIColor grayColor];
    }
    return _mapBackground;
}
- (UICollectionView *)mapCollectionView {
    if (!_mapCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];

        layout.itemSize = CGSizeMake(CELL_WIDTH, CELL_WIDTH);

        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
//        layout.sectionInset = UIEdgeInsetsMake(-0.01, -0.01, -0.01, -0.01);

        _mapCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH) collectionViewLayout:layout];

        _mapCollectionView.delegate = self;
        _mapCollectionView.dataSource = self;

        _mapCollectionView.backgroundColor = [UIColor grayColor];

        [_mapCollectionView registerClass:[MineCell class] forCellWithReuseIdentifier:CELLIDE];
    }
    return _mapCollectionView;
}

- (NSMutableArray<NSNumber *> *)mineArray {
    return [MCModel SharedModel].modelArray;
}

- (NSMutableArray<NSNumber *> *)showArray {
    return [MCModel SharedModel].showArray;
}


- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _startButton.frame = CGRectMake(0, 0, 100, 50);
        [_startButton setTitle:@"开始" forState:(UIControlStateNormal)];
        [_startButton addTarget:self action:@selector(startGame) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _startButton;
}

- (UILongPressGestureRecognizer *)longPress {
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(findMineWithLongPress:)];

        _longPress.minimumPressDuration = 0.5;
    }
    return _longPress;
}

@end











