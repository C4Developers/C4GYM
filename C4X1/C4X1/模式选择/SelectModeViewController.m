//
//  SelectModeViewController.m
//  C4X1
//
//  Created by 冯宇 on 2018/9/20.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "SelectModeViewController.h"
#import "SelectModeView.h"

@interface SelectModeViewController()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)ModuleModel * model;
@property(nonatomic,strong)SelectModeView * selectView;
@end

@implementation SelectModeViewController

-(instancetype)initWithModuleModel:(ModuleModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizer];
    [self createView];
}

-(void)addGestureRecognizer
{
    @autoreleasepool{
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        @weakify(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            CGPoint touchPoint = [x locationInView:self.view];
            //选择区域不响应手势
            if (!CGRectContainsPoint(self.selectView.frame, touchPoint)) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        [self.view addGestureRecognizer:tap];
    }
}

-(void)createView
{
    @autoreleasepool{
        float width = AD(973 * 1.2);
        float height = AD(673 * 1.2);
        float x = (SCREEN_WIDTH - width)/2;
        float y = (SCREENH_HEIGHT - height)/2;
        CGRect rect = CGRectMake(x, y, width, height);
        self.selectView = [[SelectModeView alloc] initWithFrame:rect moduleModel:self.model];
        [self.view addSubview:self.selectView];
    }
}

-(void)setModeDelegate:(id)delegate{
    [self.selectView setDelegate:delegate];
}

-(void)reloadView{
    [self.selectView reloadView];
}

@end
