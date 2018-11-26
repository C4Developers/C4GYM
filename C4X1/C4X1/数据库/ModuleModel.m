//
//  ModuleModel.m
//  C4gym
//
//  Created by Hinwa on 2017/9/6.
//  Copyright © 2017年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "ModuleModel.h"

@implementation ModuleModel

+ (NSString *)primaryKey
{
    return @"cha";
}

-(instancetype)initWithCha:(NSString *)cha
{
    if (self = [super init]) {
        self.cha = cha;
        self.moduleName = @"模块选择";
        self.game = nil;
        self.countOrTime = @"0";
        self.number = @"0";
        self.floorCount = @"0";
    }
    return self;
}

-(NSString *)createGamePackage
{
    GameModel * game = self.game;
    //频道
    int chaInt = [self.cha intValue];
    NSNumber * cha = [NSNumber numberWithInt:chaInt];
    //次数/秒
    NSNumber * number = [NSNumber numberWithFloat:[self.number floatValue]];
    //模式
    NSNumber * countOrTime = [NSNumber numberWithInt:[self.countOrTime intValue]];
    
    //数据
    NSArray * playDataArr = @[];
    if (game.playData && game.playData.length > 0) {
        playDataArr = [Tool jsonToArr:game.playData];
    }
    
    
    NSDictionary * dic = @{@"api":@"setGamePag",
                           @"cha":cha,
                           @"number":number,
                           @"countOrTime":countOrTime,
                           @"playerData":playDataArr};
    NSString * jsonStr = [Tool jsonFromObj:dic];
    
    return [NSString stringWithFormat:@"<start>%@<over>",jsonStr];
}

@end
