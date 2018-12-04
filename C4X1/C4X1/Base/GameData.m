//
//  Game.m
//  SendData
//
//  Created by 冯宇 on 2016/12/5.
//  Copyright © 2016年 冯宇. All rights reserved.
//

#import "GameData.h"

@implementation GameData
#pragma mark 创建发送的内容
+(NSString *)createGameJsonStrWithModule:(ModuleModel *)model{
    NSDictionary * game = [self getGameDicModule:model];
    if (game) {
        NSMutableArray * players = [self getPlayersWithGameDic:game];
        NSMutableArray * playData = [NSMutableArray arrayWithCapacity:0];
        for (Player * player in players) {
            NSMutableArray * singleData = [player createPlayerData];
            [playData addObject:singleData];
        }
        
        //次数/秒
        NSNumber * number = [NSNumber numberWithInt:[model.number intValue]];
        
        //模式
        NSNumber * countOrTime = [NSNumber numberWithInt:[model.countOrTime intValue]];
        
        NSNumber * cha = @(1);
        NSString * api = @"setGamePag";
        
        NSDictionary * dic = @{@"api":api,
                               @"cha":cha,
                               @"number":number,
                               @"countOrTime":countOrTime,
                               @"playerData":playData};
        
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingSortedKeys error:NULL];
        NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonStr = [NSString stringWithFormat:@"<start>%@<over>",jsonStr];
        
        return jsonStr;
    }
    return nil;
}

#pragma mark 在json文件找到对应字典
+(NSDictionary *)getGameDicModule:(ModuleModel *)model{
    NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"GameList" ofType:@"json"];
    NSData * data = [[NSData alloc] initWithContentsOfFile:jsonPath];
    NSDictionary * root = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString * str = [model.moduleName substringFromIndex:5];
    NSDictionary * moduleDic = root[str];
    
    int playerCount = [model.playerCount intValue];
    NSArray * gameArr;
    switch (playerCount)
    {
        case 1: gameArr = moduleDic[@"1"]; break;
        case 2: gameArr = moduleDic[@"2"]; break;
        case 3: gameArr = moduleDic[@"3"]; break;
        case 4: gameArr = moduleDic[@"4"]; break;
        default:break;
    }
    
    NSString * name = model.game.name;
    NSDictionary * game = nil;
    for (NSDictionary * dic in gameArr)
    {
        if ([dic[@"name"] isEqualToString:name])
        {
            game = dic;
            break;
        }
    }
    return game;
}

#pragma mark 创建player的数组
+(NSMutableArray *)getPlayersWithGameDic:(NSDictionary *)game
{
    NSMutableArray * players = [NSMutableArray arrayWithCapacity:0];
    
    //关联地板数
    int relationCount = [game[@"relationCount"] intValue];
    //所有玩家的所有的地板
    NSArray * usedArr = game[@"used"];
    //人数
    int playerCount = (int)usedArr.count;
    
    for (int i = 0; i < playerCount; i++) {
        NSString * color = @"White";
        switch (i) {
            case 0: color = @"Blue";break;
            case 1: color = @"Red";break;
            case 2: color = @"Green";break;
            case 3: color = @"White"; break;
            default: break;
        }
        Player * player = [[Player alloc] init];
        //第i个玩家的地板
        NSArray * jsonArr = usedArr[i];
        //判断是否关联
        if (relationCount == 0) {
            relationCount = 1;
        }
        NSArray * waitTimeArr = game[@"waitTimes"];
        for (int j=0; j<jsonArr.count/relationCount; j+=relationCount){
            int time = 0;
            NSMutableArray * floorID = [NSMutableArray arrayWithCapacity:0];
            for (int k = 0; k < relationCount; k++) {
                int intID = [jsonArr[j * relationCount + k] intValue];
                NSNumber * ID = [NSNumber numberWithInt:intID];
                [floorID addObject:ID];
                time =  [waitTimeArr[j * relationCount + k] intValue];
            }
            StepData * stepData = [[StepData alloc] initWithFloorID:floorID Color:color Type:0 Time:time];
            [player addStepData:stepData];
        }
        [players addObject:player];
    }
    return players;
}

//GameList转成新结构打印出来
+(void)translate
{
    NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"GameList" ofType:@"json"];
    NSData * data = [[NSData alloc] initWithContentsOfFile:jsonPath];
    NSDictionary * root = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //模组名字
    NSArray * modules = root.allKeys;
    for (NSString * module in modules) {
        
        NSMutableDictionary * moduleGame = [NSMutableDictionary dictionaryWithCapacity:0];
        
        NSNumber * floorCount = @(0);
        if ([module isEqualToString:@"131"]) {
            floorCount = @(5);
        }else if ([module isEqualToString:@"1x12"]) {
            floorCount = @(12);
        }else if ([module isEqualToString:@"1x3"]) {
            floorCount = @(3);
        }else if ([module isEqualToString:@"1x6"]) {
            floorCount = @(6);
        }else if ([module isEqualToString:@"1x9"]) {
            floorCount = @(9);
        }else if ([module isEqualToString:@"2x2"]) {
            floorCount = @(4);
        }else if ([module isEqualToString:@"2x3"]) {
            floorCount = @(6);
        }else if ([module isEqualToString:@"2x4"]) {
            floorCount = @(8);
        }else if ([module isEqualToString:@"2x6"]) {
            floorCount = @(12);
        }else if ([module isEqualToString:@"2x9"]) {
            floorCount = @(18);
        }else if ([module isEqualToString:@"3x3"]) {
            floorCount = @(9);
        }else if ([module isEqualToString:@"3x3x2"]) {
            floorCount = @(18);
        }
        
        //取出模组
        NSDictionary * moduleDic = root[module];
        NSArray * peoples = moduleDic.allKeys;
        NSMutableArray * gamess = [NSMutableArray array];
        //取出人数
        for (NSString * people in peoples) {
            NSArray * games = moduleDic[people];
            //取出游戏dic
            for (NSDictionary * game in games) {
                NSMutableArray * players = [self getPlayersWithGameDic:game];
                NSMutableArray * playData = [NSMutableArray arrayWithCapacity:0];
                for (Player * player in players) {
                    NSMutableArray * singleData = [player createPlayerData];
                    [playData addObject:singleData];
                }
                
                NSString * name = game[@"name"];
                name = [NSString stringWithFormat:@"%@-%@人",name,people];
                NSDictionary * dic = @{@"name":name,
                                       @"floorCount":floorCount,
                                       @"playerData":playData,
                                       @"moduleName":module};
                [gamess addObject:dic];
            }
        }
        
        NSString * floorKey = [NSString stringWithFormat:@"%@",floorCount];
        [moduleGame setValue:gamess forKey:floorKey];
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:moduleGame options:NSJSONWritingSortedKeys error:NULL];
        NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonStr);
    }
}

+(void)loadGameInNewGameListJson{
    NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"NewGameList" ofType:@"json"];
    NSData * data = [[NSData alloc] initWithContentsOfFile:jsonPath];
    NSDictionary * root = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray * floors = root.allKeys;
    int i = 0;
    [[RLMRealm defaultRealm] beginWriteTransaction];
    for (NSString * floor in floors) {
        NSArray * gameArr = root[floor];
        for (NSDictionary * game in gameArr) {
            GameModel * model = [[GameModel alloc] init];
            model.ID = [Tool StringFromInt:i Length:10];
            model.name = game[@"name"];
            model.playData = [Tool jsonFromObj:game[@"playerData"]];
            model.floorCount = [game[@"floorCount"] intValue];
            model.moduleName = game[@"moduleName"];
            [[RLMRealm defaultRealm] addOrUpdateObject:model];
            i++;
        }
    }
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

@end
