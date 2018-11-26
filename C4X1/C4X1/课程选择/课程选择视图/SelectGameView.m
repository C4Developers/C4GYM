//
//  SelectModeView.m
//  C4X1
//
//  Created by 冯宇 on 2018/9/20.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "SelectGameView.h"
#import "SelectGameCell.h"
#import "DescCell.h"
#import "EditGameViewController.h"

@interface SelectGameView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton * select;
@property(nonatomic,strong)UIButton * create;
@property(nonatomic,strong)UIButton * edit;
@property(nonatomic,strong)UIButton * delete;
@property(nonatomic,strong)UITableView * gameTable;
@property(nonatomic,strong)UITableView * descTable;
@property(nonatomic,strong)NSMutableArray *gameArr;
@property(nonatomic,strong)NSMutableArray *descArr;
@property(nonatomic,assign)int currenIndex;

@end

static float scale = 1.20;
static float oriWidth = 973;
static float oriHeight = 673;
static float space = 40;

@implementation SelectGameView

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

-(UIButton *)delete
{
    if (!_delete) {
        UIImage * normalImage = [Tool getImageWithImgName:@"未选状态----删除"];
        UIImage * selectImage = [Tool getImageWithImgName:@"已选状态----删除"];
        _delete = [UIButton buttonWithType:UIButtonTypeCustom];
        _delete.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_delete setImage:normalImage forState:UIControlStateNormal];
        [_delete setImage:selectImage forState:UIControlStateHighlighted];
        [_delete addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delete;
}

-(UIButton *)edit
{
    if (!_edit) {
        UIImage * normalImage = [Tool getImageWithImgName:@"未选状态----编程"];
        UIImage * selectImage = [Tool getImageWithImgName:@"已选状态----编程"];
        _edit = [UIButton buttonWithType:UIButtonTypeCustom];
        _edit.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_edit setImage:normalImage forState:UIControlStateNormal];
        [_edit setImage:selectImage forState:UIControlStateHighlighted];
        [_edit addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _edit;
}

-(UIButton *)create
{
    if (!_create) {
        UIImage * normalImage = [Tool getImageWithImgName:@"未选状态----创建"];
        UIImage * selectImage = [Tool getImageWithImgName:@"已选状态----创建"];
        _create = [UIButton buttonWithType:UIButtonTypeCustom];
        _create.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_create setImage:normalImage forState:UIControlStateNormal];
        [_create setImage:selectImage forState:UIControlStateHighlighted];
        [_create addTarget:self action:@selector(createClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _create;
}

-(UIButton *)select
{
    if (!_select) {
        UIImage * normalImage = [Tool getImageWithImgName:@"未选状态----选择"];
        UIImage * selectImage = [Tool getImageWithImgName:@"已选状态----选择"];
        _select = [UIButton buttonWithType:UIButtonTypeCustom];
        _select.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_select setImage:normalImage forState:UIControlStateNormal];
        [_select setImage:selectImage forState:UIControlStateHighlighted];
        [_select addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _select;
}

-(UITableView *)gameTable{
    if (!_gameTable) {
        _gameTable = [[UITableView alloc] init];
        _gameTable.backgroundColor = [UIColor clearColor];
        _gameTable.delegate = self;
        _gameTable.dataSource = self;
        _gameTable.showsVerticalScrollIndicator = NO;
        _gameTable.showsHorizontalScrollIndicator = NO;
        _gameTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _gameTable.layer.borderColor = [UIColor whiteColor].CGColor;
        _gameTable.layer.borderWidth = 2;
        _gameTable.layer.cornerRadius = 10;
    }
    return _gameTable;
}

-(UITableView *)descTable{
    if (!_descTable) {
        _descTable = [[UITableView alloc] init];
        _descTable.delegate = self;
        _descTable.dataSource = self;
        _descTable.backgroundColor = [UIColor clearColor];
        _descTable.showsVerticalScrollIndicator = NO;
        _descTable.showsHorizontalScrollIndicator = NO;
        _descTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _descTable.layer.borderColor = [UIColor whiteColor].CGColor;
        _descTable.layer.borderWidth = 2;
        _descTable.layer.cornerRadius = 10;
    }
    return _descTable;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.currenIndex = 9999;
        [self createGameArr];
        [self createDescArr];
        [self loadUI];
    }
    return self;
}


#pragma marl - 获取数据
-(void)createGameArr{
    [self.gameArr removeAllObjects];
    self.gameArr = [NSMutableArray array];
    if (self.delegate) {
        ModuleView * view = (ModuleView *)self.delegate;
        int floorCount = [view.model.floorCount intValue];
        for (GameModel * game in [GameModel allObjects]){
            if (game.floorCount == floorCount &&
                [game.moduleName isEqualToString:view.model.moduleName]) {
                [self.gameArr addObject:game];
            }
        }
        [self.gameTable reloadData];
    }
}

-(void)createDescArr{
    [self.descArr removeAllObjects];
    self.descArr = [NSMutableArray array];
    if (self.currenIndex != 9999) {
        GameModel * game = self.gameArr[self.currenIndex];
        NSMutableArray * playerArr = [game getPlayerArr];
        for (int i = 0; i < playerArr.count; i++) {
            Player * player = playerArr[i];
            NSString * des = [NSString stringWithFormat:@"玩家%d\n",i + 1];
            for (int j = 0; j < player.stepDatas.count; j++) {
                StepData * stepData = player.stepDatas[j];
                NSString * stepDes = [NSString stringWithFormat:@"第%d步：\n%@\n\n",j + 1,[stepData createStepDescription]];
                des = [des stringByAppendingString:stepDes];
            }
            [self.descArr addObject:des];
        }
    }
}

#pragma mark - 加载UI
-(void)loadUI{
    
    [self addSubview:self.delete];
    self.delete.sd_layout
    .bottomSpaceToView(self, AD(space))
    .rightSpaceToView(self, AD(space))
    .widthIs(AD(250))
    .heightIs(AD(90));
    
    [self addSubview:self.edit];
    self.edit.sd_layout
    .rightSpaceToView(self.delete, AD(space))
    .bottomEqualToView(self.delete)
    .widthRatioToView(self.delete, 1)
    .heightRatioToView(self.delete, 1);
    
    [self addSubview:self.select];
    self.select.sd_layout
    .leftEqualToView(self.edit)
    .rightEqualToView(self.edit)
    .bottomSpaceToView(self.delete, AD(space/2))
    .heightRatioToView(self.delete, 1);
    
    [self addSubview:self.create];
    self.create.sd_layout
    .leftEqualToView(self.delete)
    .rightEqualToView(self.delete)
    .bottomSpaceToView(self.delete, AD(space/2))
    .heightRatioToView(self.delete, 1);
    
    [self addSubview:self.gameTable];
    self.gameTable.sd_layout
    .leftSpaceToView(self, AD(space))
    .topSpaceToView(self, AD(space))
    .bottomSpaceToView(self, AD(space))
    .widthIs(AD(self.frame.size.width/2 - space * 2));
    
    [self addSubview:self.descTable];
    self.descTable.sd_layout
    .leftEqualToView(self.select)
    .rightEqualToView(self.create)
    .bottomSpaceToView(self.create, AD(space))
    .topSpaceToView(self, AD(space));
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return space * 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, AD(space * 2))];
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.font = [UIFont boldSystemFontOfSize:AD(40)];
    sectionLabel.textColor = [UIColor whiteColor];
    if (tableView == self.gameTable) {
        sectionLabel.text = @"课程名称";
    } else {
        sectionLabel.text = @"课程内容";
    }
    return sectionLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.gameTable) {
        return self.gameArr.count;
    }
    else {
        return self.descArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.gameTable) {
        return AD(90);
    }else {
        NSString * desc = self.descArr[indexPath.row];
        float height = [Tool getTextHeight:desc Width:tableView.size.width FontSize:AD(30)] + 10;
        return height;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.gameTable) {
        SelectGameCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectGameCell class])];
        if (cell == nil) {
            cell = [[SelectGameCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([SelectGameCell class])];
        }
        GameModel * game = self.gameArr[indexPath.row];
        [cell setCellWithName:game.name];
        if (indexPath.row == self.currenIndex) {
            cell.titleLabel.backgroundColor = SelectColor;
        }
        return cell;
    }
    else {
        DescCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProcessViewCell class])];
        if (cell == nil) {
            cell = [[DescCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([ProcessViewCell class])];
        }
        NSString * desc = self.descArr[indexPath.row];
        [cell setCellWithDesc:desc];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.gameTable) {
        self.currenIndex = (int)indexPath.row;
        [self.gameTable reloadData];
        [self createDescArr];
        [self.descTable reloadData];
    }
}


#pragma mark 创建点击
-(void)createClick{
    int floorCount = 0;
    NSString * moduleName = @"";
    if (self.delegate) {
        ModuleView * view = (ModuleView *)self.delegate;
        floorCount = [view.model.floorCount intValue];
        moduleName = view.model.moduleName;
    }

    EditGameViewController * editVC = [[EditGameViewController alloc] init];
    __weak UIViewController * vc = [Tool findViewController:self];
    vc.definesPresentationContext = YES;
    editVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [vc presentViewController:editVC animated:YES completion:^{
        GameModel * game = [[GameModel alloc] initEmptyWithFloorCount:floorCount moduleName:moduleName];
        [editVC setEditGame:game];
    }];
}


#pragma mark 编辑点击
-(void)editClick{
    if (self.currenIndex == 9999) {
        [SVProgressHUD showInfoWithStatus:@"请选择课程"];
    }else{
        EditGameViewController * editVC = [[EditGameViewController alloc] init];
        __weak UIViewController * vc = [Tool findViewController:self];
        vc.definesPresentationContext = YES;
        editVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [vc presentViewController:editVC animated:YES completion:^{
            GameModel * game = [[GameModel alloc] initWithValue:self.gameArr[self.currenIndex]];
            [editVC setEditGame:game];
        }];
    }
}

#pragma mark 选择点击
-(void)selectClick{
    if (self.currenIndex == 9999) {
        [SVProgressHUD showInfoWithStatus:@"请选择课程"];
    }else {
        if ([self.delegate respondsToSelector:@selector(setGame:)]) {
            GameModel * game = self.gameArr[self.currenIndex];
            [self.delegate setGame:game];
            __weak SelectGameViewController * vc = (SelectGameViewController *)[Tool findViewController:self];
            [vc dismiss];
        }
    }
}

#pragma mark 删除点击
-(void)deleteClick{
    if(self.currenIndex == 9999){
        [SVProgressHUD showInfoWithStatus:@"请选择课程"];
    } else {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该课程?" preferredStyle:UIAlertControllerStyleAlert];
        @weakify(self);
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            //获取对象
            GameModel * game = self.gameArr[self.currenIndex];
            //修改列表
            [self.gameArr removeObjectAtIndex:self.currenIndex];
            [self.gameTable reloadData];
            self.currenIndex = 9999;
            //刷新描述
            [self createDescArr];
            [self.descTable reloadData];
            //删除库
            [[RLMRealm defaultRealm] beginWriteTransaction];
            [[RLMRealm defaultRealm] deleteObject:game];
            [[RLMRealm defaultRealm] commitWriteTransaction];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        __weak UIViewController * vc = [Tool findViewController:self];
        [vc presentViewController:alert animated:YES completion:nil];
    }
}

@end
