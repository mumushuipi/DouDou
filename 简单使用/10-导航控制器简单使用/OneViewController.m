//
//  OneViewController.m
//  10-导航控制器简单使用
//
//  Created by xiaomage on 15/6/10.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "OneViewController.h"
#import "TwoViewController.h"
#import "XLZGooView.h"
#import "XLZFancyTabBarView.h"
#import "mathTools.h"

@interface OneViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIScrollView *bottomScrollView;

@property (nonatomic, strong) XLZFancyTabBarView *fancyView;

@end

@implementation OneViewController
{
    CGRect _XLZrect;
    NSInteger _preIndex;
}
// 跳转第二个控制器
- (IBAction)jump2Two:(id)sender {
    
    // 跳转
    // 如果导航控制器调用push，就会把vc添加为导航控制器的子控制器
    TwoViewController *vc = [[TwoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}
-(XLZFancyTabBarView *)fancyView
{
    if (_fancyView == nil) {
        _fancyView = [[XLZFancyTabBarView alloc]initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, self.view.frame.size.height - 400)];
        _fancyView.backgroundColor = [UIColor cyanColor];
        
        //扇形 图片/ 图片+ 文字
//        [_fancyView setUpChoices:@[@"location_go",@"location_go",@"location_go",@"location_go",@"location_go",@"location_go"] withMainButtonImage:@"main_button"];
//                [_fancyView setUpChoices:@[@{@"tabbar_compose_camera":@"拍摄"},@{@"tabbar_compose_idea":@"文字"},@{@"tabbar_compose_review":@"点评"},@{@"tabbar_compose_more":@"更多"},@{@"tabbar_compose_photo":@"相册"},@{@"tabbar_compose_lbs":@"定位"}] withMainButtonImage:@"main_button"];
        
        
        // 矩形 图片/图片+文字
//                [_fancyView setUpChoices:@[@"location_go",@"location_go",@"location_go",@"location_go",@"location_go",@"location_go"]];
        [_fancyView setUpChoices:@[@{@"tabbar_compose_camera":@"拍摄"},@{@"tabbar_compose_idea":@"文字"},@{@"tabbar_compose_review":@"点评"},@{@"tabbar_compose_more":@"更多"},@{@"tabbar_compose_photo":@"相册"},@{@"tabbar_compose_lbs":@"定位"}]];
        
        
        _fancyView.selectedButtonIndex = ^(UIButton *btn,NSInteger index){
            
            XLZLog(@"%@--%zd",btn.titleLabel.text,index);
        };
        [self.view addSubview:_fancyView];
    }
    return _fancyView;
}

- (IBAction)fancyTabBarClick:(id)sender {
    
    [self.fancyView show];
    NSLog(@"%@",self.fancyView);
}

/**
 slide控件可以添加tap手势，就是那种点一下，滑块定位到那一个点，跟拖动不一样，拖动通常分touchDown和calueChange和touchUp三种情况，第四种一般就加tap手势
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    _scrollView.center = self.view.center;
    _scrollView.backgroundColor = [UIColor greenColor];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    _scrollView.contentOffset = CGPointMake(self.view.bounds.size.width / 2, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:_scrollView];
    
    // scrollView自带一个imageView
    NSLog(@"***%zd",_scrollView.subviews.count);
    [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSLog(@"%@",obj.class);
    }];
    
    
    
    CGFloat x = 10 + _scrollView.bounds.size.width / 2;
    CGFloat y = 0;
    CGFloat w = 50;
    CGFloat h = 50;
    CGFloat margin = (_scrollView.bounds.size.width - 5 * w ) / 7;
    CGFloat centerY = _scrollView.bounds.size.height / 2;
   
    
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake( x + (margin + w) * i , y, w, h);
        CGPoint btnCenter = btn.center;
        btnCenter.y = centerY;
        btn.center = btnCenter;
        btn.backgroundColor = [UIColor magentaColor];
        btn.layer.cornerRadius = w / 2;
//        btn.layer.masksToBounds = YES;
        // 设置阴影masksToBounds 必须是NO，还必须有shadowOpacity参数
        btn.layer.shadowOffset = CGSizeMake(5, 5);
        btn.layer.shadowOpacity = 0.5;
        btn.layer.shadowColor = [UIColor redColor].CGColor;
        
        //优化： 设置shadowPath就没有离屏渲染了。
        btn.layer.shadowPath = [UIBezierPath bezierPathWithOvalInRect:btn.bounds].CGPath;
        /**
         btnClickDown 放下
         btnClickUp 起来
         */
        [btn addTarget:self action:@selector(btnClickUp:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(btnClickDown:) forControlEvents:UIControlEventTouchDown];
        btn.tag = i + 1;
        [btn setTitle:[NSString stringWithFormat:@"%zd",i + 1] forState:UIControlStateNormal];

        [_scrollView addSubview:btn];
       
    }
    
    _XLZrect = CGRectMake(self.view.center.x - (margin + w) / 2, 0, margin + w, self.view.bounds.size.height);
    UIView *view = [[UIView alloc]initWithFrame:_XLZrect];
    view.backgroundColor = [UIColor yellowColor];
    view.alpha = 0.5;
//    [self.view addSubview:view];
    
    [self changeFrameWithBlock:^(CGFloat distance) {
        
    }];
    
    XLZGooView *gooView = [[XLZGooView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
    gooView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:gooView];
    
    
   
    [self.view addSubview:self.bottomScrollView]; 
}
/**
 viewWillAppear:]
 viewWillLayoutSubviews]
 viewWillLayoutSubviews]
 viewDidAppear:]
 */
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    /**
     code 切圆角等等，写在didload会有一个渐变的过程，效果不好
     */
}


-(void)btnClickUp:(UIButton *)btn
{
    NSLog(@"btnClickUp");
}
-(void)btnClickDown:(UIButton *)btn
{
    NSLog(@"btnClickDown");
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.bottomScrollView) {
        
    }
//    self.scrollView.contentOffset = scrollView.contentOffset;
//    self.bottomScrollView.contentOffset = scrollView.contentOffset;
    [self changeFrameWithBlock:^(CGFloat distance) {
        
    }];
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        [self endBlock];
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.bottomScrollView) {
        NSInteger index = scrollView.contentOffset.x / self.view.bounds.size.width;
        
        
    }
    [self endBlock];
}

-(void)endBlock
{

    [self changeFrameWithBlock:^(CGFloat distance) {
        CGPoint point = _scrollView.contentOffset;
        point.x += distance;
        _scrollView.contentOffset = point;
    }];
}

-(void)changeFrameWithBlock:(void(^)(CGFloat distance))block
{
    [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGPoint ViewPoint = [_scrollView convertPoint:obj.center toView:self.view];
        CGFloat radius = _XLZrect.size.width / 2;
        CGPoint btnCenter = obj.center;
        
        if (CGRectContainsPoint(_XLZrect, ViewPoint) && [obj isKindOfClass:[UIButton class]]) {
            _preIndex = idx;
            
            CGFloat distance = radius -  fabs(ViewPoint.x - self.view.center.x);
    
            if (distance > 0) {
               btnCenter.y = _scrollView.bounds.size.height / 2 - distance;
            }
            
          
            obj.center = btnCenter;
            
            [UIView animateWithDuration:0.5 animations:^{
                 block(ViewPoint.x - self.view.center.x);
            }];
            
           
        }else{
            
            btnCenter.y = _scrollView.bounds.size.height / 2;
            obj.center = btnCenter;
        }
        
    }];

    
}

// 静态包使用
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"%zd",[mathTools num1:6]);
//}

-(UIScrollView *)bottomScrollView
{
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.scrollView.frame))];
        
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
        _bottomScrollView.showsVerticalScrollIndicator = NO;
        _bottomScrollView.pagingEnabled = YES;
        _bottomScrollView.bounces = NO;
        _bottomScrollView.delegate = self;
        _bottomScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 2, 0);
        
        _bottomScrollView.contentSize = CGSizeMake(_bottomScrollView.bounds.size.width * 5, _bottomScrollView.bounds.size.height);
        for (int i = 0; i < 5; i++) {
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(_bottomScrollView.bounds.size.width * i, 0, _bottomScrollView.bounds.size.width, _bottomScrollView.bounds.size.height);
            view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
            [_bottomScrollView addSubview:view];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            label.text = [NSString stringWithFormat:@"标题%zd",i + 1];
            label.textAlignment = NSTextAlignmentCenter;
            label.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
            [view addSubview:label];
        }

        
    }
    return _bottomScrollView;
}

@end
