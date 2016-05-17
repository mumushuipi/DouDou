//
//  mathTools.h
//  test
//
//  Created by ap106872 on 16/2/27.
//  Copyright © 2016年 xtc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mathTools : NSObject

+(NSInteger)num1:(NSInteger)num1;
/**
 release 静态包

 边调试边制作静态包
 1.新建工程
 2.TARGETS下“+“新建静态文件，可以删除自带的文件，添加自己想要的文件，写代码
   这时候TARGETS下会有自己的和新建的文件
 3.在添加第三方库的地方添加新建的静态文件.a，才能调试，不然会报错
 4.模拟器上方左边选择正常情况下的三角形，进行边调试边制作静态库
 5.在TARGETS下选中新建的文件，在copy Files下选中要暴露出去的文件
 6.最好在edit scheme 中选择release版本，注意在Build Setting 下的Build Active 下的realse为No
 7.模拟器上方左边选择小房子，分别选中真机和模拟器编译，show in finder
 8.lipo -info xxx.a打印查看信息
 9.lipo -create xxx1.a xxx2.a -output xxx3.a 
 10.xxx3.a + 暴露出的头文件  完成
 
 制作frameWork同上
 但是默认建立的是动态库，但是动态库不允许上架，所以在编译打包之前要设置
 1.在Build Setting 搜mach mach-O Type 选择static library
 2.查看合并的时候并不是查看framework，而是里面的文件，合并的时候合并这两个就行了
 
 Run edit scchme （Debug released两种，所以还要编译打包）
 一般都用release版本（视频标记为红色）
 - 调试版本会包含完整的符号信息，以方便调试
 - 调试版本不会对代码进行优化
 
 - 发布版本不会包含完整的符号信息
 - 发布版本的执行代码是进行过优化的
 - 发布版本的大小会比调试版本的略小
 - 在执行速度方面，发布版本会更快些，但不意味着会有显著的提升
 
 每一个设备都有属于自己的CPU架构(4s/6plus)
 每一个静态支持的架构是固定(liblibstatic.a)
 查看静态库支持的架构:lipo -info liblibstatic.a
 
 静态库合并:
 lipo -create 静态库1 静态库2 -output 新的静态库
 
 模拟器架构
 4s-->5 : i386
 5s-->6plus : x86_64
 
 真机CPU架构
 3gs-->4s : armv7
 5/5c : armv7s,静态库只要支持了armv7,就可以跑在armv7s的架构上
 5s-->6plus : arm64
 
 */
@end
