//
//  GameModel.m
//  C4X1
//
//  Created by 冯宇 on 2018/10/2.
//Copyright © 2018年 冯宇. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel

+ (NSString *)primaryKey
{
    return @"ID";
}

-(instancetype)init{
    if (self = [super init]) {
        self.ID = [Tool getCurrentTimestamp];
        self.name = @"";
        self.floorCount = 0;
        self.playData = @"";
    }
    return self;
}

-(instancetype)initEmptyWithFloorCount:(int)floorCount moduleName:(NSString *)moduleName{
    if (self = [super init]) {
        self.ID = [Tool getCurrentTimestamp];
        self.name = @"";
        self.floorCount = floorCount;
        self.moduleName = moduleName;
        NSMutableArray * playerDatas = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 4; i++) {
            Player * player = [[Player alloc] init];
            [playerDatas addObject:[player createPlayerData]];
        }
        self.playData = [Tool jsonFromObj:playerDatas];
    }
    return self;
}

-(NSMutableArray *)getPlayerArr{
    NSMutableArray * playerArr = [NSMutableArray arrayWithCapacity:0];
    NSArray * arr = [Tool jsonToArr:self.playData];
    for (NSArray * stepArr in arr) {
        Player * player = [[Player alloc] initWithStepArr:stepArr];
        [playerArr addObject:player];
    }
    return playerArr;
}

+(NSString *)createPlayerDataWithPlayers:(NSMutableArray *)players
{
    NSMutableArray * playData = [NSMutableArray array];
    for (Player * player in players) {
        NSMutableArray * singleData = [player createPlayerData];
        [playData addObject:singleData];
    }
    return [Tool jsonFromObj:playData];
}

-(void)cleanEmptyPlayer{
    NSMutableArray * playerArr = [self getPlayerArr];
    NSMutableArray * deleteArr = [NSMutableArray array];
    for (Player * player in playerArr) {
        if (player.stepDatas.count == 0) {
            [deleteArr addObject:player];
        }
    }
    [playerArr removeObjectsInArray:deleteArr];
    self.playData = [GameModel createPlayerDataWithPlayers:playerArr];
}

@end
