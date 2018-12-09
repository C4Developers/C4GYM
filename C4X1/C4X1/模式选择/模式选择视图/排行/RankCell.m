//
//  RankTableViewCell.m
//  C4X1
//
//  Created by 冯宇 on 2018/9/22.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "RankCell.h"

@interface RankCell()
@property(nonatomic,assign)int index;
@property(nonatomic,assign)int playerId;
@property(nonatomic,assign)int hit;
@property(nonatomic,assign)int sum;
@property(nonatomic,assign)float time;
@property(nonatomic,assign)int progress;
@property(nonatomic,strong)UIButton * detail;

@end


@implementation RankCell{
    //占用单位长度
    float playerUnitW;
    float hitUnitW;
    float timeUnitW;
    float rankUnitW;
    float progressUnitW;
    float detailUnitW;
    float sumUnitCount;
    
    float length;
    float cellHeight;
}

-(void)drawRect:(CGRect)rect
{
    //绘制index的背景图
    UIImage * indexBgImg = [Tool getImageWithImgName:@"top背景"];
    float indexBgHeight = length / indexBgImg.size.width * indexBgImg.size.height;
    float indexBgY = (cellHeight - indexBgHeight) / 2;
    CGRect indexRect = CGRectMake(0, indexBgY, length, indexBgHeight);
    [indexBgImg drawInRect:indexRect];
    
    //绘制进度
    NSString * progressName = [[NSString alloc] initWithFormat:@"Rank%d%%",self.progress];
    UIImage * progressImg = [Tool getImageWithImgName:progressName];
    float progressWidth = length * 3;
    float progressHeight = progressWidth / progressImg.size.width * progressImg.size.height;
    float progressY = (cellHeight - progressHeight) / 2;
    CGRect progressRect = CGRectMake(length * 4, progressY, length * 3, progressHeight);
    [progressImg drawInRect:progressRect];
    
    //绘制所有文本
//    NSString * index = [[NSString alloc] initWithFormat:@"%d",self.index];
    NSString * playerId = [[NSString alloc] initWithFormat:@"P%d",self.playerId];
    NSString * hit = [[NSString alloc]
                      initWithFormat:@"%d",self.hit];
    NSString * time = [[NSString alloc] initWithFormat:@"%.1fs",self.time];
//    NSArray * strings = @[playerId, hit, time, index];
    NSArray * strings = @[playerId, hit, time];
    
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentCenter;
    
    for (int i = 0; i < strings.count; i++) {
        NSString * str = strings[i];
        NSMutableDictionary * attrs = [NSMutableDictionary dictionaryWithCapacity:0];
        [attrs setObject:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
        [attrs setObject:style forKey:NSParagraphStyleAttributeName];
        if (i == 0) {
            [attrs setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        }else{
            [attrs setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        }
        CGSize strSize = [str
                          boundingRectWithSize:rect.size
                          options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:attrs
                          context:nil].size;
        float strY = (cellHeight - strSize.height) / 2;
        CGRect strRect = CGRectMake(length * i, strY, length, strSize.height);
        [str drawInRect:strRect withAttributes:attrs];
    }
}


-(UIButton *)detail
{
    if (!_detail) {
        _detail = [UIButton buttonWithType:UIButtonTypeCustom];
        _detail.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_detail setImage:[Tool getImageWithImgName:@"未选状态----详细数据"] forState:UIControlStateNormal];
        [_detail setImage:[Tool getImageWithImgName:@"已选状态----详细数据"] forState:UIControlStateHighlighted];
    }
    return _detail;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initData];
//        [self.contentView addSubview:self.detail];
    }
    return self;
}

-(void)initData{
    playerUnitW = 1;
    hitUnitW = 1;
    timeUnitW = 1;
    rankUnitW = 1;
    progressUnitW = 3;
    detailUnitW = 2;
    sumUnitCount = playerUnitW + hitUnitW + timeUnitW + rankUnitW + progressUnitW + detailUnitW;
}

-(void)setCellWithGame:(GameModel *)game width:(float)width Height:(float)height PlayerData:(PlayerDataModel *)playerData Index:(int)index Sum:(int)sum{
    length = width/sumUnitCount;
    cellHeight = height;
    self.detail.frame = CGRectMake(length * 7.2, 0, length * 1.5, cellHeight);
    
//    self.index = 1;
    self.playerId = index+1;
    //踩到的每一步
    self.hit = [self getCurrentHitWithGame:game playerData:playerData];
    self.sum = sum;
    self.time = [playerData.time floatValue];
    //用组去计算
    self.progress = (float)[playerData.hit intValue]/(float)(self.sum) *10;
    self.progress *= 10;
    if (self.progress >= 100) {
        self.progress = 100;
    }
    [self setNeedsDisplay];
}

-(int)getCurrentHitWithGame:(GameModel *)game playerData:(PlayerDataModel *)playerData{
    if(!game.playData || game.playData.length <= 0 ||
       !playerData.dataStr || playerData.dataStr.length <= 0){
        return 0;
    }
    
    NSArray * playDataArr = [Tool jsonToArr:game.playData];
    NSArray * steps = playDataArr.firstObject;
    NSArray * timeArr = [Tool jsonToArr:playerData.dataStr];
    
    int hit = 0;
    for (NSArray * times in timeArr) {
        for (int i = 0; i < times.count; i++) {
            //防止玩法对不上步数越界
            if(i < steps.count){
                //获取玩法中每一步的时间
                NSDictionary * step = steps[i];
                float stepTime = [step[@"time"] floatValue];
                //获取收到的时间
                float time = [times[i] floatValue];
                if (stepTime == 0) {
                    hit ++;
                }else{
                    if (time < stepTime) {
                        hit ++;
                    }
                }
            }
        }
    }
    
    return hit;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
