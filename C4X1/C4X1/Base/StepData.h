//
//  StepData.h
//  C4X1
//
//  Created by 冯宇 on 2018/10/2.
//Copyright © 2018年 冯宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StepData : NSObject
@property(nonatomic,strong)NSMutableArray * floorID;
@property(nonatomic,copy)NSString * color;
@property(nonatomic,assign)int type;
@property(nonatomic,assign)float time;

- (instancetype)initWithDic:(NSDictionary *)dic;

- (instancetype)initWithFloorID:(NSMutableArray *)floorID
                          Color:(NSString *)color
                           Type:(int)type
                           Time:(float)time;
//发送的dic
-(NSDictionary *)createStepDataDic;
//展示的描述
-(NSString *)createStepDescription;
@end
