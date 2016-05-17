//
//  XLZGooView.m
//  10-导航控制器简单使用
//
//  Created by ap106872 on 16/2/18.
//  Copyright © 2016年 XiaoLinZi. All rights reserved.
//

#import "XLZGooView.h"

@interface XLZGooView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;


@property (nonatomic, strong) UIImageView *imageV;

@end

@implementation XLZGooView


-(UIImageView *)imageV
{
    if (_imageV == nil) {
        // 图片
        UIImageView *imageV = [[UIImageView alloc] init];
        _imageV = imageV;
        
        [self.superview.layer insertSublayer:imageV.layer below:_shapeLayer];
    }
    return _imageV;
}

-(CAShapeLayer *)shapeLayer
{
    if (_shapeLayer == nil) {
        CAShapeLayer *shape = [CAShapeLayer layer];
        
        shape.fillColor = self.backgroundColor.CGColor;
        
//        shape.fillColor = [UIColor clearColor].CGColor;
        
        _shapeLayer = shape;
        
        [self.superview.layer insertSublayer:shape below:self.layer];
        
    }
    return _shapeLayer;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

-(void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint transPoint = [pan translationInView:self.superview];

    CGPoint startPoint = CGPointZero;
    
    startPoint = [pan locationInView:self.superview];
    NSLog(@"%@",NSStringFromCGPoint(startPoint));

    
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        if (transPoint.y > 0) {
            // 计算点
            
            /**
             A     B
              o  p
               C
             
             */
            
            CGPoint pointA = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
            CGPoint pointB = CGPointMake(CGRectGetMaxX(self.frame), pointA.y);
            CGPoint pointC = CGPointMake(startPoint.x + transPoint.x, startPoint.y + transPoint.y);
            
//            CGPoint pointCFalse = CGPointMake(pointC.x, pointC.y * 8 / 9);
//            NSLog(@"***%@",NSStringFromCGPoint(pointC));
//            NSLog(@"%@",NSStringFromCGPoint(startPoint));

            // 计算O点
            
            CGFloat pointACW = pointC.x - pointA.x;
            CGFloat pointACH = pointC.y - pointA.y;
//
//            CGFloat ACLength = sqrt(pointACW * pointACW + pointACH * pointACH);
//            
//            CGFloat sinACΘ = pointACH / ACLength;
//            CGFloat cosACΘ = pointACW / ACLength;
//            
//            CGFloat pointAOH = ACLength / 2 * sinACΘ;
//            CGFloat pointAOW = ACLength / 2 * cosACΘ;
//            
//            CGPoint pointO = CGPointMake(pointA.x + pointAOW, pointA.y + pointAOH);
            
            // 计算P点
//            CGFloat pointCBW = pointB.x - pointC.x;
//            CGFloat pointCBH = pointC.y - pointB.y;
//            
//            CGFloat CBLength = sqrt(pointCBW * pointCBW + pointCBH * pointCBH);
//            
//            CGFloat sinBCΘ = pointCBH / CBLength;
//            CGFloat cosBCΘ = pointCBW / CBLength;
//            
//            CGFloat pointPH = CBLength / 2 * sinBCΘ;
//            CGFloat pointPW = CBLength / 2 * cosBCΘ;
//            
//            CGPoint pointP = CGPointMake(pointB.x - pointPW, pointB.y + pointPH);
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            [path moveToPoint:pointA];
            
            [path addLineToPoint:pointB];
            
//            [path addQuadCurveToPoint:pointCFalse controlPoint:pointP];
            
            [path addQuadCurveToPoint:pointA controlPoint:pointC];
            
            self.shapeLayer.path = path.CGPath;
            
//            // 改变图片的frame
//            CGRect rect = self.frame;
//            rect.origin = CGPointMake(self.frame.origin.x, CGRectGetMaxY(self.frame));
//            rect.size.height = transPoint.y;
//            self.imageV.frame = rect;
//            
//            // 剪裁图片
//            UIImage *image = [UIImage imageNamed:@"小新"];
//            UIBezierPath *imagePath = [UIBezierPath bezierPath];
//            
//            [imagePath moveToPoint:CGPointZero];
//            [imagePath addLineToPoint:CGPointMake(self.frame.size.width, 0)];
//            [imagePath addQuadCurveToPoint:CGPointZero controlPoint:CGPointMake(pointACW, pointACH)];
//            
//            
//            UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
//            
//            [imagePath addClip];
//            [image drawAtPoint:CGPointZero];
//            UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            
//            self.imageV.image = clipImage;
            
        }else{
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            
            CGRect rect = self.imageV.frame;
            rect.size.height = 0;
            self.imageV.frame = rect;
//            [self.imageV removeFromSuperview];
//            self.imageV = nil;

        } completion:^(BOOL finished) {
        }];
        
    }
}



@end
