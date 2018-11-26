//
//  SelectModeView.h
//  C4X1
//
//  Created by 冯宇 on 2018/9/20.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SelectModeView : UIView
@property(nonatomic,weak)id<ModuleDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame moduleModel:(ModuleModel *)model;
-(void)reloadView;
@end
