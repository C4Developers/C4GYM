//
//  RankCell.h
//  C4X1
//
//  Created by 冯宇 on 2018/9/23.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankCell : UITableViewCell
-(void)setCellWithGame:(GameModel *)game width:(float)width Height:(float)height PlayerData:(PlayerDataModel *)playerData Index:(int)index Sum:(int)sum;
@end
