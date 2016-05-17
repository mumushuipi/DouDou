//
//  XLZNavigationController.m
//  10-导航控制器简单使用
//
//  Created by ap106872 on 16/3/2.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

#import "XLZNavigationController.h"

@interface XLZNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation XLZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ios7
    // 取消系统自带的手势
    self.interactivePopGestureRecognizer.enabled = NO;
    // 添加自己的手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 如果栈顶控制器不是第一个控制器就返回yes，也就是栈底控制器返回no，没有手势
    return (self.topViewController != [self.viewControllers firstObject]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
