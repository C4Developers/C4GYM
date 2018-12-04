//
//  CourseViewCell.h
//  C4gym
//
//  Created by Hinwa on 2017/12/25.
//  Copyright © 2017年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectGameCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
-(void)setCellWithName:(NSString *)name;
@end
