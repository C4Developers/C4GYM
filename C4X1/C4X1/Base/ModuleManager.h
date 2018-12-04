//
//  ModuleManager.h
//  C4X1
//
//  Created by 冯宇 on 2018/11/11.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleStatus.h"

@interface ModuleManager : NSObject
@property (nonatomic, strong) ModuleStatus * module1;
@property (nonatomic, strong) ModuleStatus * module2;
@property (nonatomic, strong) ModuleStatus * module3;
@property (nonatomic, strong) ModuleStatus * module4;

+(instancetype)shareManager;
-(float)getCurrentNumWithModule:(ModuleModel *)model;
-(NSString *)getObserveTimeChangeKeyPathWithModel:(ModuleModel *)model;
-(NSString *)getObserveIsRunningKeyPathWithModel:(ModuleModel *)model;
-(void)setRunningStatusWithModule:(ModuleModel *)model isRunning:(BOOL)isRunning;
-(BOOL)getRunningStatusWithModule:(ModuleModel *)model;
-(void)startTimerWithModule:(ModuleModel *)model;
-(void)stopTimerWithModule:(ModuleModel *)model;
@end
