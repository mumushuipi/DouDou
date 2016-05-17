//
//  XLZFancyTabBarView.h
//  10-导航控制器简单使用
//
//  Created by ap106872 on 16/2/23.
//  Copyright © 2016年 XiaoLinZi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonSelectedIndex)(UIButton *button,NSInteger index);

@interface XLZFancyTabBarView : UIView

@property (nonatomic, copy) buttonSelectedIndex selectedButtonIndex;


- (void)setUpChoices:(NSArray*)choices;

- (void)setUpChoices:(NSArray*)choices withMainButtonImage:(NSString *)mainButtonImage;

-(void)show;

@end
