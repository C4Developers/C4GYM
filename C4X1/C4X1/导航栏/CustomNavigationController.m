//
//  CustomNavigationController.m
//  C4X1
//
//  Created by 冯宇 on 2018/9/17.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "CustomNavigationController.h"
#import "RootViewController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

+ (void)initialize
{
    //设置导航items数据主题
    [self setupNavigationItemsTheme];
    
    //设置导航栏主题
    [self setupNavigationBarTheme];
}

//导航栏按钮
+(void)setupNavigationItemsTheme{
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    //设置字体颜色
    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateHighlighted];
    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateDisabled];
}

//导航栏外观
+(void)setupNavigationBarTheme{
    //修改了这个外观对象，相当于修改了整个项目中的外观
    UINavigationBar * navBar = [UINavigationBar appearance];
    //设置导航栏title属性
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];

    //设置导航栏背景颜色
//    [navBar setBarTintColor:[UIColor cyanColor]];
    
    //设置背景图片
//    UIImage *image = [UIImage imageNamed:@"nav_64"];
//    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}

#pragma mark -  拦截所有push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
//        [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    
    [self setupNavigationItemInViewController:viewController];
    //跳转
    [super pushViewController:viewController animated:YES];
}

-(void)setupNavigationItemInViewController:(UIViewController *)viewController{
    viewController.view.backgroundColor = [UIColor whiteColor];
    viewController.title = @"C4X1";
    
    if (viewController.navigationItem.leftBarButtonItem == NULL){
        UIButton * resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [resetBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        resetBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 3, 0);
        resetBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage * normalResetImg = [Tool getImageWithImgName:@"未选状态--重置"];
        UIImage * selectResetImg = [Tool getImageWithImgName:@"已选状态--重置"];
        [resetBtn setImage:normalResetImg forState:UIControlStateNormal];
        [resetBtn setImage:selectResetImg forState:UIControlStateHighlighted];
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:resetBtn];
        viewController.navigationItem.leftBarButtonItem = left;
    }
    
    if (viewController.navigationItem.rightBarButtonItem == NULL){
        UIButton * musicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        musicBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 3, 0);
        musicBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage * normaldataImg = [Tool getImageWithImgName:@"未选状态--音乐"];
        UIImage * selectdataImg = [Tool getImageWithImgName:@"已选状态--音乐"];
        [musicBtn setImage:normaldataImg forState:UIControlStateNormal];
        [musicBtn setImage:selectdataImg forState:UIControlStateHighlighted];
        [musicBtn addTarget:self action:@selector(music) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithCustomView:musicBtn];
        viewController.navigationItem.rightBarButtonItem = right;
    }
    
    BOOL barHidden = NO;
    NSString * backgroundName = @"viewBackground";
    if ([[viewController class] isSubclassOfClass:[RootViewController class]]) {
        //首页
        barHidden = YES;
        backgroundName = @"rootBackground";
    }
    UIImage * image = [Tool getImageWithImgName:backgroundName];
    viewController.view.layer.contents = (id)image.CGImage;
    self.navigationBarHidden = barHidden;
}


#pragma mark -  拦截所有pop方法
-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    //重新设置背景
    if (self.viewControllers.count == 2) {
        self.navigationBarHidden = YES;
    }
    //这里就可以自行修改返回按钮的各种属性等
    return [super popViewControllerAnimated:YES];
}

-(void)reset{
    UIAlertController * resetAlert = [UIAlertController alertControllerWithTitle:@"设置地板地板序号" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [resetAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    for (int i = 0; i<4; i++) {
        [resetAlert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"地板%d",i+1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[SendData shareModel] sendSetIDInCha:[NSString stringWithFormat:@"%d",i+1] Success:^(NSDictionary *data) {
                [SVProgressHUD showInfoWithStatus:@"设置地板地板序号"];
            }];
        }]];
    }
    [self presentViewController:resetAlert animated:YES completion:nil];
}

-(void)music{
    UIAlertController * musicAlert = [UIAlertController alertControllerWithTitle:@"音乐" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [musicAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    for (NSString *musicName in @[@"Closer",@"Alive",@"Belong",@"Breathe"]) {
        [musicAlert addAction:[UIAlertAction actionWithTitle:musicName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [SendData shareModel].musicName = musicName;
        }]];
    }
    [self presentViewController:musicAlert animated:YES completion:nil];
}

- (void)back {
    //重新设置背景
    if (self.viewControllers.count == 2) {
        self.navigationBarHidden = YES;
    }
    //这里就可以自行修改返回按钮的各种属性等
    [super popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
