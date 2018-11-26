//
//  CourseViewCell.m
//  C4gym
//
//  Created by Hinwa on 2017/12/25.
//  Copyright © 2017年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "SelectGameCell.h"



@implementation SelectGameCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.clipsToBounds = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:AD(25)];
        self.titleLabel.layer.cornerRadius = 10;
        self.titleLabel.layer.borderWidth = 2;
        self.titleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:self.titleLabel];
        self.titleLabel.sd_layout
        .topSpaceToView(self, AD(10))
        .bottomSpaceToView(self, AD(10))
        .leftSpaceToView(self, AD(50))
        .rightSpaceToView(self, AD(50));
    }
    return self;
}

-(void)setCellWithName:(NSString *)name{
    self.titleLabel.text = name;
    self.titleLabel.backgroundColor = [UIColor clearColor];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
