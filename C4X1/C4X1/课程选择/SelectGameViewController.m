//
//  SelectGameViewController.m
//  C4X1
//
//  Created by 冯宇 on 2018/10/1.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "SelectGameViewController.h"
#import "SelectGameView.h"
@interface SelectGameViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)SelectGameView * selectView;
@end

@implementation SelectGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self createView];
    [self addGestureRecognizer];
    [self observeReloadGameList];
}

#pragma mark  UI
-(void)createView
{
    @autoreleasepool{
        float width = AD(973 * 1.2);
        float height = AD(673 * 1.2);
        float x = (SCREEN_WIDTH - width)/2;
        float y = (SCREENH_HEIGHT - height)/2;
        CGRect rect = CGRectMake(x, y, width, height);
        self.selectView = [[SelectGameView alloc] initWithFrame:rect];
        [self.view addSubview:self.selectView];
    }
}

#pragma mark 手势
-(void)addGestureRecognizer
{
    @autoreleasepool{
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self.view addGestureRecognizer:tap];
    }
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//解决手势和tableView冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint touchPoint = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.selectView.frame, touchPoint)) {
        return NO;
    }else{
        return YES;
    }
}

-(void)observeReloadGameList
{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"reloadGameList" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self createGameArr];
    }];
}

-(void)createGameArr{
    [self.selectView createGameArr];
}

#pragma mark - 协议代理
-(void)setGameDelegate:(id)delegate{
    self.selectView.delegate = delegate;
}


@end
