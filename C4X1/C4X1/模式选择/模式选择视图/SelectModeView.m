//
//  SelectModeView.m
//  C4X1
//
//  Created by 冯宇 on 2018/9/20.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "SelectModeView.h"
#import "IntroductionView.h"
#import "RankView.h"
#import "RunningView.h"
#import "ModuleView.h"

@interface SelectModeView()
@property(nonatomic,strong)ModuleModel * model;
@property(nonatomic,strong)IntroductionView * introductionView;
@property(nonatomic,strong)RankView * rankView;
@property(nonatomic,strong)RunningView * runningView;
@property(nonatomic,strong)UIButton * timeMode;
@property(nonatomic,strong)UIButton * countMode;
@end

static float scale = 1.20;
static float oriWidth = 973;
static float oriHeight = 673;

@implementation SelectModeView

-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    float width = AD(oriWidth * scale);
    float height = AD(oriHeight * scale);
    CGRect whiteRect = CGRectMake(0, 0, width, height);
    CGRect grayRect  = CGRectMake(whiteRect.origin.x + 1,
                                  whiteRect.origin.y + 1,
                                  whiteRect.size.width - 2,
                                  whiteRect.size.height - 2);
    
    [[UIColor whiteColor] set];
    UIBezierPath * whitePath = [UIBezierPath bezierPathWithRect:whiteRect];
    CGContextAddPath(ctx, whitePath.CGPath);
    CGContextFillPath(ctx);
    
    [[UIColor colorWithRed:58/255.0f green:58/255.0f blue:58/255.0f alpha:1] set];
    UIBezierPath * grayPath = [UIBezierPath bezierPathWithRect:grayRect];
    CGContextAddPath(ctx, grayPath.CGPath);
    CGContextFillPath(ctx);
}

-(instancetype)initWithFrame:(CGRect)frame moduleModel:(ModuleModel *)model
{
    if (self = [super initWithFrame:frame]) {
        self.model = model;
        [self createIntroductionView];
        [self createRunningView];
        [self createRankView];
        [self createButton];
    }
    return self;
}

-(void)createIntroductionView
{
    @autoreleasepool{
        float width = AD(oriWidth * scale * 0.5);
        float height = AD(oriHeight * scale * 0.7);
        float x = 0;
        float y = 0;
        self.introductionView = [[IntroductionView alloc] initWithFrame:CGRectMake(x, y, width, height)  moduleModel:self.model];
        [self addSubview:self.introductionView];
    }
}

-(void)createRunningView
{
    @autoreleasepool{
        float width = AD(oriWidth * scale * 0.5);
        float height = AD(oriHeight * scale * 0.22);
        float x = CGRectGetMaxX(self.introductionView.frame);
        float y = 0;
        self.runningView = [[RunningView alloc] initWithFrame:CGRectMake(x, y, width, height) moduleModel:self.model];
        [self addSubview:self.runningView];
    }
}

-(void)createRankView{
    @autoreleasepool{
        float width = oriWidth * scale * 0.5;
        float height = oriHeight * scale * 0.78;
        float x = oriWidth * scale - width;
        float y = oriHeight * scale - height;
        self.rankView = [[RankView alloc] initWithFrame:CGRectMake(AD(x), AD(y), AD(width), AD(height)) moduleModel:self.model];
        [self addSubview:self.rankView];
    }
}

-(void)createButton
{
    @autoreleasepool{
        float startY = CGRectGetMaxY(self.introductionView.frame);
        float buttonX = AD(oriWidth * scale * 0.12);
        float buttonWidth = AD(oriWidth * scale * 0.26);
        float buttonHeight = AD(oriHeight * scale * 0.12);
        float buttonSpace = AD(oriHeight * scale * 0.02);

        self.countMode = [UIButton buttonWithType:UIButtonTypeCustom];
        self.countMode.frame = CGRectMake(buttonX, startY + buttonSpace, buttonWidth, buttonHeight);
        self.countMode.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.countMode.selected = NO;
        [self.countMode setImage:[Tool getImageWithImgName:@"未选状态----次数模式"] forState:UIControlStateNormal];
        [self.countMode setImage:[Tool getImageWithImgName:@"已选状态----次数模式"] forState:UIControlStateSelected];
        [self addSubview:self.countMode];
        
        self.timeMode = [UIButton buttonWithType:UIButtonTypeCustom];
        self.timeMode.frame = CGRectMake(buttonX, startY + buttonSpace + buttonHeight, buttonWidth, buttonHeight);
        self.timeMode.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.timeMode.selected = NO;
        [self.timeMode setImage:[Tool getImageWithImgName:@"未选状态----时间模式"] forState:UIControlStateNormal];
        [self.timeMode setImage:[Tool getImageWithImgName:@"已选状态----时间模式"] forState:UIControlStateSelected];
        [self addSubview:self.timeMode];

        @weakify(self);
        [[self.countMode rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.countMode.selected == NO) {
                self.timeMode.selected = NO;
                self.countMode.selected = YES;
                [self.runningView changeCourseType:CourseTypeCount];
                if ([self.delegate respondsToSelector:@selector(setMode:)]) {
                    [self.delegate setMode:CourseTypeCount];
                    [self.introductionView reloadView];
                }
            }
        }];
        
        [[self.timeMode rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.timeMode.selected == NO) {
                self.countMode.selected = NO;
                self.timeMode.selected = YES;
                [self.runningView changeCourseType:CourseTypeTime];
                if ([self.delegate respondsToSelector:@selector(setMode:)]) {
                    [self.delegate setMode:CourseTypeTime];
                    [self.introductionView reloadView];
                }
            }
        }];
    }
}

- (void)setDelegate:(id<ModuleDelegate>)delegate
{
    _delegate = delegate;
    _runningView.delegate = delegate;
    _rankView.delegate = delegate;
    _introductionView.delegate = delegate;
}

-(void)reloadView{
    ModuleView * moduleView = (ModuleView *)self.delegate;
    int countOrTime = [moduleView.model.countOrTime intValue];
    self.countMode.selected = countOrTime == CourseTypeCount;
    self.timeMode.selected = countOrTime == CourseTypeTime;
    [self.runningView reloadView];
}

@end
