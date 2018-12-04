//
//  PlayerDataModel.h
//  C4X1
//
//  Created by 冯宇 on 2018/10/14.
//Copyright © 2018年 冯宇. All rights reserved.
//

#import <Realm/Realm.h>

@interface PlayerDataModel : RLMObject
@property NSString *cha;
@property NSString *playerId;
@property NSString *hit;
@property NSString *time;
@property NSString *rank;
@property NSString *dataStr;
-(instancetype)initWithCha:(NSString *)cha PlayerId:(NSString *)playerId;
-(void)addData:(NSArray *)data;
-(void)updateToDataBase;
+(NSMutableArray *)getPlayerDatasWithCha:(NSString *)cha;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<PlayerDataModel>
RLM_ARRAY_TYPE(PlayerDataModel)
