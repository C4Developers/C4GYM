//
//  ModuleView.m
//  C4X1
//
//  Created by 冯宇 on 2018/10/1.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "ModuleView.h"
#import "ModuleDelegate.h"
#import "SelectGameViewController.h"
#import "SelectModeViewController.h"

@interface ModuleView()<ModuleDelegate>
@property(nonatomic,strong)UIButton * gameSelect;
@property(nonatomic,strong)UIButton * modeSelect;
@property(nonatomic,strong)UIButton * moduleSelect;
@end

UIImage * normalBackground;
UIImage * selectBackground;
NSArray * deviceArr;

@implementation ModuleView

#pragma mark - 设置模型
-(void)setModel:(ModuleModel *)model{
    _model = model;
    [self reloadView];
}

#pragma mark 选择模块
-(UIButton *)moduleSelect
{
    if (!_moduleSelect) {
        _moduleSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        _moduleSelect.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_moduleSelect setBackgroundImage:normalBackground forState:UIControlStateNormal];
        [_moduleSelect setBackgroundImage:selectBackground forState:UIControlStateHighlighted];
        [_moduleSelect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _moduleSelect.titleLabel.textColor = [UIColor whiteColor];
        _moduleSelect.titleLabel.font = [UIFont systemFontOfSize:AD(35)];
        [_moduleSelect setTitle:@"模块选择" forState:UIControlStateNormal];
        [_moduleSelect addTarget:self action:@selector(selectModule) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moduleSelect;
}

-(void)selectModule{
    __weak UIViewController * vc = [Tool findViewController:self];
    vc.definesPresentationContext = YES;
    UIViewController * pushVC = [self createSelectModuleSheet];
    [vc presentViewController:pushVC animated:YES completion:nil];
}

-(UIAlertController *)createSelectModuleSheet{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"模块选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString * moduleName in deviceArr) {
        UIAlertAction * action = [UIAlertAction actionWithTitle:moduleName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[RLMRealm defaultRealm] beginWriteTransaction];
            self.model.moduleName = moduleName;
            self.model.floorCount = [self getFloorWithModuleName:moduleName];
            if (![self.model.game.moduleName isEqualToString:self.model.moduleName]) {
                self.model.game = nil;
            }
            [[RLMRealm defaultRealm] commitWriteTransaction];
            [self reloadView];
        }];
        [alert addAction:action];
    }
    UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
    popPresenter.sourceView = self.moduleSelect;
    popPresenter.sourceRect = self.moduleSelect.bounds;
    return alert;
}

-(NSString *)getFloorWithModuleName:(NSString *)name{
    if ([name containsString:@"131"]) {
        return @"5";
    } else if ([name containsString:@"1x3"]) {
        return @"3";
    } else if ([name containsString:@"1x6"] || [name containsString:@"2x3"]) {
        return @"6";
    }  else if ([name containsString:@"1x12"] || [name containsString:@"2x6"]){
        return @"12";
    } else if ([name containsString:@"2x2"]) {
        return @"4";
    } else if ([name containsString:@"2x4"]) {
        return @"8";
    } else if ([name containsString:@"2x9"] || [name containsString:@"3x3x2"]) {
        return @"18";
    } else if ([name containsString:@"1x9"] || [name containsString:@"3x3"]) {
        return @"9";
    } else{
        return @"0";
    }
}

#pragma mark 选择游戏
-(UIButton *)gameSelect
{
    if (!_gameSelect) {
        _gameSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        _gameSelect.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_gameSelect setBackgroundImage:normalBackground forState:UIControlStateNormal];
        [_gameSelect setBackgroundImage:selectBackground forState:UIControlStateHighlighted];
        [_gameSelect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _gameSelect.titleLabel.textColor = [UIColor whiteColor];
        _gameSelect.titleLabel.font = [UIFont systemFontOfSize:AD(35)];
        [_gameSelect setTitle:@"课程选择" forState:UIControlStateNormal];
        [_gameSelect addTarget:self action:@selector(selectGame) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gameSelect;
}

-(void)selectGame{
    //先选择模块 再加载课程列表
    if (![self.model.moduleName isEqualToString:@"模块选择"]) {
        __weak UIViewController * vc = [Tool findViewController:self];
        vc.definesPresentationContext = YES;
        SelectGameViewController * gameVC = [[SelectGameViewController alloc] init];
        gameVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [vc presentViewController:gameVC animated:YES completion:^{
            [gameVC setGameDelegate:self];
            [gameVC createGameArr];
        }];
    }else{
        [SVProgressHUD showInfoWithStatus:@"请选择模块"];
    }
}

#pragma mark 选择模式
-(UIButton *)modeSelect
{
    if (!_modeSelect) {
        _modeSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        _modeSelect.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_modeSelect setBackgroundImage:normalBackground forState:UIControlStateNormal];
        [_modeSelect setBackgroundImage:selectBackground forState:UIControlStateHighlighted];
        [_modeSelect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _modeSelect.titleLabel.font = [UIFont systemFontOfSize:AD(35)];
        [_modeSelect setTitle:@"模式选择" forState:UIControlStateNormal];
        [_modeSelect addTarget:self action:@selector(selectMode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modeSelect;
}

-(void)selectMode{
    //先选择课程 再选择模式
    if (self.model.game) {
        __weak UIViewController * vc = [Tool findViewController:self];
        vc.definesPresentationContext = YES;
        SelectModeViewController * modeVC = [[SelectModeViewController alloc] initWithModuleModel:self.model];
        modeVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [vc presentViewController:modeVC animated:YES completion:^{
            [modeVC setModeDelegate:self];
            [modeVC reloadView];
        }];
    }else{
        [SVProgressHUD showInfoWithStatus:@"请选择课程"];
    }
}

#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1.5;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        normalBackground = [Tool getImageWithImgName:@"未选状态----四队列表"];
        selectBackground = [Tool getImageWithImgName:@"已选状态----四队列表"];
        deviceArr = @[@"131",@"1x3",@"1x6",@"1x9",@"1x12",
                    @"2x2",@"2x3",@"2x4",@"2x6",@"2x9",
                    @"3x3",@"3x3x2"];
        float btnScale = 0.45;
        float btnWidth = AD(normalBackground.size.width * btnScale);
        float btnHeight = AD(normalBackground.size.height * btnScale);
        float space = AD(90);
        CGPoint center = CGPointMake(frame.size.width/2, frame.size.height/2);
        
        [self addSubview:self.moduleSelect];
        self.moduleSelect.sd_layout
        .widthIs(btnWidth)
        .heightIs(btnHeight)
        .centerXEqualToView(self)
        .centerYIs(center.y - space);
        
        [self addSubview:self.gameSelect];
        self.gameSelect.sd_layout
        .heightIs(btnHeight)
        .widthIs(btnWidth)
        .centerXEqualToView(self)
        .centerYIs(center.y);
        
        [self addSubview:self.modeSelect];
        self.modeSelect.sd_layout
        .widthIs(btnWidth)
        .heightIs(btnHeight)
        .centerXEqualToView(self)
        .centerYIs(center.y + space);
    }
    return self;
}


#pragma mark 刷新视图
-(void)reloadView
{
    NSString * module = @"模块选择";
    if(self.model){
        module = self.model.moduleName;
    }
    [self.moduleSelect setTitle:module forState:UIControlStateNormal];
    
    NSString * game = @"课程选择";
    if (self.model.game) {
        game = self.model.game.name;
    }
    [self.gameSelect setTitle:game forState:UIControlStateNormal];
    
    NSString * mode = @"模式选择";
    switch ([self.model.countOrTime intValue]) {
        case 0 : mode = @"次数模式";break;
        case 1 : mode = @"时间模式";break;
        default: break;
    }
    [self.modeSelect setTitle:mode forState:UIControlStateNormal];
}

-(void)cleanPlayerData{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    RLMResults * results = [PlayerDataModel objectsWhere:@"cha = %@",self.model.cha];
    [[RLMRealm defaultRealm] deleteObjects:results];
    for (int j = 0; j < 4; j ++) {
        NSString * playerId = [NSString stringWithFormat:@"%d",j + 1];
        PlayerDataModel * model = [[PlayerDataModel alloc] initWithCha:self.model.cha PlayerId:playerId];
        [[RLMRealm defaultRealm] addObject:model];
    }
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

#pragma mark - 协议实现
-(void)setMode:(int)mode{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    self.model.countOrTime = [NSString stringWithFormat:@"%d",mode];
    [[RLMRealm defaultRealm] commitWriteTransaction];
    [self reloadView];
}

-(void)setGame:(GameModel *)game{
    //先清除之前的游戏数据
    [self cleanPlayerData];
    [[RLMRealm defaultRealm] beginWriteTransaction];
    self.model.game = game;
    [[RLMRealm defaultRealm] commitWriteTransaction];
    [self reloadView];
}

-(void)setNumber:(float)number{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    self.model.number = [NSString stringWithFormat:@"%f",number];
    [[RLMRealm defaultRealm] commitWriteTransaction];
    [self reloadView];
}

@end
