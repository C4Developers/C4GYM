//
//  RunningView.h
//  C4X1
//
//  Created by 冯宇 on 2018/9/23.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunningView : UIView

@property(nonatomic,weak)id<ModuleDelegate> delegate;

typedef NS_ENUM(int, CourseType){
    CourseTypeCount = 0,
    CourseTypeTime  = 1
};
-(instancetype)initWithFrame:(CGRect)frame moduleModel:(ModuleModel *)model;
-(void)reloadView;
-(void)changeCourseType:(CourseType)type;
@end
