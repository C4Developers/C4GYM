//
//  RunningView.m
//  C4X1
//
//  Created by 冯宇 on 2018/9/23.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "RunningView.h"
@interface RunningView()
@property(nonatomic,strong)ModuleManager * manager;
@property(nonatomic,strong)ModuleModel * model;
@property(nonatomic,assign)int type;            //1:次数  2:时间
@property(nonatomic,assign)float number;        //单位次  单位秒
@property(nonatomic,assign)float progress;      //进度
@property(nonatomic,strong)UIButton * input;    //输入按钮
@property(nonatomic,strong)UIButton * start;    //开始按钮
@property(nonatomic,strong)UIAlertController * alert;
@end


@implementation RunningView

-(void)drawRect:(CGRect)rect
{
    float space = AD(30);
    self.progress = 100;
    
    NSString * progressName = [NSString stringWithFormat:@"Running%d%%",(int)self.progress];
    UIImage * progressImg = [Tool getImageWithImgName:progressName];
    CGRect progressRect = CGRectMake(space,
                                     space * 2,
                                     progressImg.size.width,
                                     progressImg.size.height);
    [progressImg drawInRect:progressRect];
    
    NSString * count = [NSString stringWithFormat:@"%.0f",self.number];
    if (self.manager && self.model && [self.model.countOrTime intValue] == 1) {
        if ([self.manager getRunningStatusWithModule:self.model]) {
            float currentNum = [self.manager getCurrentNumWithModule:self.model];
            count = [NSString stringWithFormat:@"%.0f",currentNum];
        }
    }
    
    NSMutableDictionary * countAttr = [NSMutableDictionary dictionaryWithCapacity:0];
    [countAttr setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [countAttr setObject:[UIFont boldSystemFontOfSize:AD(40)] forKey:NSFontAttributeName];
    CGSize countSize = [count sizeWithAttributes:countAttr];
    float countX = CGRectGetMaxX(progressRect) + space;
    float countY = CGRectGetMaxY(progressRect) - countSize.height;
    CGRect countRect = CGRectMake(countX, countY, countSize.width, countSize.height);
    [count drawInRect:countRect withAttributes:countAttr];

    NSString * typeSuffix = @"";
    if (!self.type) {
        self.type = CourseTypeCount;
    }
    switch (self.type) {
        case CourseTypeCount : typeSuffix = @"次"; break;
        case CourseTypeTime : typeSuffix = @"sec"; break;
        default: break;
    }
    NSMutableDictionary * typeAttr = [NSMutableDictionary dictionaryWithCapacity:0];
    [typeAttr setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [typeAttr setObject:[UIFont systemFontOfSize:AD(20)] forKey:NSFontAttributeName];
    CGSize typeSize = [typeSuffix sizeWithAttributes:typeAttr];
    float typeX = CGRectGetMaxX(countRect) + space/6;
    float typeY = CGRectGetMaxY(countRect) - typeSize.height;
    CGRect typeRect = CGRectMake(typeX, typeY, typeSize.width, typeSize.height);
    [typeSuffix drawInRect:typeRect withAttributes:typeAttr];
}

-(instancetype)initWithFrame:(CGRect)frame moduleModel:(ModuleModel *)model
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.manager = [ModuleManager shareManager];
        if (!self.type) {
            self.type = CourseTypeCount;
        }
        self.model = model;
        [self addSubview:self.input];
        [self addSubview:self.start];
        self.start.selected = [self.manager getRunningStatusWithModule:self.model];
        [self resetButton];
        [self observePassiveStopGame];
        [self observeTimeChange];
        [self observeRunningStatus];
    }
    return self;
}

-(void)observePassiveStopGame{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"receivePassiveStopGame" object:nil] subscribeNext:^(NSNotification * noti) {
        NSDictionary * dic = noti.userInfo;
        NSString * cha = [NSString stringWithFormat:@"%@",dic[@"cha"]];
        if ([self.model.cha isEqualToString:cha]) {
            [self.manager setRunningStatusWithModule:self.model isRunning:NO];
            self.number = [self.model.number floatValue];
            self.start.selected = NO;
            [self resetButton];
        }
    }];
}

-(void)observeTimeChange
{
    NSString * keyPath = [self.manager getObserveTimeChangeKeyPathWithModel:self.model];
    [[self rac_valuesForKeyPath:keyPath observer:self] subscribeNext:^(id  _Nullable x) {
        if ([self.model.countOrTime intValue] == 1) {
            float currentNum = [x floatValue];
            self.number = currentNum;
            [self setNeedsDisplay];
            if (currentNum <= 0) {
                [self sendStop];
            }
        }
    }];
}

-(void)observeRunningStatus{
    NSString * keyPath = [self.manager getObserveIsRunningKeyPathWithModel:self.model];
    [[self rac_valuesForKeyPath:keyPath observer:self] subscribeNext:^(id  _Nullable x) {
        self.start.selected = [x boolValue];
        [self resetButton];
    }];
}

#pragma mark - 开始按钮
-(UIButton *)start
{
    if (!_start) {
        _start = [UIButton buttonWithType:UIButtonTypeCustom];
        _start.frame = CGRectMake(AD(230), AD(120), AD(100), AD(50));
        _start.imageView.contentMode = UIViewContentModeScaleAspectFit;
        @weakify(self);
        [[_start rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.start.selected == NO) {
                if(self.number == 0 || self.number > 9999){
                    [SVProgressHUD showInfoWithStatus:@"请输入1-9999的整数"];
                }else{
                    [self sendGamePackage];
                }
                
            }else if (self.start.selected == YES){
                [self sendStop];
            }
        }];
    }
    return _start;
}

-(void)sendGamePackage{
    NSString * gamePackage = [self.model createGamePackage];
    [[SendData shareModel] sendGamePackage:gamePackage Success:^(NSDictionary *data) {
        if ([data[@"api"] isEqualToString:@"setGamePag"] &&
            [data[@"flag"] isEqualToString:@"true"]) {
            [self startGame];
        }else{
            [SVProgressHUD showErrorWithStatus:@"课程发送失败，请重试"];
        }
    }];
}

-(void)startGame{
    @weakify(self);
    [[SendData shareModel] sendStartGameInCha:self.model.cha Success:^(NSDictionary *data) {
        @strongify(self);
        if ([data[@"api"] isEqualToString:@"startGame"] &&
            [data[@"flag"] isEqualToString:@"true"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //每次开始清除数据
                [self cleanPlayerData];
                [self.manager setRunningStatusWithModule:self.model isRunning:YES];
                self.start.selected = YES;
                [self resetButton];
                if ([self.model.countOrTime intValue] == 1) {
                    [self.manager startTimerWithModule:self.model];
                }
            });
        }else{
            [SVProgressHUD showErrorWithStatus:@"课程无法开始，请重试"];
        }
    }];
}

-(void)cleanPlayerData{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    RLMResults * results = [PlayerDataModel objectsWhere:@"cha = %@",self.model.cha];
    [[RLMRealm defaultRealm] deleteObjects:results];
    for (int j = 0; j < 4; j ++) {
        NSString * playerId = [NSString stringWithFormat:@"%d",j + 1];
        PlayerDataModel * model = [[PlayerDataModel alloc] initWithCha:self.model.cha PlayerId:playerId];
        [[RLMRealm defaultRealm] addObject:model];
    }
    [[RLMRealm defaultRealm] commitWriteTransaction];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveGameData" object:nil];
}

-(void)sendStop{
    //发送停止
    @weakify(self);
    [[SendData shareModel] sendStopGameInCha:self.model.cha Success:^(NSDictionary *data) {
        @strongify(self);
        if ([data[@"api"] isEqualToString:@"stopGame"] &&
            [data[@"flag"] isEqualToString:@"true"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //获取状态 如果是计时 先暂停计时器
                if ([self.model.countOrTime intValue] == 1 &&
                    [self.manager getRunningStatusWithModule:self.model]) {
                    [self.manager stopTimerWithModule:self.model];
                }
                [self.manager setRunningStatusWithModule:self.model isRunning:NO];
                self.number = [self.model.number floatValue];
                self.start.selected = NO;
                [self resetButton];
            });
        }else{
            [SVProgressHUD showErrorWithStatus:@"课程无法结束，请重试"];
        }
    }];
}

#pragma mark - 输入
-(UIButton *)input
{
    if (!_input) {
        _input = [UIButton buttonWithType:UIButtonTypeCustom];
        _input.frame = CGRectMake(AD(30), AD(120), AD(180), AD(50));
        _input.imageView.contentMode = UIViewContentModeScaleAspectFit;
        @weakify(self);
        [[_input rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            NSString * str = @"";
            switch (self.type) {
                case CourseTypeCount: str = @"请输入次数(次)"; break;
                case CourseTypeTime: str = @"请输入时间(秒)"; break;
                default: break;
            }
            self.alert.title = str;
            __weak UIViewController * vc = [Tool findViewController:self];
            [vc presentViewController:self.alert animated:YES completion:nil];
        }];
    }
    return _input;
}

-(UIAlertController *)alert
{
    if (!_alert) {
        _alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        @weakify(self);
        //可以给alertview中添加一个输入框
        [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            @strongify(self);
            textField.placeholder = [NSString stringWithFormat:@"%.1f",self.number];
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        
        
        UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            float number = [self.alert.textFields.lastObject.text floatValue];
            if(number < 1 || number > 9999){
                [SVProgressHUD showInfoWithStatus:@"请输入1-9999的整数"];
            }else{
                self.number = (int)number;
                [self.delegate setNumber:number];
                [self setNeedsDisplay];
            }
        }];
        [_alert addAction:confirm];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [_alert addAction:cancel];
        
    }
    return _alert;
}

#pragma mark - 重置按钮
-(void)resetButton{
    @autoreleasepool {
        NSString * typeStr = @"输入次数";
        switch (self.type) {
            case CourseTypeCount: typeStr = @"输入次数"; break;
            case CourseTypeTime: typeStr = @"输入时间"; break;
            default: break;
        }
        NSString * inputNormal = [NSString stringWithFormat:@"未选状态----%@",typeStr];
        NSString * inputHightLight = [NSString stringWithFormat:@"已选状态----%@",typeStr];
        [self.input setImage:[Tool getImageWithImgName:inputNormal] forState:UIControlStateNormal];
        [self.input setImage:[Tool getImageWithImgName:inputHightLight] forState:UIControlStateHighlighted];
        
        NSString * runType = self.start.selected ? @"结束" : @"开始";
        NSString * runNormal = [NSString stringWithFormat:@"未选状态----%@",runType];
        [self.start setImage:[Tool getImageWithImgName:runNormal] forState:UIControlStateNormal];
        NSString * runHightLight = [NSString stringWithFormat:@"已选状态----%@",runType];
        if(self.start.selected){
            //select == yes 的情况要这样设置
            [self.start setImage:[Tool getImageWithImgName:runHightLight] forState:UIControlStateHighlighted | UIControlStateSelected];
        }else{
            [self.start setImage:[Tool getImageWithImgName:runHightLight] forState:UIControlStateHighlighted];
        }
    }
}

#pragma mark - 代理
-(void)setDelegate:(id<ModuleDelegate>)delegate
{
    _delegate = delegate;
}

#pragma mark 外部调用
-(void)reloadView{
    self.type = [self.model.countOrTime intValue];
    self.number = [self.model.number floatValue];
    [self setNeedsDisplay];
}

-(void)changeCourseType:(CourseType)type;
{
    self.type = type;
    [self resetButton];
    [self setNeedsDisplay];
}


@end
