//
//  PlayerDataModel.m
//  C4X1
//
//  Created by 冯宇 on 2018/10/14.
//Copyright © 2018年 冯宇. All rights reserved.
//

#import "PlayerDataModel.h"
@implementation PlayerDataModel
{
    NSMutableArray * _dataArr;
}

-(instancetype)initWithCha:(NSString *)cha PlayerId:(NSString *)playerId{
    if (self = [super init]) {
        self.cha = cha;
        self.playerId = playerId;
        self.hit = @"0";
        self.time = @"0";
        self.rank = @"0";
        self.dataStr = @"";
    }
    return self;
}

-(void)addData:(NSArray *)data
{
    [self createDataArr];
    [_dataArr addObject:data];
}

-(void)createDataArr
{
    if (self.dataStr && self.dataStr.length > 0) {
        NSArray * dataArr = [Tool jsonToArr:self.dataStr];
        _dataArr = [NSMutableArray arrayWithArray:dataArr];
    }else{
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
}

-(void)updateToDataBase
{
    NSString * dataStr = [Tool jsonFromObj:_dataArr];
    [[RLMRealm defaultRealm] beginWriteTransaction];
    self.dataStr = dataStr;
    self.hit = [NSString stringWithFormat:@"%d",(int)_dataArr.count];
    self.time = [NSString stringWithFormat:@"%.1f",[self.time floatValue]+[[_dataArr.lastObject valueForKeyPath:@"@sum.floatValue"] floatValue]];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

+(NSMutableArray *)getPlayerDatasWithCha:(NSString *)cha{
    NSMutableArray * playerDatas = [NSMutableArray array];
    RLMResults * results = [PlayerDataModel objectsWhere:@"cha = %@",cha];
    [results sortedResultsUsingKeyPath:@"playerId" ascending:YES];
    for (PlayerDataModel * model in results) {
        [playerDatas addObject:model];
    }
    return playerDatas;
}

@end
