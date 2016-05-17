//
//  XLZGoovButton.m
//  10-导航控制器简单使用
//
//  Created by ap106872 on 16/2/18.
//  Copyright © 2016年 XiaoLinZi. All rights reserved.
//

#import "XLZGoovButton.h"

#define MAXDISTANCE 80

@interface XLZGoovButton()

@property (nonatomic, strong) UIView *bottomView;

// 原始圆的半径
@property (nonatomic, assign) CGFloat originRadius;
// 两圆之间的距离
@property (nonatomic, assign) CGFloat diameter;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end


@implementation XLZGoovButton

-(UIView *)bottomView
{
    if (_bottomView == nil) {
        
        UIView *view = [[UIView alloc] init];
        
        view.backgroundColor = self.backgroundColor;
    
        view.bounds = self.bounds;
        view.center = self.center;
        view.layer.cornerRadius = self.frame.size.width / 2;

        _bottomView = view;
        
        [self.superview insertSubview:view belowSubview:self];
    }
    return _bottomView;
}

-(CAShapeLayer *)shapeLayer
{
    // 展示不规则矩形，通过不规则矩形路径生成一个图层
    if (_shapeLayer == nil) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        layer.fillColor = self.backgroundColor.CGColor;
        
        _shapeLayer = layer;
        
        [self.superview.layer insertSublayer:layer below:self.layer];
    }
    return _shapeLayer;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    _originRadius = self.bounds.size.width / 2;
    self.layer.cornerRadius = self.frame.size.width / 2;
    
    // 添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}


-(void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint transPoint = [pan translationInView:self.superview];
    
    CGPoint center = self.center;
    center.x += transPoint.x;
    center.y += transPoint.y;
    self.center = center;
    
    // 复位
    [pan setTranslation:CGPointZero inView:self.superview];
    
    
    // 计算两圆之间的距离
    CGFloat distance = [self distanceBetweenWithBottomViewCenter:self.bottomView.center withOriginViewCenter:self.center];
    _diameter = distance;
    CGFloat bottomRadius = _originRadius - distance / 10;
    self.bottomView.bounds = CGRectMake(0, 0, bottomRadius * 2, bottomRadius * 2);
    self.bottomView.layer.cornerRadius = bottomRadius;
    
    // 计算不规则矩形
    if (distance > MAXDISTANCE) {
        
        self.bottomView.hidden = YES;
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
        
    }else if(distance > 0 && self.bottomView.hidden == NO){
          self.shapeLayer.path = [self pathWithBottomViewCenter:self.bottomView.center withOriginViewCenter:self.center].CGPath;
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if (distance > MAXDISTANCE) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < 8; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd",i + 1]];
                [arr addObject:image];
            }
            imageView.animationImages = arr;
            imageView.animationRepeatCount = 1;
            imageView.animationDuration = 0.5;
            [imageView startAnimating];
            
            [self addSubview:imageView];
            
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
            
        }else{
            
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                [self.shapeLayer removeFromSuperlayer];
                self.shapeLayer = nil;
                self.center = self.bottomView.center;
                
            } completion:^(BOOL finished) {
                
                
            }];

        }
    }
}

-(CGFloat)distanceBetweenWithBottomViewCenter:(CGPoint)bottomCenter withOriginViewCenter:(CGPoint)originCenter
{
    CGFloat offsetX = bottomCenter.x - originCenter.x;
    CGFloat offsetY = bottomCenter.y - originCenter.y;
    
    return sqrt(offsetX * offsetX + offsetY * offsetY);
}

// 描述两圆之间一条矩形路径
- (UIBezierPath *)pathWithBottomViewCenter:(CGPoint)bottomCenter withOriginViewCenter:(CGPoint)originCenter
{
    CGFloat bottomX = bottomCenter.x;
    CGFloat bottomY = bottomCenter.y;
    CGFloat bottomR = self.bottomView.bounds.size.width / 2;
    
    CGFloat originX = originCenter.x;
    CGFloat originY = originCenter.y;
    CGFloat originR = _originRadius;
    
    CGFloat sinΘ = (originX - bottomX) / _diameter;
    CGFloat cosΘ = (originY - bottomY) / _diameter;
    
    CGPoint pointA = CGPointMake(bottomX - bottomR * cosΘ, bottomY + bottomR * sinΘ);
    CGPoint pointB = CGPointMake(bottomX + bottomR * cosΘ, bottomY - bottomR * sinΘ);
    CGPoint pointC = CGPointMake(originX + originR * cosΘ, originY - originR * sinΘ);
    CGPoint pointD = CGPointMake(originX - originR * cosΘ, originY + originR * sinΘ);
    CGPoint pointO = CGPointMake(pointA.x + _diameter / 2 * sinΘ, pointA.y + _diameter / 2 * cosΘ);
    CGPoint pointP = CGPointMake(pointB.x + _diameter / 2 * sinΘ, pointB.y + _diameter / 2 * cosΘ);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:pointA];
    // AB
    [path addLineToPoint:pointB];
    // BC 曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    // CD
    [path addLineToPoint:pointD];
    // AD 曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
    
}


@end
