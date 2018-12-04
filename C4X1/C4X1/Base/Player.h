//
//  Player.h
//  C4X1
//
//  Created by 冯宇 on 2018/10/2.
//Copyright © 2018年 冯宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StepData.h"
@interface Player : NSObject
@property(nonatomic,strong)NSMutableArray * stepDatas;
//根据json初始化
-(instancetype)initWithStepArr:(NSArray *)stepArr;
//添加
-(void)addStepData:(StepData *)stepData;
//删除
-(void)removeStepDataAtIndex:(int)index;
//清空
-(void)removeAllStepData;
//交换
-(void)exchangeStepDataAtIndex:(int)index1 withObjectAtIndex:(int)index2;
//发送的数据
-(NSMutableArray *)createPlayerData;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Player>
RLM_ARRAY_TYPE(Player)
