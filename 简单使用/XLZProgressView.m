//
//  XLZProgressView.m
//  10-导航控制器简单使用
//
//  Created by ap106872 on 16/2/26.
//  Copyright © 2016年 XiaoLinZi. All rights reserved.
//

#import "XLZProgressView.h"

@interface XLZProgressView ()

@property (nonatomic, assign) CGPoint Xcenter;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation XLZProgressView

-(CAShapeLayer *)shapeLayer
{
    if (_shapeLayer == nil) {
        
        CAShapeLayer *shape = [CAShapeLayer layer];
        
        UIBezierPath *beth = [UIBezierPath bezierPathWithArcCenter:self.Xcenter radius:self.frame.size.width - 30 * 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        
        shape.path = beth.CGPath;
        shape.lineWidth = 20;
        shape.fillColor = [UIColor clearColor].CGColor;
        shape.strokeColor = [UIColor greenColor].CGColor;
        shape.lineCap = kCALineCapRound;
        _shapeLayer = shape;
        
        [self.layer addSublayer:shape];

    }
    return _shapeLayer;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.frame.size.width - 30 * 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.path = path1.CGPath;
        shape.lineWidth = 20;
        shape.fillColor = [UIColor clearColor].CGColor;
        shape.strokeColor = [UIColor redColor].CGColor;
        
        [self.layer addSublayer:shape];
        
        _Xcenter = self.center;

    }
    return self;
}

-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    self.shapeLayer.strokeEnd = progress / 100;
}


@end
