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

@end

@implementation MCGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.mapBackground];
    [self.mapBackground addSubview:self.mapCollectionView];
}

#pragma mark - game logic
- (void)startGame {
    //初始化地图
    //设置显示数组
    _showArray = [[MCModel SharedModel] setShowArray];

    //设置滑动范围
    self.mapBackground.contentSize = CGSizeMake(CELL_WIDTH * [MCModel SharedModel].rowNumber, CELL_WIDTH * [MCModel SharedModel].columnNumber);


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

    cell.backgroundColor = [UIColor orangeColor];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (_gameEnd) {

    } else {
        //游戏进行时
        if (_gameFirstClick) {
            //初始化地雷 防止第一个点到地雷
            [[MCModel SharedModel] gameStartWithSelectIndex:indexPath.row];
//            _gameFirstClick = NO;
            [collectionView reloadData];
        }


    }

    NSLog(@"did select item index : %ld", indexPath.row);
}

#pragma mark - setter
- (void)setGameClass:(MCGameClass)gameClass {
    _gameClass = gameClass;
    [MCModel SharedModel].gameClass = gameClass;

    if (gameClass == MCPrimary) {
        self.mapCollectionView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH);
    } else {
        //设置地图大小
        self.mapCollectionView.frame = CGRectMake(0, 0, CELL_WIDTH * [MCModel SharedModel].rowNumber, CELL_WIDTH * [MCModel SharedModel].columnNumber);
    }


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
        _mapBackground.backgroundColor = [UIColor blackColor];
    }
    return _mapBackground;
}
- (UICollectionView *)mapCollectionView {
    if (!_mapCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.itemSize = CGSizeMake(CELL_WIDTH, CELL_WIDTH);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;

        _mapCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH) collectionViewLayout:layout];


        _mapCollectionView.delegate = self;
        _mapCollectionView.dataSource = self;


        [_mapCollectionView registerClass:[MineCell class] forCellWithReuseIdentifier:CELLIDE];
    }
    return _mapCollectionView;
}

- (NSMutableArray<NSNumber *> *)mineArray {
    return [MCModel SharedModel].modelArray;
}

@end











