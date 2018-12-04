//
//  RootViewController.m
//  C4X1
//
//  Created by 冯宇 on 2018/9/17.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "RootViewController.h"
#import "FourTeamViewController.h"

@interface RootViewController ()
@property(nonatomic,assign)BOOL connectSucc;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserve];
    [self setupUI];
    [ModuleManager shareManager];
    [SendData shareModel];
    [GameData loadGameInNewGameListJson];
}

-(void)addObserve{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"socketConnectSucc" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.connectSucc = YES;
    }];
}


-(void)setupUI{
    UIImageView * logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"C4Image"]];
    logo.contentMode = UIViewContentModeScaleAspectFill;
    logo.clipsToBounds = YES;
    logo.layer.cornerRadius = SCREENH_HEIGHT/3/5;
    [self.view addSubview:logo];
    logo.sd_layout
    .widthIs(SCREENH_HEIGHT/3)
    .heightIs(SCREENH_HEIGHT/3)
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, SCREENH_HEIGHT/5);
    
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, AD(300), AD(80))];
    btn.layer.cornerRadius = 20;
    btn.center = CGPointMake(SCREEN_WIDTH/2, SCREENH_HEIGHT/1.5);
    btn.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    [btn setTitle:@"连接" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.connectSucc) {
            FourTeamViewController * fourTeamVC = [[FourTeamViewController alloc] init];
            [self.navigationController pushViewController:fourTeamVC animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"连接失败"];
        }
    }];
}

//-(void)setupUI{
//    UIImage * logoImg = [Tool getImageWithImgName:@"rootLogo"];
//    float logoScale = 2.0 / 3.0;
//    float logoWidth = AD(logoImg.size.width * logoScale);
//    float logoHeight = AD(logoImg.size.height * logoScale);
//    float logoY = AD(250);
//    UIImageView * logo = [[UIImageView alloc] initWithImage:logoImg];
//    [self.view addSubview:logo];
//    logo.sd_layout
//    .widthIs(logoWidth)
//    .heightIs(logoHeight)
//    .centerXEqualToView(self.view)
//    .topSpaceToView(self.view, logoY);
//
//    UIImage * normalImg = [Tool getImageWithImgName:@"未选状态---四队训练版"];
//    UIImage * selectImg = [Tool getImageWithImgName:@"已选状态---四队训练版"];
//
//    float btnScale = 2.0 / 3.0;
//    float btnWidth = AD(normalImg.size.width * btnScale);
//    float btnHeight = AD(normalImg.size.height * btnScale);
//    float btnTopToView = AD(100);
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setBackgroundImage:normalImg forState:UIControlStateNormal];
//    [btn setBackgroundImage:selectImg forState:UIControlStateHighlighted];
//    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        if (self.connectSucc) {
//            FourTeamViewController * fourTeamVC = [[FourTeamViewController alloc] init];
//            [self.navigationController pushViewController:fourTeamVC animated:YES];
//        }else{
//            [SVProgressHUD showErrorWithStatus:@"连接失败"];
//        }
//    }];
//
//    [self.view addSubview:btn];
//    btn.sd_layout
//    .widthIs(btnWidth)
//    .heightIs(btnHeight)
//    .topSpaceToView(logo, btnTopToView)
//    .centerXEqualToView(self.view);
//}

@end
