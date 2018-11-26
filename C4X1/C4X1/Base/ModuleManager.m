//
//  ModuleManager.m
//  C4X1
//
//  Created by 冯宇 on 2018/11/11.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "ModuleManager.h"

@interface ModuleManager()
@end

@implementation ModuleManager

static ModuleManager * single;

+(instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[ModuleManager alloc] init];
    });
    return single;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [super allocWithZone:zone];
    });
    return single;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.module1 = [[ModuleStatus alloc] init];
        self.module2 = [[ModuleStatus alloc] init];
        self.module3 = [[ModuleStatus alloc] init];
        self.module4 = [[ModuleStatus alloc] init];
    }
    return self;
}

-(float)getCurrentNumWithModule:(ModuleModel *)model{
    switch ([model.cha intValue]) {
        case 1: return self.module1.currentNum;
        case 2: return self.module2.currentNum;
        case 3: return self.module3.currentNum;
        case 4: return self.module4.currentNum;
        default: return 0;
    }
}

-(NSString *)getObserveKeyPathWithModel:(ModuleModel *)model key:(NSString *)key{
    NSString * keyPath = @"manager.";
    switch ([model.cha intValue]) {
        case 1: keyPath = [keyPath stringByAppendingString:@"module1."]; break;
        case 2: keyPath = [keyPath stringByAppendingString:@"module2."]; break;
        case 3: keyPath = [keyPath stringByAppendingString:@"module3."]; break;
        case 4: keyPath = [keyPath stringByAppendingString:@"module4."]; break;
        default: break;
    }
    keyPath = [keyPath stringByAppendingString:key];
    return keyPath;
}

-(NSString *)getObserveTimeChangeKeyPathWithModel:(ModuleModel *)model{
    return [self getObserveKeyPathWithModel:model key:@"currentNum"];
}

-(NSString *)getObserveIsRunningKeyPathWithModel:(ModuleModel *)model{
    return [self getObserveKeyPathWithModel:model key:@"isRunning"];
}

-(void)startTimerWithModule:(ModuleModel *)model
{
    switch ([model.cha intValue]) {
        case 1: [self.module1 startTimerWithModule:model]; break;
        case 2: [self.module2 startTimerWithModule:model]; break;
        case 3: [self.module3 startTimerWithModule:model]; break;
        case 4: [self.module4 startTimerWithModule:model]; break;
        default: break;
    }
}

-(void)stopTimerWithModule:(ModuleModel *)model
{
    switch ([model.cha intValue]) {
        case 1: [self.module1 stopTimerWithModule:model]; break;
        case 2: [self.module2 stopTimerWithModule:model]; break;
        case 3: [self.module3 stopTimerWithModule:model]; break;
        case 4: [self.module4 stopTimerWithModule:model]; break;
        default: break;
    }
}

-(void)setRunningStatusWithModule:(ModuleModel *)model isRunning:(BOOL)isRunning{
    switch ([model.cha intValue]) {
        case 1: self.module1.isRunning = isRunning; break;
        case 2: self.module2.isRunning = isRunning; break;
        case 3: self.module3.isRunning = isRunning; break;
        case 4: self.module4.isRunning = isRunning; break;
        default: break;
    }
}

-(BOOL)getRunningStatusWithModule:(ModuleModel *)model{
    switch ([model.cha intValue]) {
        case 1: return self.module1.isRunning;
        case 2: return self.module2.isRunning;
        case 3: return self.module3.isRunning;
        case 4: return self.module4.isRunning;
        default: return NO;
    }
}



@end
