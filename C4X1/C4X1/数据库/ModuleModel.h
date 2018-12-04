//
//  ModuleModel.h
//  C4gym
//
//  Created by Hinwa on 2017/9/6.
//  Copyright © 2017年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import <Realm/Realm.h>
#import "GameModel.h"
@interface ModuleModel : RLMObject
//编号ID
@property NSString * cha;
//设备名
@property NSString * moduleName;
//课程
@property GameModel * game;
//人数
@property NSString * playerCount;
//模式（计次/计时）
@property NSString * countOrTime;
//计次模式-组数 计时模式-秒
@property NSString * number;
//地板个数
@property NSString * floorCount;

-(instancetype)initWithCha:(NSString *)cha;

-(NSString *)createGamePackage;

@end
