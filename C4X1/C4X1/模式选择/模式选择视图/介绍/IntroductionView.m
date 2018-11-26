//
//  IntroductionVideoView.m
//  C4X1
//
//  Created by 冯宇 on 2018/9/22.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "IntroductionView.h"
#import <AVFoundation/AVFoundation.h>

@interface IntroductionView()
@property(nonatomic,strong)ModuleModel * model;
@property(nonatomic,strong)UIImageView * logo;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)UIView * textIntroduction;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *detailLabel;
@end

@implementation IntroductionView


-(instancetype)initWithFrame:(CGRect)frame moduleModel:(ModuleModel *)model
{
    if (self = [super initWithFrame:frame]) {
        self.model = model;
        [self createTextIntroduction];
    }
    return self;
}

-(void)setDelegate:(id<ModuleDelegate>)delegate
{
    _delegate = delegate;
    [self reloadView];
}

-(void)reloadView{
    ModuleView * moduleView = (ModuleView *)self.delegate;
    ModuleModel * moduleModel = moduleView.model;
    self.titleLabel.text = moduleModel.game.name;
    self.detailLabel.text = [NSString stringWithFormat:@"模块:%@",moduleModel.moduleName];
    float width = self.frame.size.width - 40;
    CGSize labelSize = [self.detailLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    self.detailLabel.frame = CGRectMake(0, 0, width, labelSize.height);
    
    //播放视频
    [self playVideo];
}

-(CGRect)videoRect
{
    float width = self.frame.size.width - 30 * 2;
    float height = self.frame.size.height - 30 - self.textIntroduction.frame.size.height;
    return CGRectMake(30, 30, width, height);
}

-(void)playVideo{
    //1.获取路径
    ModuleView * moduleView = (ModuleView *)self.delegate;
    ModuleModel * moduleModel = moduleView.model;
    NSString * videoPath = [[NSBundle mainBundle] pathForResource:[moduleModel.game.name componentsSeparatedByString:@"-"].firstObject ofType:@"mp4"];
    self.logo.hidden = videoPath != nil;
    if (videoPath) {
        //2.创建播放器
        self.player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:videoPath]]];
        //3.创建视频显示的图层
        AVPlayerLayer * layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.frame = [self videoRect];
        [self.layer addSublayer:layer];
        [self.player play];
        
        //获得播放结束的状态 AVPlayerItemDidPlayToEndTimeNotification
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem] subscribeNext:^(NSNotification * _Nullable x) {
            AVPlayerItem * avplayerItem = [x object];
            [avplayerItem seekToTime:kCMTimeZero];
            [self.player play];
        }];
    }
}

-(void)createTextIntroduction
{
    @autoreleasepool{
        UIColor * textColor = [UIColor whiteColor];
        
        float space = 20;
        
        float width = self.frame.size.width - space * 2;
        float height = AD(200);
        float y = self.height - height;
        
        self.textIntroduction = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, height)];
        
        float titleY = space / 2;
        float titleHeight = AD(50);
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleY, width, titleHeight)];
        self.titleLabel.textColor = textColor;
        self.titleLabel.font = [UIFont systemFontOfSize:AD(35)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.detailLabel = [UILabel new];
        self.detailLabel.textColor = textColor;
        self.detailLabel.font = [UIFont systemFontOfSize:AD(35)];
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //根据文字的长度返回一个最佳宽度和高度
        CGSize labelSize = [self.detailLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
        self.detailLabel.frame = CGRectMake(0, 0, width, labelSize.height);
        
        float scrollY = titleY + titleHeight + space/2;
        float scrollHeight = height - scrollY;
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(space, scrollY, width, scrollHeight)];
        scrollView.contentSize = CGSizeMake(width, labelSize.height);
        [scrollView addSubview:self.detailLabel];
        
        [self.textIntroduction addSubview:self.titleLabel];
        [self.textIntroduction addSubview:scrollView];
        [self addSubview:self.textIntroduction];
        
        
        self.logo = [[UIImageView alloc] initWithFrame:[self videoRect]];
        self.logo.contentMode = UIViewContentModeScaleAspectFill;
        self.logo.clipsToBounds = YES;
        self.logo.image = [UIImage imageNamed:@"C4Image"];
        [self addSubview:self.logo];
    }
}

@end
