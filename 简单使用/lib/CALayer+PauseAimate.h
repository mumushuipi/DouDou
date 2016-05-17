//
//  XLZPauseAnimation.h
//  10-导航控制器简单使用
//
//  Created by ap106872 on 16/3/2.
//  Copyright © 2016年 XiaoLinZi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (PauseAimate)

// 暂停动画
- (void)pauseAnimate;

// 恢复动画
- (void)resumeAnimate;

@end
