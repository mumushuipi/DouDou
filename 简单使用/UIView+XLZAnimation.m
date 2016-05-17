
//
//  UIView+XLZAnimation.m
//  10-导航控制器简单使用
//
//  Created by ap106872 on 16/2/23.
//  Copyright © 2016年 XiaoLinZi. All rights reserved.
//

#import "UIView+XLZAnimation.h"

@implementation UIView (XLZAnimation)

- (void)setUpAniamtionLikeGameCenterBubble
{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 5.0;
    
    // 这段代码在真机上有问题
//    CGMutablePathRef curvedPath = CGPathCreateMutable();
//    CGRect circleContainer = CGRectInset(self.frame, self.bounds.size.width / 2 , self.bounds.size.width / 2 );
//    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
//    
//    pathAnimation.path = curvedPath;
//    CGPathRelease(curvedPath);
    [self.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
    
    
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.duration = 1;
    scaleX.values = @[@1.0, @1.1, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5, @1.0];
    scaleX.repeatCount = INFINITY;
    scaleX.autoreverses = YES;
    
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    
    
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 1.5;
    scaleY.values = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5, @1.0];
    scaleY.repeatCount = INFINITY;
    scaleY.autoreverses = YES;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
    
}

@end
