//
//  TwoViewController.m
//  10-导航控制器简单使用
//
//  Created by xiaomage on 15/6/10.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "XLZFoldView.h"
#import "XLZFoldViews.h"
#import "XLZProgressView.h"

@interface TwoViewController ()

@end

@implementation TwoViewController
- (IBAction)jump2Three:(id)sender {
    ThreeViewController *three = [[ThreeViewController alloc] init];
    
    [self.navigationController pushViewController:three animated:YES];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    UIImage *image = [UIImage imageNamed:@"小新"];
    
    XLZFoldView *foldView = [[XLZFoldView alloc] initWithFrame:CGRectMake(100, 100, image.size.width, image.size.height) WithImage:image];
    foldView.backgroundColor = [UIColor redColor];
    [self.view addSubview:foldView];
    

    XLZFoldViews *foldViews = [[XLZFoldViews alloc] initWithFrame:CGRectMake(100, 400, image.size.width, image.size.height) WithImage:image withBars:10];
    foldViews.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:foldViews];

}


@end
