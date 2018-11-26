//
//  FloorViewCell.h
//  C4gym
//
//  Created by Hinwa on 2018/4/15.
//  Copyright © 2018年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloorViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
-(void)setCellWithIndex:(int)index AndArr:(NSMutableArray *)floorArr;
@end
