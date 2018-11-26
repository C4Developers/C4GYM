//
//  ExtraViewCell.h
//  C4X1
//
//  Created by Hinwa on 2018/10/3.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExtraViewCell : UICollectionViewCell
-(void)setCellWithIndex:(int)index
               Selector:(SEL)sel
                 Target:(id)target
           CurrentColor:(NSString *)currentColor
              LightType:(int)lightType
               Interval:(float)interval;
@end

NS_ASSUME_NONNULL_END
