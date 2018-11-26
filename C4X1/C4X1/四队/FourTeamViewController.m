//
//  FourTeamViewController.m
//  C4X1
//
//  Created by 冯宇 on 2018/9/18.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "FourTeamViewController.h"
#import "ModuleView.h"

@interface FourTeamViewController ()
@property(nonatomic,strong)ModuleView * view1;
@property(nonatomic,strong)ModuleView * view2;
@property(nonatomic,strong)ModuleView * view3;
@property(nonatomic,strong)ModuleView * view4;
@end


@implementation FourTeamViewController
{
    float width;
    float height;
    float navHeight;
    
    float moduleCount;
    float playerCount;
}

-(ModuleView *)view1
{
    if (!_view1) {
        float x = 0;
        float y = navHeight;
        _view1 = [[ModuleView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    }
    return _view1;
}

-(ModuleView *)view2
{
    if (!_view2) {
        float x = width;
        float y = navHeight;
        _view2 = [[ModuleView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    }
    return _view2;
}

-(ModuleView *)view3
{
    if (!_view3) {
        float x = 0;
        float y = navHeight + height;
        _view3 = [[ModuleView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    }
    return _view3;
}

-(ModuleView *)view4
{
    if (!_view4) {
        float x = SCREEN_WIDTH / 2;
        float y = navHeight + height;
        _view4 = [[ModuleView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    }
    return _view4;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    navHeight = 64;
    width = SCREEN_WIDTH / 2;
    height = (SCREENH_HEIGHT - navHeight)/2;
    moduleCount = 4;
    playerCount = 4;
    
    [self createModuleView];
    [self createModuleData];
    [self createPlayerData];
}


-(void)createModuleView
{
    [self.view addSubview:self.view1];
    [self.view addSubview:self.view2];
    [self.view addSubview:self.view3];
    [self.view addSubview:self.view4];
}

-(void)createModuleData{
    RLMResults * results = [ModuleModel allObjects];
    NSMutableArray * moduleArr = [NSMutableArray arrayWithCapacity:0];
    if (results.count != moduleCount) {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        for(int i = 0; i < moduleCount; i++){
            NSString * cha = [NSString stringWithFormat:@"%d",i + 1];
            ModuleModel * model = [[ModuleModel alloc] initWithCha:cha];
            [[RLMRealm defaultRealm] addOrUpdateObject:model];
            [moduleArr addObject:model];
        }
        [[RLMRealm defaultRealm] commitWriteTransaction];
    }else{
        for(int i = 0; i < moduleCount; i++){
            ModuleModel * model = results[i];
            [moduleArr addObject:model];
        }
    }
    [self.view1 setModel:moduleArr.firstObject];
    [self.view2 setModel:moduleArr[1]];
    [self.view3 setModel:moduleArr[2]];
    [self.view4 setModel:moduleArr.lastObject];
}

-(void)createPlayerData{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    for (int i = 0; i < moduleCount; i++) {
        NSString * cha = [NSString stringWithFormat:@"%d",i + 1];
        RLMResults * results = [PlayerDataModel objectsWhere:@"cha = %@",cha];
            if (results.count != playerCount) {
                [[RLMRealm defaultRealm] deleteObjects:results];
                for (int j = 0; j < playerCount; j ++) {
                    NSString * playerId = [NSString stringWithFormat:@"%d",j + 1];
                    PlayerDataModel * model = [[PlayerDataModel alloc] initWithCha:cha PlayerId:playerId];
                    [[RLMRealm defaultRealm] addObject:model];
                }
            }
        }
    [[RLMRealm defaultRealm] commitWriteTransaction];
}


@end
