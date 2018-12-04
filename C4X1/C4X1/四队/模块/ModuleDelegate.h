//
//  ModuleProtocol.h
//  C4X1
//
//  Created by 冯宇 on 2018/10/4.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModuleDelegate <NSObject,UITableViewDelegate>
@optional
-(void)setGame:(GameModel *)game;
-(void)setMode:(int)mode;
-(void)setNumber:(float)number;
-(void)sendGamePackage;
-(void)startGame;
-(void)pauseGame;
-(void)stopGame;
@required
@end
