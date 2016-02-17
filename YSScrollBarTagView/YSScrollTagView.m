//
//  YSScrollTagView.m
//  YSScrollBarTagView
//
//  Created by chenfenglong on 16/2/17.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "YSScrollTagView.h"


@interface YSScrollTagView ()

@property (nonatomic,weak) UILabel *tipText;

@end

@implementation YSScrollTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self addAllSubview];
    }
    return self;
}

- (void)addAllSubview
{
    UILabel *tipText = [[UILabel alloc] init];
    tipText.layer.cornerRadius = 10;
    tipText.clipsToBounds = YES;
    tipText.font = [UIFont systemFontOfSize:14];
    tipText.textColor = [UIColor whiteColor];
    tipText.textAlignment = NSTextAlignmentCenter;
    tipText.backgroundColor = [UIColor cyanColor];
    [self addSubview:tipText];
    self.tipText = tipText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tipText.frame = self.bounds;
}

- (void)setTipContent:(NSString *)tipContent
{
    _tipContent = [tipContent copy];
    self.tipText.text = tipContent;
}

@end
