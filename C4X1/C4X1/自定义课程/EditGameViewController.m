//
//  EditGameViewController.m
//  C4X1
//
//  Created by 冯宇 on 2018/10/2.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "EditGameViewController.h"
#import "EditGameView.h"

@interface EditGameViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)EditGameView *editView;
@end

@implementation EditGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizer];
    [self createView];
}

-(void)setEditGame:(GameModel *)game{
    [self.editView setEditGame:game];
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
    if (CGRectContainsPoint(self.editView.frame, touchPoint)) {
        return NO;
    }else{
        return YES;
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
        self.editView = [[EditGameView alloc] initWithFrame:rect];
        [self.view addSubview:self.editView];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
