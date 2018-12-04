//
//  Game.h
//  SendData
//
//  Created by 冯宇 on 2016/12/5.
//  Copyright © 2016年 冯宇. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ModuleModel.h"
@interface GameData : NSObject
+(NSString *)createGameJsonStrWithModule:(ModuleModel *)model;
+(void)loadGameInNewGameListJson;
+(void)translate;
@end
