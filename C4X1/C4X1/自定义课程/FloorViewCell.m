//
//  FloorViewCell.m
//  C4gym
//
//  Created by Hinwa on 2018/4/15.
//  Copyright © 2018年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "FloorViewCell.h"

@implementation FloorViewCell

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.clipsToBounds = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:AD(25)];
        _titleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _titleLabel.layer.borderWidth = 2;
        _titleLabel.layer.cornerRadius = 10;
    }
    return _titleLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout
        .topSpaceToView(self.contentView, AD(10))
        .bottomSpaceToView(self.contentView, AD(10))
        .leftSpaceToView(self.contentView, AD(50))
        .rightSpaceToView(self.contentView, AD(50));
    }
    return self;
}

-(void)setCellWithIndex:(int)index AndArr:(NSMutableArray *)floorArr{
    NSNumber * number = [NSNumber numberWithInt:index + 1];
    self.titleLabel.backgroundColor = [floorArr containsObject:number] ?  SelectColor : [UIColor clearColor];
    self.titleLabel.text = [NSString stringWithFormat:@"地板ID:%d",index+1];
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
