//
//  GameModel.h
//  C4X1
//
//  Created by 冯宇 on 2018/10/2.
//Copyright © 2018年 冯宇. All rights reserved.
//

#import <Realm/Realm.h>

@interface GameModel : RLMObject
@property NSString * ID;
@property NSString * name;
@property NSString * playData;
@property int floorCount;
@property NSString * moduleName;

-(NSMutableArray *)getPlayerArr;
+(NSString *)createPlayerDataWithPlayers:(NSMutableArray *)players;
-(instancetype)initEmptyWithFloorCount:(int)floorCount moduleName:(NSString *)moduleName;
-(void)cleanEmptyPlayer;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<GameModel>
RLM_ARRAY_TYPE(GameModel)
