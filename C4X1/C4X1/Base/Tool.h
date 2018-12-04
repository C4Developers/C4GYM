//
//  Tool.h
//  C4X1
//
//  Created by 冯宇 on 2018/9/18.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject
+(UIImage *)getImageWithImgName:(NSString *)imgName;
+(UIViewController*)findViewController:(UIView *)view;
+(UIColor *)getColor:(NSString *)str;
+(NSString *)jsonFromObj:(id)obj;
+(NSArray *)jsonToArr:(NSString *)json;
+(NSDictionary *)jsonToDic:(NSString *)json;
+(NSString *)StringFromInt:(int)value Length:(int)length;
+ (CGFloat)getTextHeight:(NSString *)text Width:(CGFloat)width FontSize:(float)fontSize;
+(NSString*)getCurrentTimestamp;
@end
