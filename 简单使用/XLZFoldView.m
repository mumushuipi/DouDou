//
//  XLZFoldView.m
//  10-导航控制器简单使用
//
//  Created by ap106872 on 16/2/18.
//  Copyright © 2016年 XiaoLinZi. All rights reserved.
//

#import "XLZFoldView.h"

@interface XLZFoldView ()

@property (nonatomic, strong) UIImageView *topView;

@property (nonatomic, strong) UIImageView *bottomView;

@property (nonatomic, strong) UIView *referView;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation XLZFoldView

-(instancetype)initWithFrame:(CGRect)frame WithImage:(UIImage *)image
{
    if (self = [super initWithFrame:frame]) {
        
        _image = image;
  
        [self setSubViewWithFrame:frame];
        [self addPanGestureRecognizer];
    }
    return self;
}

-(void)setSubViewWithFrame:(CGRect)frame
{
    // 要先放底部，再放顶部，不然会出现旋转180°的只有90°的感觉
    UIImageView *bottom = [[UIImageView alloc] initWithImage:_image];
    bottom.frame = CGRectMake(0, 0, frame.size.width , frame.size.height / 2);
    bottom.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
    bottom.layer.anchorPoint = CGPointMake(0.5, 0);
    bottom.layer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    _bottomView = bottom;
    [self addSubview:bottom];
    
    UIImageView *top = [[UIImageView alloc] initWithImage:_image];
    top.frame = CGRectMake(0, 0, frame.size.width, frame.size.height / 2);
    top.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    top.layer.anchorPoint = CGPointMake(0.5, 1);
    top.layer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);

    _topView = top;
    [self addSubview:top];
    
//    UIView *refer = [[UIView alloc] init];
//    refer.frame = frame;
//    _referView = refer;
//    [self addSubview:refer];
    // 渐变图层
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.opacity = 0;
    gradient.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor darkGrayColor].CGColor];
    gradient.frame = _bottomView.bounds;
    _gradientLayer = gradient;
    [_bottomView.layer addSublayer:gradient];
    
}


-(void)addPanGestureRecognizer
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:pan];
}

-(void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint transPoint = [pan translationInView:self];
    
    if (transPoint.y > 0) {
        // 旋转角度,往下逆时针旋转
        CGFloat angle = -transPoint.y / _bottomView.bounds.size.height * M_PI;
        
        CATransform3D transform = CATransform3DIdentity;
        // 增加旋转的立体感，近大远小,d：距离图层的距离
        transform.m34 = - 1 / 500;
        
        _topView.layer.transform = CATransform3DRotate(transform, angle, 1, 0, 0);
        // 设置阴影效果
        _gradientLayer.opacity = transPoint.y / _bottomView.bounds.size.height;
    }
    
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        // SpringWithDamping:弹性系数,越小，弹簧效果越明显
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _topView.layer.transform = CATransform3DIdentity;
            
            _gradientLayer.opacity = 0;
            
        } completion:^(BOOL finished) {
            
        }];
    }
//    [pan setTranslation:CGPointZero inView:self];
}

@end
