//
//  SendData.h
//  C4X1
//
//  Created by 冯宇 on 2018/10/1.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(NSDictionary * data);

@interface SendData : NSObject

+(instancetype)shareModel;
@property(nonatomic,copy)NSString *musicName;
-(BOOL)connect;
-(void)sendReset:(SuccessBlock)successBlock;
-(void)sendSetIDInCha:(NSString *)cha Success:(SuccessBlock)successBlock;
-(void)sendGamePackage:(NSString *)jsonStr Success:(SuccessBlock)successBlock;
-(void)sendStartGameInCha:(NSString *)cha Success:(SuccessBlock)successBlock;
-(void)sendPauseGameInCha:(NSString *)cha Success:(SuccessBlock)successBlock;
-(void)sendStopGameInCha:(NSString *)cha Success:(SuccessBlock)successBlock;
-(void)sendFloorLed:(NSArray *)ledArr Normal:(NSArray *)normalArr Success:(SuccessBlock)successBlock;
@end
