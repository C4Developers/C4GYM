//
//  ModuleView.h
//  C4X1
//
//  Created by 冯宇 on 2018/10/1.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModuleView : UIView
@property(nonatomic,strong)ModuleModel * model;
-(void)reloadView;
@end


