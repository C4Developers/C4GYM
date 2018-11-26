//
//  ModuleStatus.h
//  C4X1
//
//  Created by 冯宇 on 2018/11/11.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModuleStatus : NSObject
@property(nonatomic,assign)BOOL isRunning;
@property(nonatomic,assign)float currentNum;
-(void)startTimerWithModule:(ModuleModel *)model;
-(void)stopTimerWithModule:(ModuleModel *)model;
@end
