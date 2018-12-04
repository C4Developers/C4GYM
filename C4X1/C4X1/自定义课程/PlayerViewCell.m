//
//  PlayerViewCell.m
//  C4X1
//
//  Created by Hinwa on 2018/10/2.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "PlayerViewCell.h"

@interface PlayerViewCell()
@property(nonatomic,strong)UILabel *player;
@end

@implementation PlayerViewCell

-(UILabel *)player{
    if (!_player) {
        _player = [[UILabel alloc] init];
        _player.font = [UIFont boldSystemFontOfSize:AD(15)];
        _player.textAlignment = NSTextAlignmentCenter;
        _player.textColor = [UIColor whiteColor];
    }
    return _player;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.player];
        self.player.sd_layout
        .topSpaceToView(self.contentView, AD(0))
        .leftSpaceToView(self.contentView, AD(0))
        .rightSpaceToView(self.contentView, AD(0))
        .bottomSpaceToView(self.contentView, AD(0));
    }
    return self;
}

-(void)setCellWithIndex:(int)index CurrentIndex:(int)currentIndex {
    self.player.text = [NSString stringWithFormat:@"Player%d",index + 1];
    self.player.backgroundColor = index == currentIndex ? SelectColor : [UIColor clearColor];
}

@end
