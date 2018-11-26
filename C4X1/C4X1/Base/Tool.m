//
//  Tool.m
//  C4X1
//
//  Created by 冯宇 on 2018/9/18.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+(UIImage *)getImageWithImgName:(NSString *)imgName{
    NSBundle * bundle = [NSBundle mainBundle];
    NSString * resourcePath = [bundle pathForResource:imgName ofType:@"png"];
    UIImage * image = [UIImage imageWithContentsOfFile:resourcePath];
    return image;
}

+(UIViewController *)findViewController:(UIView *)view{
    for(UIView * nextVC = [view superview]; nextVC; nextVC = nextVC.superview)
    {
        UIResponder * nextResponder = [nextVC nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

+(NSString *)jsonFromObj:(id)obj{
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingSortedKeys error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


#pragma mark json转数组
+(NSArray *)jsonToArr:(NSString *)json{
    if (json == nil) {
        return nil;
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}

#pragma mark json转字典
+(NSDictionary *)jsonToDic:(NSString *)json{
    if (json == nil) {
        return nil;
    }
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization
                         JSONObjectWithData:jsonData
                         options:NSJSONReadingMutableContainers
                         error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(UIColor *)getColor:(NSString *)str{
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

+(NSString *)StringFromInt:(int)value Length:(int)length{
    NSString * intStr = [NSString stringWithFormat:@"%d",value];
    int originLength = (int)intStr.length;
    int addLength = length - originLength;
    NSString * add = [[NSString alloc] initWithFormat:@"%d",0];
    for(int i = 0; i < addLength ; i ++){
        intStr = [NSString stringWithFormat:@"%@%@",add,intStr];
    }
    return intStr;
}

+ (CGFloat)getTextHeight:(NSString *)text Width:(CGFloat)width FontSize:(float)fontSize{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return rect.size.height;
}

+(NSString*)getCurrentTimestamp{
    NSDate * datenow = [NSDate date];
    NSString * timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

@end
