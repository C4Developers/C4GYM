//
//  RankDetailCell.m
//  C4X1
//
//  Created by 冯宇 on 2018/10/14.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "RankDetailCell.h"

@interface RankDetailCell()
@property(nonatomic,assign)int player;          //玩家编号
@property(nonatomic,assign)float fastestTime;   //最快反应时间
@property(nonatomic,assign)float averageTime;   //平均时间
@property(nonatomic,assign)float agility;       //敏捷度
@end

@implementation RankDetailCell
-(void)drawRect:(CGRect)rect
{
    float space = AD(30);
    
    NSMutableDictionary * attr = [NSMutableDictionary dictionaryWithCapacity:0];
    [attr setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [attr setObject:[UIFont systemFontOfSize:AD(30)] forKey:NSFontAttributeName];
    
    NSString * player = [[NSString alloc] initWithFormat:@"player%d",self.player];
    CGSize playerSize = [player sizeWithAttributes:attr];
    float playerX = space * 1.5;
    float playerY = space * 1.0;
    CGRect playerRect = CGRectMake(playerX, playerY, playerSize.width, playerSize.height);
    [player drawInRect:playerRect withAttributes:attr];
    
    NSString * min = [[NSString alloc] initWithFormat:@"最快反应时间：%.1f",self.fastestTime];
    CGSize minSize = [min sizeWithAttributes:attr];
    float minX = space * 1.5;
    float minY = CGRectGetMaxY(playerRect) + space;
    CGRect minRect = CGRectMake(minX, minY, minSize.width, minSize.height);
    [min drawInRect:minRect withAttributes:attr];
    
    NSString * mid = [[NSString alloc] initWithFormat:@"平均时间：%.1f",self.averageTime];
    CGSize midSize = [min sizeWithAttributes:attr];
    float midX = space * 1.5;
    float midY = CGRectGetMaxY(minRect) + space/3;
    CGRect midRect = CGRectMake(midX, midY, midSize.width, midSize.height);
    [mid drawInRect:midRect withAttributes:attr];
    
    NSString * max = [[NSString alloc] initWithFormat:@"敏捷度：%.1f",self.agility];
    CGSize maxSize = [min sizeWithAttributes:attr];
    float maxX = space * 1.5;
    float maxY = CGRectGetMaxY(midRect) + space/3;
    CGRect maxRect = CGRectMake(maxX, maxY, maxSize.width, maxSize.height);
    [max drawInRect:maxRect withAttributes:attr];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setCellWithPlayerData:(PlayerDataModel *)playerData{
    self.player = [playerData.playerId intValue];
    //平均值
    self.averageTime = 0;
    float sum = 0;
    float count = 0;
    float min = MAXFLOAT;
    NSArray *timeArr = [NSArray new];
    if (playerData.dataStr && playerData.dataStr.length) {
        timeArr = [Tool jsonToArr:playerData.dataStr];
    }
    for (NSArray * times in timeArr) {
        sum += [[times valueForKeyPath:@"@sum.floatValue"] floatValue];
        count += times.count;
        min = min >  [[times valueForKeyPath:@"@min.floatValue"] floatValue]?:min;
    }
    self.averageTime = sum/count;
    self.fastestTime = min == MAXFLOAT ? 0 : min;
    self.agility = [[timeArr.lastObject valueForKeyPath:@"@avg.floatValue"] floatValue] / self.averageTime;
    
    [self setNeedsDisplay];
}
@end
