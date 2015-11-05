//
//  ScrollDisplayViewController.h
//  BaseProject
//
//  Created by tarena on 15/11/4.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
//使用网络图片，需要引入SDWebImage，请到下面网址下载
// https://github.com/rs/SDWebImage
//专门加载网络图片的库---第三方类库
#import <UIImageView+WebCache.h>


//SDWebImage对UIButton的类拓展
#import <UIButton+WebCache.h>

@class ScrollDisplayViewController;//定义协议
@protocol ScrollDisplayViewControllerDelegate <NSObject>
//当用户点击了某一页触发
-(void)scrollDisplayViewController:(ScrollDisplayViewController *)scrollDisplayViewController didSelectedIndex:(NSInteger)index;
@end



@interface ScrollDisplayViewController : UIViewController

/* 返回值
 instancetype：只能做返回值(更正式)
 id：可以定义对象
 */
//传入图片地址数组
-(instancetype)initWithImgPaths:(NSArray *)imgPaths;
//传入图片数组
-(instancetype)initWithImgNames:(NSArray *)imgNames;
//传入视图控制器
-(instancetype)initWithControllers:(NSArray *)controllers;

@property(nonatomic,weak)id <ScrollDisplayViewControllerDelegate>delegate;

//需要相应属性保存 图片地址、图片名、控制器（只读）
@property(nonatomic,readonly)NSArray *imgPaths;
@property(nonatomic,readonly)NSArray *imgNames;
@property(nonatomic,readonly)NSArray *controllers;

//用于展示
@property(nonatomic,readonly)UIPageViewController *pageVC;
//用于展示小圆点
@property(nonatomic,readonly)UIPageControl *pageControl;


@end
