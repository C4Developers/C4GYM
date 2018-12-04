//
//  SendData.m
//  C4X1
//
//  Created by 冯宇 on 2018/10/1.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "SendData.h"
#import <AVFoundation/AVFoundation.h>

#define HEAD @"<start>"
#define TAIL @"<over>"

typedef enum {
    ReceiveReset = 1,
    ReceiveSetId = 2,
    ReceiveStartGame = 3,
    ReceiveGameData = 4,
    ReceivePauseGame = 5,
    ReceiveActiveStopGame = 6,
    ReceivePassiveStopGame = 7
}ReceiveType;

@interface SendData()<GCDAsyncSocketDelegate>{
    NSTimer *heartBeat;
}
@property(nonatomic,strong)GCDAsyncSocket * socket;
@property(nonatomic,assign)ReceiveType type;
@property(nonatomic,copy)SuccessBlock successBlock;
@property(nonatomic,copy)NSString * jsonStr;
@property(nonatomic,strong)AVAudioPlayer *audioPlayer;
@end

@implementation SendData


static SendData * single;

+(instancetype)shareModel
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[SendData alloc] init];
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
        __weak typeof(self)weakSelf = self;
        __strong id strongSelf = weakSelf;
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:strongSelf delegateQueue:dispatch_get_main_queue()];
        [self connect];
        //默认音乐
        self.musicName = @"Belong";
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.musicName ofType:@"mp3"]] error:nil];
        self.audioPlayer.numberOfLoops = -1;
        [self.audioPlayer prepareToPlay];
    }
    return self;
}

-(BOOL)connect{
    NSError * error = nil;
    return [self.socket connectToHost:@"192.168.4.1" onPort:10000 error:&error];
}

#pragma mark 连接失败
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    [heartBeat invalidate];
    heartBeat = nil;
    [self connect];
}

#pragma mark 连接成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    [self sendGetMainSta];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"socketConnectSucc" object:nil];
    @weakify(self);
    heartBeat = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        [self sendJsonStr:@"heartbeat" Success:nil];
    }];
    [[NSRunLoop currentRunLoop]addTimer:heartBeat forMode:NSRunLoopCommonModes];
    [self.socket readDataWithTimeout:-1 tag:0];
}

-(void)sendGetMainSta
{
    NSDictionary * dic = @{@"api":@"getMainSta"};
    NSString * jsonStr = [self jsonStringFromDic:dic];
    [self sendJsonStr:jsonStr Success:^(NSDictionary *data) {
        if (![data[@"flag"] isEqualToString:@"true"] ||
             [data[@"mode"] intValue] != 1) {
            [SVProgressHUD showInfoWithStatus:@"该Wifi不正确,请重新选择"];
        }
    }];
}

#pragma mark - 重启硬件
-(void)sendReset:(SuccessBlock)successBlock{
    self.type = ReceiveReset;
    NSDictionary * dic = @{@"api":@"reset"};
    NSString * jsonStr = [self jsonStringFromDic:dic];
    [self sendJsonStr:jsonStr Success:successBlock];
}

#pragma mark 设置ID
-(void)sendSetIDInCha:(NSString *)cha Success:(SuccessBlock)successBlock{
    self.type = ReceiveSetId;
    NSNumber * chaNum = [NSNumber numberWithInt:[cha intValue]];
    NSDictionary * dic = @{@"api":@"setId",
                           @"cha":chaNum};
    NSString * jsonStr = [self jsonStringFromDic:dic];
    [self sendJsonStr:jsonStr Success:successBlock];
}

#pragma mark 开始游戏
-(void)sendStartGameInCha:(NSString *)cha Success:(SuccessBlock)successBlock{
    self.type = ReceiveStartGame;
    NSNumber * chaNum = [NSNumber numberWithInt:[cha intValue]];
    NSDictionary * dic = @{@"api":@"startGame",
                           @"cha":chaNum};
    NSString * jsonStr = [self jsonStringFromDic:dic];
    [self sendJsonStr:jsonStr Success:successBlock];
}

-(void)sendGamePackage:(NSString *)jsonStr Success:(SuccessBlock)successBlock{
    self.type = ReceiveGameData;
    [self sendJsonStr:jsonStr Success:successBlock];
}

#pragma mark 暂停游戏
-(void)sendPauseGameInCha:(NSString *)cha Success:(SuccessBlock)successBlock{
    self.type = ReceivePauseGame;
    NSNumber * chaNum = [NSNumber numberWithInt:[cha intValue]];
    NSDictionary * dic = @{@"api":@"pauseGame",
                           @"cha":chaNum};
    NSString * jsonStr = [self jsonStringFromDic:dic];
    [self sendJsonStr:jsonStr Success:successBlock];
}

#pragma mark 结束游戏
-(void)sendStopGameInCha:(NSString *)cha Success:(SuccessBlock)successBlock{
    self.type = ReceiveActiveStopGame;
    NSNumber * chaNum = [NSNumber numberWithInt:[cha intValue]];
    NSDictionary * dic = @{@"api":@"stopGame",
                           @"cha":chaNum};
    NSString * jsonStr = [self jsonStringFromDic:dic];
    [self sendJsonStr:jsonStr Success:successBlock];
}


#pragma mark 流水灯
-(void)sendFloorLed:(NSArray *)ledArr Normal:(NSArray *)normalArr Success:(SuccessBlock)successBlock{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:@"setFloorLED" forKey:@"api"];
    
    for(NSString * cha in ledArr){
        [dic setObject:cha forKey:@"true"];
    };
    
    for(NSString * cha in normalArr){
        [dic setObject:cha forKey:@"false"];
    };
    
    NSString * jsonStr = [self jsonStringFromDic:dic];
    [self sendJsonStr:jsonStr Success:successBlock];
}



#pragma mark - 发送数据
-(void)sendJsonStr:(NSString *)jsonStr Success:(SuccessBlock)successBlock{
    if (!jsonStr || jsonStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"没有数据，请重设"];
        return;
    }
    
    if (jsonStr.length >= 3500) {
        [SVProgressHUD showErrorWithStatus:@"数据过大，请重设"];
        return;
    }
    
    NSData * data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    if (!data || data.length ==0) {
        [SVProgressHUD showErrorWithStatus:@"数据转换失败，请重设"];
        return;
    }
    
    [self.socket writeData:data withTimeout:-1 tag:0];
    if (successBlock) {
        self.successBlock = successBlock;
    }
}

-(NSString *)jsonStringFromDic:(NSDictionary *)dic{
    BOOL isYes = [NSJSONSerialization isValidJSONObject:dic];
    if (isYes) {
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingSortedKeys error:NULL];
        NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonStr = [NSString stringWithFormat:@"<start>%@<over>",jsonStr];
        return jsonStr;
    } else {
        NSLog(@"JSON数据生成失败，请检查数据格式");
        return nil;
    }
}

#pragma mark - 接收数据回调
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString * jsonStr = [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8];
    if (self.jsonStr) {
        jsonStr = [NSString stringWithFormat:@"%@%@",self.jsonStr,jsonStr];
    }
    
    //查找数据位置大小
    NSRange headRange = [jsonStr rangeOfString:HEAD];
    NSRange tailRange = [jsonStr rangeOfString:TAIL];
    
    //无头无尾 不处理
    if (headRange.location == NSNotFound ||
        tailRange.location == NSNotFound ){
        return;
    }
    
    int headIndex = (int)headRange.location;
    int tailIndex = (int)tailRange.location + (int)tailRange.length;
    int dataLength = tailIndex - headIndex;
    NSRange strRange = NSMakeRange(headIndex, dataLength);
    
    //长度过短 不处理
    if (jsonStr.length < tailIndex) {
        return;
    }
    
    NSString * currentStr = [jsonStr substringWithRange:strRange];
    
    if (jsonStr.length > tailIndex) {
        self.jsonStr = [jsonStr substringFromIndex:tailIndex];
    }
    else{
        self.jsonStr = @"";
    }
    
    if ([currentStr hasPrefix:HEAD] && [jsonStr hasSuffix:TAIL]) {
        //完整数据
        NSString * dataStr = [jsonStr componentsSeparatedByString:HEAD].lastObject;
        dataStr = [dataStr componentsSeparatedByString:TAIL].firstObject;
        NSData * data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"接收数据:%@",dic);
        
        if ([dic[@"api"] isEqualToString:@"stopGame"]) {
            if (self.type == ReceiveActiveStopGame) {
                self.successBlock(dic);
            }
            else{
                NSString * cha = [NSString stringWithFormat:@"%@",dic[@"cha"]];
                NSDictionary * userInfo = @{@"cha":cha};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receivePassiveStopGame" object:nil userInfo:userInfo];
            }
            if (self.audioPlayer.isPlaying) {
                [self.audioPlayer stop];
            }
        }
        else if ([dic[@"api"] isEqualToString:@"gameData"]) {
            [self handleGameData:dic];
        }
        else {
            if ([dic[@"api"] isEqualToString:@"startGame"]&&
                !self.audioPlayer.isPlaying) {
                self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.musicName ofType:@"mp3"]] error:nil];
                [self.audioPlayer play];
            }
            self.successBlock(dic);
        }
    }
    else {
        NSLog(@"数据不完整：%@",currentStr);
    }
    [self.socket readDataWithTimeout:-1 tag:0];
}

-(void)handleGameData:(NSDictionary *)dic{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([dic.allKeys containsObject:@"player"] &&
            [dic.allKeys containsObject:@"cha"] &&
            [dic.allKeys containsObject:@"times"]) {
            NSString * playerId = [NSString stringWithFormat:@"%@",dic[@"player"]];
            NSString * cha = [NSString stringWithFormat:@"%@",dic[@"cha"]];
            RLMResults * results = [PlayerDataModel objectsWhere:@"cha = %@ AND playerId = %@",cha,playerId];
            if (results.count > 0) {
                PlayerDataModel * playerData = results.firstObject;
                NSArray * times = dic[@"times"];
                [playerData addData:times];
                [playerData updateToDataBase];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveGameData" object:nil];
            }
        }
    });
}

@end
