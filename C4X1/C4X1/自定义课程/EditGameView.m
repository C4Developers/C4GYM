//
//  EditGameView.m
//  C4X1
//
//  Created by 冯宇 on 2018/10/2.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "EditGameView.h"
#import "ProcessViewCell.h"
#import "FloorViewCell.h"
#import "PlayerViewCell.h"
#import "ExtraViewCell.h"
#import "EditGameViewController.h"

@interface EditGameView()
<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)GameModel * game;
@property(nonatomic,strong)UITableView * playerView;
@property(nonatomic,strong)UITableView * floorView;
@property(nonatomic,strong)UITableView * processView;
@property(nonatomic,strong)UICollectionView * extraView;

@property(nonatomic,assign)int currentPlayer;
@property(nonatomic,assign)int lightType;
@property(nonatomic,assign)float interval;
@property(nonatomic,copy)NSString * currentColor;
@property(nonatomic,strong)NSMutableArray *floorArr;
@end

@implementation EditGameView

static float scale = 1.20;
static float oriWidth = 973;
static float oriHeight = 673;
static float space = 40;

-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    float width = AD(oriWidth * scale);
    float height = AD(oriHeight * scale);
    CGRect whiteRect = CGRectMake(0, 0, width, height);
    CGRect grayRect  = CGRectMake(whiteRect.origin.x + 1,
                                  whiteRect.origin.y + 1,
                                  whiteRect.size.width - 2,
                                  whiteRect.size.height - 2);
    
    [[UIColor whiteColor] set];
    UIBezierPath * whitePath = [UIBezierPath bezierPathWithRect:whiteRect];
    CGContextAddPath(ctx, whitePath.CGPath);
    CGContextFillPath(ctx);
    
    [[UIColor colorWithRed:58/255.0f green:58/255.0f blue:58/255.0f alpha:1] set];
    UIBezierPath * grayPath = [UIBezierPath bezierPathWithRect:grayRect];
    CGContextAddPath(ctx, grayPath.CGPath);
    CGContextFillPath(ctx);
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.game = [[GameModel alloc] init];
        self.floorArr = [NSMutableArray array];
        self.currentPlayer = 0;
        self.currentColor = @"blue";
        self.lightType = 0;
        self.interval = 0;
        [self loadUI];
    }
    return self;
}

-(void)setEditGame:(GameModel *)game
{
    self.game = [[GameModel alloc] initWithValue:game];
    NSMutableArray * playerArr = [self.game getPlayerArr];
    if (playerArr.count < 4) {
        for (int i = (int)playerArr.count; i <= 4; i++) {
            Player * player = [[Player alloc] init];
            [playerArr addObject:player];
        }
        self.game.playData = [GameModel createPlayerDataWithPlayers:playerArr];
    }
    [self reloadView];
}

-(void)reloadView{
    [self.processView reloadData];
    [self.playerView reloadData];
    [self.floorView reloadData];
    [self.extraView reloadData];
}

#pragma mark - 加载UI
-(void)loadUI{
    [self addSubview:self.playerView];
    self.playerView.sd_layout
    .leftSpaceToView(self, AD(space/2))
    .topSpaceToView(self, AD(space/2))
    .bottomSpaceToView(self, AD(space/2))
    .widthIs(AD(space * 3-10));
    
    [self addSubview:self.extraView];
    self.extraView.sd_layout
    .leftSpaceToView(self.playerView, AD(space/2))
    .rightSpaceToView(self, AD(space/2))
    .bottomEqualToView(self.playerView)
    .heightIs(AD(oriWidth * scale / 8));
    
    [self addSubview:self.processView];
    self.processView.sd_layout
    .topEqualToView(self.playerView)
    .leftSpaceToView(self.playerView, AD(space/2))
    .bottomSpaceToView(self.extraView, AD(space/2))
    .widthIs(AD((self.width-space*3)/2-10));
    
    [self addSubview:self.floorView];
    self.floorView.sd_layout
    .topEqualToView(self.playerView)
    .leftSpaceToView(self.processView, AD(space/2))
    .rightSpaceToView(self,AD(space/2))
    .bottomSpaceToView(self.extraView, AD(space/2));
    
    
}

-(UITableView *)playerView{
    if (!_playerView) {
        _playerView = [[UITableView alloc] init];
        _playerView.backgroundColor = [UIColor clearColor];
        _playerView.delegate = self;
        _playerView.dataSource = self;
        _playerView.showsVerticalScrollIndicator = NO;
        _playerView.showsHorizontalScrollIndicator = NO;
        _playerView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _playerView.rowHeight = (self.height - AD(space))/4;
        _playerView.layer.borderColor = [UIColor whiteColor].CGColor;
        _playerView.layer.borderWidth = 2;
        _playerView.layer.cornerRadius = 10;
    }
    return _playerView;
}

-(UITableView *)processView{
    if (!_processView) {
        _processView = [[UITableView alloc] init];
        _processView.backgroundColor = [UIColor clearColor];
        _processView.delegate = self;
        _processView.dataSource = self;
        _processView.showsVerticalScrollIndicator = NO;
        _processView.showsHorizontalScrollIndicator = NO;
        _processView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _processView.rowHeight = AD(space*3);
        _processView.layer.borderColor = [UIColor whiteColor].CGColor;
        _processView.layer.borderWidth = 2;
        _processView.layer.cornerRadius = 10;
    }
    return _processView;
}

-(UITableView *)floorView{
    if (!_floorView) {
        _floorView = [[UITableView alloc] init];
        _floorView.backgroundColor = [UIColor clearColor];
        _floorView.delegate = self;
        _floorView.dataSource = self;
        _floorView.showsVerticalScrollIndicator = NO;
        _floorView.showsHorizontalScrollIndicator = NO;
        _floorView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _floorView.rowHeight = AD(space*3);
        _floorView.layer.borderColor = [UIColor whiteColor].CGColor;
        _floorView.layer.borderWidth = 2;
        _floorView.layer.cornerRadius = 10;
    }
    return _floorView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.playerView) {
        return 4;
    }
    else if (tableView == self.processView) {
        NSMutableArray *playerArr = [self.game getPlayerArr];
        if (playerArr.count>0) {
            Player *player = playerArr[self.currentPlayer];
            return player.stepDatas.count;
        }
        else {
            return 0;
        }
    }
    else {
        return self.game.floorCount;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.playerView) {
        PlayerViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PlayerViewCell class])];
        if (cell == nil) {
            cell = [[PlayerViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([PlayerViewCell class])];
        }
        [cell setCellWithIndex:(int)indexPath.row CurrentIndex:self.currentPlayer];
        return cell;
    }
    else if (tableView == self.processView) {
        ProcessViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProcessViewCell class])];
        if (cell == nil) {
            cell = [[ProcessViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([ProcessViewCell class])];
        }
        NSMutableArray * playerArr = [self.game getPlayerArr];
        if (self.currentPlayer < playerArr.count) {
            Player * player = playerArr[self.currentPlayer];
            StepData * step = player.stepDatas[indexPath.row];
            [cell setCellWithStep:step];
        }
        return cell;
    }
    else {
        FloorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FloorViewCell class])];
        if (cell == nil) {
            cell = [[FloorViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([FloorViewCell class])];
        }
        [cell setCellWithIndex:(int)indexPath.row AndArr:self.floorArr];
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.playerView) {
        NSMutableArray * playerArr = [self.game getPlayerArr];
        if (indexPath.row < playerArr.count) {
            self.currentPlayer = (int)indexPath.row;
            [self.playerView reloadData];
            [self.processView reloadData];
        }else{

        }
    }
    else if (tableView == self.processView) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该步骤?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //获取当前的player
            NSMutableArray * players = [self.game getPlayerArr];
            Player * player = players[self.currentPlayer];
            //移除对应步骤
            [player removeStepDataAtIndex:(int)indexPath.row];
            //生成json存入player
            NSString * playerData = [GameModel createPlayerDataWithPlayers:players];
            self.game.playData = playerData;
            //刷新
            [self reloadView];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        __weak UIViewController * vc = [Tool findViewController:self];
        [vc presentViewController:alert animated:YES completion:nil];
    }
    else {
        NSNumber * floorID = [NSNumber numberWithInt:(int)(int)indexPath.row+1];
        if ([self.floorArr containsObject:floorID]) {
            [self.floorArr removeObject:floorID];
            [self.floorView reloadData];
        }
        else{
            if (self.floorArr.count > 0 &&
                self.lightType == 1) {
                [SVProgressHUD showErrorWithStatus:@"呼吸灯不可多选"];
            }else{
                //逻辑
                [self.floorArr addObject:floorID];
                [self.floorView reloadData];
            }
        }
    }
}

#pragma mark - 颜色和操作
-(UICollectionView *)extraView{
    if (!_extraView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(AD(100), AD(oriWidth * scale / 8));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing      = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _extraView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _extraView.delegate = self;
        _extraView.dataSource = self;
        _extraView.backgroundColor = [UIColor clearColor];
        _extraView.showsHorizontalScrollIndicator = NO;
        _extraView.showsVerticalScrollIndicator = NO;
        _extraView.layer.borderColor = [UIColor whiteColor].CGColor;
        _extraView.layer.borderWidth = 2;
        _extraView.layer.cornerRadius = 10;
        [_extraView registerClass:[ExtraViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ExtraViewCell class])];
    }
    return _extraView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ExtraViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ExtraViewCell class]) forIndexPath:indexPath];
    [cell setCellWithIndex:(int)indexPath.row
                  Selector:@selector(extraClick:)
                    Target:self
              CurrentColor:self.currentColor
                 LightType:self.lightType
                  Interval:self.interval];
    return cell;
}

#pragma mark 点击
-(void)extraClick:(UIButton *)button{
    switch (button.tag) {
        case 1 :
        case 2 :
        case 3 :
        case 4 :
        case 5 :
        case 6 : [self lightColorClick:button];break;
        case 7 : [self lightTypeClick:button];break;
        case 8 : [self intervalClick:button]; break;
        case 9 : [self addStep]; break;
        case 10: [self save]; break;
    }
}

#pragma mark 灯光颜色
-(void)lightColorClick:(UIButton *)button{
    NSArray * colorArr = @[@"red",@"orange",@"yellow",
                           @"green",@"blue",@"purple"];
    self.currentColor = colorArr[button.tag - 1];
    [self.extraView reloadData];
}

#pragma mark 灯光类型
-(void)lightTypeClick:(UIButton *)button{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"亮灯方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray * typeArr = @[@"正常",@"呼吸",@"常亮"];
    for(int i = 0; i<typeArr.count; i++){
        NSString * title = typeArr[i];
        [alert addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.floorArr.count > 1) {
                [SVProgressHUD showErrorWithStatus:@"呼吸灯不可多选"];
            }else{
                self.lightType = i;
                [button setTitle:title forState:UIControlStateNormal];
            }
        }]];
    }
    UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
    popPresenter.sourceView = button;
    popPresenter.sourceRect = button.bounds;
    __weak UIViewController * vc = [Tool findViewController:self];
    [vc presentViewController:alert animated:YES completion:nil];
}

#pragma mark 间隔时间
-(void)intervalClick:(UIButton *)button{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"间隔时间" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (float i = 0; i <= 10; i++) {
        NSString * title = i == 0 ? @"等待" : [NSString stringWithFormat:@"%.1fs",i];
        [alert addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.interval = i;
            [button setTitle:title forState:UIControlStateNormal];
        }]];
    }
    UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
    popPresenter.sourceView = button;
    popPresenter.sourceRect = button.bounds;
    __weak UIViewController * vc = [Tool findViewController:self];
    [vc presentViewController:alert animated:YES completion:nil];
}

#pragma mark 加入步骤
-(void)addStep{
    if (self.floorArr.count>0) {
        StepData * step = [[StepData alloc] initWithFloorID:self.floorArr Color:self.currentColor Type:self.lightType Time:self.interval];
        //获取当前的player
        NSMutableArray * players = [self.game getPlayerArr];
        Player * player = players[self.currentPlayer];
        //加入步骤
        [player.stepDatas addObject:step];
        //生成json存入player
        NSString * playerData = [GameModel createPlayerDataWithPlayers:players];
        self.game.playData = playerData;
        //清空选中的数组 刷新view
        [self.floorArr removeAllObjects];
        [self reloadView];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请选择地板"];
    }
}

#pragma mark 保存添加
-(void)save{
    __weak EditGameViewController * vc = (EditGameViewController *)[Tool findViewController:self];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"课程名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
    }];
    NSString * placeHolder = @"请输入课程名";
    if (self.game.name.length > 0) {
        placeHolder = self.game.name;
    }
    alert.textFields.firstObject.placeholder = placeHolder;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        if (alert.textFields.firstObject.text.length == 0 &&
            [placeHolder isEqualToString:@"请输入课程名"]) {
            [SVProgressHUD showInfoWithStatus:placeHolder];
        } else {
            [[RLMRealm defaultRealm] beginWriteTransaction];
            [self.game cleanEmptyPlayer];
            if (alert.textFields.firstObject.text.length > 0) {
                self.game.name = alert.textFields.firstObject.text;
            }
            [[RLMRealm defaultRealm] addOrUpdateObject:self.game];
            [[RLMRealm defaultRealm] commitWriteTransaction];
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadGameList" object:nil];
            [vc dismissViewControllerAnimated:YES completion:nil];
        }
    }]];
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
