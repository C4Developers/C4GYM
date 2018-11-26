//
//  ProcessViewCell.m
//  C4gym
//
//  Created by Hinwa on 2017/9/18.
//  Copyright © 2017年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "ProcessViewCell.h"

@interface ProcessViewCell()
@property(nonatomic,strong)UILabel *titleLabel;
@end

@implementation ProcessViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout
        .topSpaceToView(self.contentView, AD(10))
        .bottomSpaceToView(self.contentView, AD(10))
        .leftSpaceToView(self.contentView, AD(50))
        .rightSpaceToView(self.contentView, AD(50));
    }
    return self;
}

-(void)setCellWithStep:(StepData *)step{
    if (step.floorID.count == 1) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@",step.floorID.firstObject];
    }
    else {
        self.titleLabel.text = [step.floorID componentsJoinedByString:@"-"];
    }

    if (step.time>0) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@   %.1fs",self.titleLabel.text,step.time];
    }
    else {
        self.titleLabel.text = [NSString stringWithFormat:@"%@   等待",self.titleLabel.text];
    }

    switch (step.type) {
        case 0:
            self.titleLabel.text = [NSString stringWithFormat:@"%@   正常",self.titleLabel.text];
            break;
        case 1:
            self.titleLabel.text = [NSString stringWithFormat:@"%@   呼吸",self.titleLabel.text];
            break;
        default:
            self.titleLabel.text = [NSString stringWithFormat:@"%@   常亮",self.titleLabel.text];
            break;
    }

    if ([step.color isEqualToString:@"red"]) {
        self.titleLabel.backgroundColor = [UIColor redColor];
    }
    else if ([step.color isEqualToString:@"orange"]) {
        self.titleLabel.backgroundColor = [UIColor orangeColor];
    }
    else if ([step.color isEqualToString:@"yellow"]) {
        self.titleLabel.backgroundColor = [UIColor yellowColor];
    }
    else if ([step.color isEqualToString:@"green"]) {
        self.titleLabel.backgroundColor = [UIColor greenColor];
    }
    else if ([step.color isEqualToString:@"blue"]) {
        self.titleLabel.backgroundColor = [UIColor blueColor];
    }
    else if ([step.color isEqualToString:@"purple"]) {
        self.titleLabel.backgroundColor = [UIColor purpleColor];
    }
    else {
        self.titleLabel.backgroundColor = [UIColor whiteColor];
    }
}

@end
