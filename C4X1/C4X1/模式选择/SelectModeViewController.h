//
//  SelectModeViewController.h
//  C4X1
//
//  Created by 冯宇 on 2018/9/20.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectModeViewController : UIViewController
-(instancetype)initWithModuleModel:(ModuleModel *)model;
-(void)setModeDelegate:(id)delegate;
-(void)reloadView;
@end
