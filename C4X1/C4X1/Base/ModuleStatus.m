//
//  ModuleStatus.m
//  C4X1
//
//  Created by 冯宇 on 2018/11/11.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "ModuleStatus.h"

@interface ModuleStatus()
@property(nonatomic, strong) dispatch_source_t timer;
@end

@implementation ModuleStatus
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isRunning = NO;
        [self timer];
    }
    return self;
}

-(void)startTimerWithModule:(ModuleModel *)model{
    self.currentNum = [model.number floatValue];
    float setTime = [model.number floatValue];
    __block float time = 0;
    @weakify(self);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        @strongify(self);
        if (time < setTime) {
            self.currentNum = setTime - time;
            time ++;
        }else{
            self.currentNum = 0;
            if(self.timer){
                dispatch_cancel(self.timer);
                self.timer = nil;
            }
            [[SendData shareModel] sendStopGameInCha:model.cha Success:^(NSDictionary *data) {
                self.isRunning = NO;
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.currentNum = [model.number floatValue];
            });
        }
    });
    dispatch_resume(self.timer);
}

-(void)stopTimerWithModule:(ModuleModel *)model{
    float setTime = [model.number floatValue];
    self.currentNum = setTime;
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}

@end
