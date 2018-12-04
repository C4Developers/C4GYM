//
//  RankView.m
//  C4X1
//
//  Created by 冯宇 on 2018/9/22.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "RankView.h"
#import "RankCell.h"
#import "RankDetailCell.h"

#define TableViewCellIdentifier @"RankView"
#define CollectionViewCellIdentifier @"RankDetailCell"

@interface RankView()
<
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property(nonatomic,strong)ModuleModel * model;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * playerDatas;
@end

@implementation RankView
{
    float rowHeight;
    float playerUnitW;
    float hitUnitW;
    float timeUnitW;
    float rankUnitW;
    float progressUnitW;
    float detailUnitW;
    float sumUnitCount;
}


-(instancetype)initWithFrame:(CGRect)frame moduleModel:(ModuleModel *)model
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.model = model;
        [self initData];
        [self addSubview:self.collectionView];
        [self addSubview:self.tableView];
        [self observeReceiveGameData];
    }
    return self;
}

-(void)initData
{
    rowHeight = AD(60);
    playerUnitW = 1;
    hitUnitW = 1;
    timeUnitW = 1;
    rankUnitW = 1;
    progressUnitW = 3;
    detailUnitW = 2;
    sumUnitCount = playerUnitW + hitUnitW + timeUnitW + rankUnitW + progressUnitW + detailUnitW;
}

-(void)createPlayerDatas{
    NSString * cha = self.model.cha;
    [self.playerDatas removeAllObjects];
    self.playerDatas = [PlayerDataModel getPlayerDatasWithCha:cha];
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

-(void)observeReceiveGameData{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"receiveGameData" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        //从数据库拿出数据更新UI
        [self createPlayerDatas];
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }];
}

-(void)setDelegate:(id<ModuleDelegate>)delegate
{
    _delegate = delegate;
    [self createPlayerDatas];
}

#pragma mark - tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = rowHeight;
        _tableView.bounces = NO;
    }
    return _tableView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return rowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float length = self.frame.size.width / sumUnitCount;

    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, rowHeight)];
    header.backgroundColor = [UIColor clearColor];
//    NSArray * titles = @[@"队员ID",@"击中",@"用时",@"排名",@"完成度"];
    NSArray * titles = @[@"队员ID",@"击中",@"用时",@"完成度"];
    for(int i = 0; i < titles.count; i ++)
    {
        float width = length;
        if (i == titles.count - 1) {
            width = length * 3;
        }
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(length * i, 0, width, rowHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:AD(18)];
        label.text = titles[i];
        [header addSubview:label];
    }
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RankCell * cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (!cell) {
        cell = [[RankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
    }
    PlayerDataModel * playerData = self.playerDatas[indexPath.row];
    
    int sum = [self.model.number intValue];
    
    [cell setCellWithGame:self.model.game width:tableView.frame.size.width Height:tableView.rowHeight PlayerData:playerData Index:(int)indexPath.row Sum:sum];
    return cell;
}

#pragma mark - collectionView
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat itemWidth = self.frame.size.width;
        CGFloat itemHeight= self.frame.size.height/2;
        UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        [_collectionView registerClass:NSClassFromString(CollectionViewCellIdentifier) forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RankDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[RankDetailCell alloc] initWithFrame:CGRectMake(0, 0, collectionView.frame.size.width, collectionView.frame.size.height)];
    }
    PlayerDataModel * playerData = self.playerDatas[indexPath.row];
    [cell setCellWithPlayerData:playerData];
    return cell;
}

@end
