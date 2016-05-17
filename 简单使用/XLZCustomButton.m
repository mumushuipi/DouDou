//
//  XLZCustomButton.m
//  10-导航控制器简单使用
//
//  Created by ap106872 on 16/2/23.
//  Copyright © 2016年 XiaoLinZi. All rights reserved.
//

#define kImageRadio 0.8

#import "XLZCustomButton.h"

@implementation XLZCustomButton

-(void)awakeFromNib
{
    [self setUp];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return  self;
}

-(void)setUp
{
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

// 重写方法取消高亮状态
-(void)setHighlighted:(BOOL)highlighted
{}

// 以后如果通过代码设置子控件的位置，一般都是在layoutSubviews里面去写
// layoutSubviews什么时候调用，只要父控件的frame一改变就会调用layoutSubviews，重新布局子控件
// 子控件:self.imageView/self.titleLabel 父控件:self
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageH = self.frame.size.height * kImageRadio;
    CGFloat imageW = self.frame.size.width;
    
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    CGFloat lableY = imageH;
    CGFloat lableH = self.frame.size.height - imageH;
    self.titleLabel.frame = CGRectMake(imageX, lableY, imageW, lableH);
}
// 文字变化 button可以自适应宽度
//- (void)setTitle:(NSString *)title forState:(UIControlState)state
//{
//    // super
//    [super setTitle:title forState:state];
//    [self sizeToFit];
//}
// 图片变化 button可以自适应宽度
//- (void)setImage:(UIImage *)image forState:(UIControlState)state
//{
//    [super setImage:image forState:state];
//    [self sizeToFit];
//}

@end
