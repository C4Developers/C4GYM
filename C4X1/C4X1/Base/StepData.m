//
//  StepData.m
//  C4X1
//
//  Created by 冯宇 on 2018/10/2.
//Copyright © 2018年 冯宇. All rights reserved.
//

#import "StepData.h"

@implementation StepData

-(instancetype)init
{
    if (self = [super init]) {
        self.floorID = [NSMutableArray arrayWithCapacity:0];
        self.color = @"Blue";
        self.type = 1;
        self.time = 0;
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.floorID = [NSMutableArray arrayWithArray:dic[@"floorID"]];
        self.color = dic[@"color"];
        self.type = [dic[@"type"] intValue];
        self.time = [dic[@"time"] floatValue];
    }
    return self;
}

- (instancetype)initWithFloorID:(NSMutableArray *)floorID
                          Color:(NSString *)color
                           Type:(int)type
                           Time:(float)time
{
    self = [super init];
    if (self) {
        self.floorID = floorID;
        self.color = color;
        self.type = type;
        self.time = time;
    }
    return self;
}

-(NSDictionary *)createStepDataDic
{
    return @{@"floorID":self.floorID,
             @"color":self.color,
             @"type":[NSNumber numberWithInt:self.type],
             @"time":[NSNumber numberWithFloat:self.time]};
}

-(NSString *)createStepDescription{
    NSString * floorStr = @"地板:";
    for (NSNumber * floor in self.floorID) {
        floorStr = [NSString stringWithFormat:@"%@ %@",floorStr,floor];
    }
    
    NSString * timeStr = @"一直等待";
    if (self.time != 0) {
        timeStr = [NSString stringWithFormat:@"等待时间:%.1fs",self.time];
    }
    
    NSString * typeStr = @"";
    switch (self.type) {
        case 0 : typeStr = @"正常"; break;
        case 1 : typeStr = @"流水灯"; break;
        case 2 : typeStr = @"常亮"; break;
        default: break;
    }
    typeStr = [NSString stringWithFormat:@"效果:%@",typeStr];
    NSString * description = [NSString stringWithFormat:@"%@    %@  %@",floorStr,timeStr,typeStr];
    
    return description;
}

@end
