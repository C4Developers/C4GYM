//
//  ExtraViewCell.m
//  C4X1
//
//  Created by Hinwa on 2018/10/3.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "ExtraViewCell.h"

@interface ExtraViewCell()
@property(nonatomic,strong)UIButton *extraButton;
@end

@implementation ExtraViewCell

static int actionCorner = 5;
static int colorCorner = 20;

-(UIButton *)extraButton
{
    if (!_extraButton) {
        _extraButton = [[UIButton alloc] init];
        [_extraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _extraButton.layer.cornerRadius = AD(actionCorner);
        _extraButton.layer.borderWidth = 2;
        _extraButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _extraButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _extraButton;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.extraButton];
        self.extraButton.sd_layout
        .topSpaceToView(self.contentView, AD(40))
        .bottomSpaceToView(self.contentView, AD(40))
        .leftSpaceToView(self.contentView, AD(15))
        .rightSpaceToView(self.contentView, AD(15));
    }
    return self;
}


-(void)setCellWithIndex:(int)index
               Selector:(SEL)sel
                 Target:(id)target
           CurrentColor:(NSString *)currentColor
              LightType:(int)lightType
               Interval:(float)interval
{
    [self.extraButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    self.extraButton.tag = index + 1;
    switch (self.extraButton.tag) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6: [self setLightColorButton:currentColor]; break;
        case 7: [self setLightTypeButton:lightType]; break;
        case 8: [self setIntervalButton:interval]; break;
        case 9: [self setAddStepButton]; break;
        case 10:[self setSaveButton]; break;
        default:break;
    }
}

-(void)setLightColorButton:(NSString *)currentColor
{
    NSArray * colorArr = @[@"red",@"orange",@"yellow",
                           @"green",@"blue",@"purple"];
    self.extraButton.layer.cornerRadius = AD(colorCorner);
    NSString * color = colorArr[self.extraButton.tag - 1];
    if ([color isEqualToString:@"orange"]) {
        color = @"cyan";
    }
    NSString * selName = [NSString stringWithFormat:@"%@Color",color];
    SEL colorSEL = NSSelectorFromString(selName);
    [self.extraButton setTitle:@"" forState:UIControlStateNormal];
    self.extraButton.backgroundColor = [UIColor performSelector:colorSEL withObject:nil];
    [self.extraButton setImage:nil forState:UIControlStateNormal];
    if ([color isEqualToString:currentColor]) {
        [self.extraButton setImage:[UIImage imageNamed:@"colorSelect"] forState:UIControlStateNormal];
    }
}

-(void)setLightTypeButton:(int)lightType
{
    self.extraButton.backgroundColor = [UIColor clearColor];
    self.extraButton.layer.cornerRadius = AD(actionCorner);
    [self.extraButton setImage:nil forState:UIControlStateNormal];
    NSString * typeStr = @"正常";
    switch (lightType) {
        case 1: typeStr = @"呼吸"; break;
        case 2: typeStr = @"常亮"; break;
        default: break;
    }
    [self.extraButton setTitle:typeStr forState:UIControlStateNormal];
}

-(void)setIntervalButton:(float)time
{
    self.extraButton.backgroundColor = [UIColor clearColor];
    self.extraButton.layer.cornerRadius = AD(actionCorner);
    [self.extraButton setImage:nil forState:UIControlStateNormal];
    NSString * timeStr = @"等待";
    if (time > 0) {
        timeStr = [NSString stringWithFormat:@"%.1fs",time];
    }
    [self.extraButton setTitle:timeStr forState:UIControlStateNormal];
}

-(void)setAddStepButton{
    self.extraButton.backgroundColor = [UIColor clearColor];
    self.extraButton.layer.cornerRadius = AD(actionCorner);
    self.extraButton.backgroundColor = [UIColor clearColor];
    [self.extraButton setImage:nil forState:UIControlStateNormal];
    [self.extraButton setTitle:@"加入" forState:UIControlStateNormal];
}

-(void)setSaveButton{
    self.extraButton.backgroundColor = [UIColor clearColor];
    self.extraButton.layer.cornerRadius = AD(actionCorner);
    self.extraButton.backgroundColor = [UIColor clearColor];
    [self.extraButton setImage:nil forState:UIControlStateNormal];
    [self.extraButton setTitle:@"保存" forState:UIControlStateNormal];
}

@end
