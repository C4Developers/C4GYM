//
//  Player.m
//  C4X1
//
//  Created by 冯宇 on 2018/10/2.
//Copyright © 2018年 冯宇. All rights reserved.
//

#import "Player.h"

@implementation Player

-(instancetype)init{
    if (self = [super init]) {
        self.stepDatas = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

-(instancetype)initWithStepArr:(NSArray *)stepArr{
    if (self = [super init]) {
        self.stepDatas = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary * stepDic in stepArr) {
            StepData * stepData = [[StepData alloc] initWithDic:stepDic];
            [self.stepDatas addObject:stepData];
        }
    }
    return self;
}

-(void)addStepData:(StepData *)stepData{
    if(self.stepDatas){
        [self.stepDatas addObject:stepData];
    }
}

-(void)removeStepDataAtIndex:(int)index
{
    if(index < self.stepDatas.count){
        [self.stepDatas removeObjectAtIndex:index];
    }
}

-(void)removeAllStepData{
    [self.stepDatas removeAllObjects];
}

-(void)exchangeStepDataAtIndex:(int)index1 withObjectAtIndex:(int)index2{
    if (index1 < self.stepDatas.count && index2 < self.stepDatas.count) {
        [self.stepDatas exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
    }
}

-(NSMutableArray *)createPlayerData{
    NSMutableArray * playerData = [NSMutableArray arrayWithCapacity:0];
    for (StepData * stepData in self.stepDatas) {
        NSDictionary * stepDic = [stepData createStepDataDic];
        [playerData addObject:stepDic];
    }
    return playerData;
}

@end
