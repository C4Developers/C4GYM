//
//  StepCell.m
//  C4X1
//
//  Created by 冯宇 on 2018/10/2.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "DescCell.h"

@interface DescCell()
@property(nonatomic,strong)UILabel * label;
@end

@implementation DescCell

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
        _label.clipsToBounds = YES;
        _label.textAlignment = NSTextAlignmentLeft;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:AD(28)];
    }
    return _label;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
        self.label.sd_layout
        .topSpaceToView(self, AD(10))
        .bottomSpaceToView(self, AD(10))
        .leftSpaceToView(self, AD(20))
        .rightSpaceToView(self, AD(20));
    }
    return self;
}

-(void)setCellWithDesc:(NSString *)desc{
    self.label.text = desc;
}

@end
