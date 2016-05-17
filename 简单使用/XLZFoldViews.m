//
//  XLZFoldViews.m
//  10-导航控制器简单使用
//
//  Created by ap106872 on 16/2/20.
//  Copyright © 2016年 XiaoLinZi. All rights reserved.
//

#import "XLZFoldViews.h"

typedef NS_ENUM(NSInteger , XLZUpOrDownType) {
    
    XLZUpType = 0,
    XLZDownType,
};

@interface XLZFoldViews ()

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) NSInteger bars;


@property (nonatomic, strong) NSMutableArray <UIImageView *> *imageViewArr;

@end

@implementation XLZFoldViews
{
    XLZUpOrDownType XLZUpDownType;
}
-(NSMutableArray<UIImageView *> *)imageViewArr
{
    if (_imageViewArr == nil) {
        _imageViewArr = [NSMutableArray array];
    }
    return _imageViewArr;
}

-(instancetype)initWithFrame:(CGRect)frame WithImage:(UIImage *)image withBars:(NSInteger)bars
{
    if(self = [super initWithFrame:frame]){
        _image = image;
        _bars = bars;
        
        if (_bars % 2 || _bars < 4) {
            // 抛出异常
            NSException *excep = [NSException exceptionWithName:@"传入的bars不符合" reason:@"bars必须是大于等于4的偶数" userInfo:nil];
            [excep raise];
        }
        [self setSubViewWithFrame:frame];
        [self addPanGestureRecognizer];
    }
    return self;
}


-(void)setSubViewWithFrame:(CGRect)frame
{

    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat imageW = self.image.size.width ;
    CGFloat imageH = self.image.size.height / self.bars;
    
   
    for (int i = 0; i < self.bars; i++) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.frame = CGRectMake(0, 0, frame.size.width, frame.size.height / self.bars );
        // 在循环、枚举内不能使用该方法，只能用裁剪方法
//        imageV.layer.contentsRect = CGRectMake(0, i / self.bars, 1, 1 / self.bars);
        
        CGRect clipRect = CGRectMake(0, i  * imageH, imageW, imageH);
        CGImageRef imageRef = CGImageCreateWithImageInRect(self.image.CGImage, clipRect);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        imageV.image = image;
        
        imageV.layer.anchorPoint = CGPointMake(0.5, i == 0 ? 1 : 0);
        imageV.layer.position = CGPointMake(frame.size.width / 2, frame.size.height / self.bars * (i == 0 ? (i + 1) : i));
        
        imageV.tag = i + 1;
        
        // 渐变图层
        if (i !=0 && i != self.bars - 1 ) {
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.opacity = 0;
            gradientLayer.colors = i % 2 == 1 ?  @[(id)[UIColor clearColor].CGColor,(id)[UIColor darkGrayColor].CGColor] :  @[(id)[UIColor darkGrayColor].CGColor,(id)[UIColor clearColor].CGColor];
            gradientLayer.frame = imageV.bounds;
            [imageV.layer addSublayer:gradientLayer];
        }
        [self.imageViewArr addObject:imageV];
        [self addSubview:imageV];
        
    }
 
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
    CGFloat scale = transPoint.y / self.frame.size.height * (self.bars - 2);
    
    

//    CATransform3D transform = CATransform3DIdentity;
//    
//    transform.m34 = - 1 / 500;
    
    if (transPoint.y < 0 && -scale <= 1 && XLZUpDownType == XLZUpType) {
        
        CGFloat angle = scale * M_PI_2;
        
        [self changeViewWithAngle:angle withOpacity:-scale];
//        [self.imageViewArr enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//           
//            if (obj.tag != 1 && obj.tag != self.bars) {
//                
//                obj.layer.transform = CATransform3DRotate(transform,obj.tag % 2 == 0 ? angle : -angle, 1, 0, 0);
//                CAGradientLayer *layer = (CAGradientLayer *)(obj.layer.sublayers.lastObject);
//                layer.opacity = -scale;
//                
//
//            }
//            if (obj.tag > 2 ){
//                
//                UIImageView *imageV = (UIImageView *)[self viewWithTag:obj.tag - 1];
//                obj.layer.position = CGPointMake(self.frame.size.width / 2, CGRectGetMaxY(imageV.frame));
//                
//            }
//            
//        }];
        
    }
    
    if (pan.state == UIGestureRecognizerStateEnded && XLZUpDownType == XLZUpType) {
        
        
        if (transPoint.y < 0 && -scale <= 0.8) {
            
            [UIView animateWithDuration:0.2 animations:^{
                
                [self changeViewWithAngle:0 withOpacity:0];

//                [self.imageViewArr enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    
//                    if (obj.tag != 1 && obj.tag != self.bars ) {
//                        
//                        obj.layer.transform = CATransform3DIdentity;
//                        
//                        CAGradientLayer *layer = (CAGradientLayer *)(obj.layer.sublayers.lastObject);
//                        layer.opacity = 0;
//                    }
//                    
//                    if (obj.tag > 2) {
//                    
//                        obj.layer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / self.bars * (obj.tag - 1));
//                    }
//                    
//                }];
            }];
        }
        
        if(transPoint.y < 0 && -scale > 0.8){
       
            
            [self changeViewWithAngle:M_PI_2 withOpacity:1];
//            [self.imageViewArr enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                if (obj.tag != 1 && obj.tag != self.bars ) {
//                    
//                    obj.layer.transform = CATransform3DRotate(transform,obj.tag % 2 == 0 ? M_PI_2 : -M_PI_2, 1, 0, 0);
//                    CAGradientLayer *layer = (CAGradientLayer *)(obj.layer.sublayers.lastObject);
//                    layer.opacity = 1;
//                }
//                
//                if (obj.tag > 2) {
//                
//                    UIImageView *imageV = (UIImageView *)[self viewWithTag:obj.tag - 1];
//                    obj.layer.position = CGPointMake(self.frame.size.width / 2, CGRectGetMaxY(imageV.frame));
//                }
//
//            }];
 
            
        }
        XLZUpDownType = (XLZUpDownType == XLZUpType && -scale > 0.8) ? XLZDownType : XLZUpType;
        
    }

}

-(void)changeViewWithAngle:(CGFloat)angle withOpacity:(CGFloat)opacity
{
    CATransform3D transform = CATransform3DIdentity;
    
    transform.m34 = - 1 / 500;
    
    
    [self.imageViewArr enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.tag != 1 && obj.tag != self.bars) {
            
            obj.layer.transform = angle != 0 ?  CATransform3DRotate(transform,obj.tag % 2 == 0 ? angle : -angle, 1, 0, 0) : CATransform3DIdentity;
            CAGradientLayer *layer = (CAGradientLayer *)(obj.layer.sublayers.lastObject);
            layer.opacity = opacity;
            
            
        }
        if (obj.tag > 2 ){
            
            UIImageView *imageV = (UIImageView *)[self viewWithTag:obj.tag - 1];
            obj.layer.position = angle != 0 ? CGPointMake(self.frame.size.width / 2, CGRectGetMaxY(imageV.frame)) : CGPointMake(self.frame.size.width / 2, self.frame.size.height / self.bars * (obj.tag - 1));
            
        }
        
    }];
}




@end
