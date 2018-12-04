//
//  IntroductionView.h
//  C4X1
//
//  Created by 冯宇 on 2018/9/22.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectGameView : UIView
@property(nonatomic,weak)id <ModuleDelegate> delegate;
-(void)createGameArr;
@end
