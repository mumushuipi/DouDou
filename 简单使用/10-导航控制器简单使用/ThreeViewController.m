//
//  ThreeViewController.m
//  10-导航控制器简单使用
//
//  Created by xiaomage on 15/6/10.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "ThreeViewController.h"
#import "XLZGoovButton.h"
#import "XLZFoldViews.h"
#import "XLZProgressView.h"

@interface ThreeViewController ()

@property (nonatomic, strong) XLZProgressView *progressView;

@end

@implementation ThreeViewController
// 返回上一个控制器
- (IBAction)backToPre:(id)sender {
    
    // pop不是马上把控制器销毁，而是等pop动画完成的时候才销毁
    // 回到上一个界面
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 返回到导航控制器的跟控制器
- (IBAction)back2Root:(id)sender {
    

    // 注意：只能返回到栈里面的控制器
    [self.navigationController popToViewController:self.navigationController.childViewControllers[0] animated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSLog(@"%@",self.navigationController.viewControllers);
    // topViewController 栈顶控制器
    NSLog(@"%@",self.navigationController.topViewController);
    
    
    XLZGoovButton *Button= [[XLZGoovButton alloc]initWithFrame:CGRectMake(100, 200, 20, 20)];
    Button.backgroundColor = [UIColor redColor];
    [Button setTitle:@"8" forState:UIControlStateNormal];
    [Button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Button];

    _progressView = [[XLZProgressView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _progressView.center = self.view.center;
    
    _progressView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_progressView];

}

- (IBAction)changed:(UISlider *)sender {
    
    XLZLog(@"%.1f",sender.value);
    
    _progressView.progress = sender.value;
}


-(void)click:(UIButton *)btn
{
    NSLog(@"click……");
}



@end
