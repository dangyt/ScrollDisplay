//
//  ScrollDisplayViewController.m
//  BaseProject
//
//  Created by tarena on 15/11/4.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "ScrollDisplayViewController.h"

@interface ScrollDisplayViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@end

@implementation ScrollDisplayViewController



-(instancetype)initWithImgNames:(NSArray *)imgNames
{
// 图片名字-->image-->imageView-->viewController
        NSMutableArray *arr = [NSMutableArray new];//存放vc
        for (int i= 0; i < imgNames.count; i++) {
            UIImage *img = [UIImage imageNamed:imgNames[i]];
            UIButton *btn = [UIButton buttonWithType:0];
            [btn setBackgroundImage:img forState:0];

            UIViewController *vc = [UIViewController new];
            vc.view = btn;
            btn.tag = 1000+i;
            [btn bk_addEventHandler:^(UIButton *sender) {
                [self.delegate scrollDisplayViewController:self didSelectedIndex:sender.tag-1000];
            } forControlEvents:UIControlEventTouchUpInside];
            
            [arr addObject:vc];
        }
    if (self = [self initWithControllers:arr]) {
        
    }
        
    return self;
}

-(BOOL)isURL:(id)path //是否是URL地址
{
    return [path isKindOfClass:[NSURL class]];
}
- (BOOL)isNetPath:(id)path //判断是否是网络路径
{
    // http://   https://
    BOOL isStr=[path isKindOfClass:[NSString class]];
    //为了防止非String类型调用下方崩溃，非string没有rangeOfString方法
    if (!isStr) {
        return NO;
    }
    BOOL containHttp=[path rangeOfString:@"http"].location != NSNotFound;
    BOOL containTile=[path rangeOfString:@"://"].location != NSNotFound;
    return isStr && containHttp && containTile;
}
-(instancetype)initWithImgPaths:(NSArray *)imgPaths
{
//路径中可能的类型：NSURL,Http://,https:// ,本地路径：file://
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < imgPaths.count; i ++)
    {
        id path = imgPaths[i];
        //为了监控用户当前点击的是哪个图片,用button来显示图片(监测点击方法)
        UIButton *btn = [UIButton buttonWithType:0];
        if ([self isURL:path]) {
            [btn sd_setBackgroundImageWithURL:path forState:0];
        }else if([self isNetPath:path]){
            NSURL *url = [NSURL URLWithString:path];
            [btn sd_setBackgroundImageWithURL:url forState:0];
        }else if([path isKindOfClass:[NSString class]]){
//     本地地址
            NSURL *url = [NSURL fileURLWithPath:path];
            [btn sd_setBackgroundImageWithURL:url forState:0];
        }else{
//   这里可以给imageView 设置一个裂开的本地图片
             [btn setImage:[UIImage imageNamed:@"error@3x"] forState:0];
        }
        UIViewController *vc = [UIViewController new];
        vc.view = btn;
        btn.tag = 1000+i;
        [btn bk_addEventHandler:^(UIButton *sender) {
            [self.delegate scrollDisplayViewController:self didSelectedIndex:sender.tag-1000];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [arr addObject:vc];
    }
    self = [self initWithControllers:arr];
    return self;
}

-(instancetype)initWithControllers:(NSArray *)controllers
{
    if (self = [super init]) {
// 为了防止实参是可变数组，需要复制一份出来。这样可以保证属性不会因为可变数组不会因为可变数组在外部被修改，而导致随之改变了
        _controllers = [controllers copy];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//如果 控制器数组 为空 或者什么都没有
    if (!_controllers || _controllers.count == 0) {
        return;
    }
    
// style：1代表scroll（滚动）形式，navigationOrientation:0代表横向
    _pageVC = [[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    [self addChildViewController:_pageVC];
//添加翻页的视图(滚动视图)
    [self.view addSubview:_pageVC.view];
//添加约束---(需要用pod引入 Masonry 第三方类库)
    [_pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
//设置滚动视图的初始页面
    [_pageVC setViewControllers:@[_controllers.firstObject] direction:0 animated:YES completion:nil];
//页面上的小圆点
    _pageControl = [UIPageControl new];
    _pageControl.numberOfPages = _controllers.count;
    [self.view addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(0);
    }];
    //不让用户点击小圆点
    _pageControl.userInteractionEnabled = NO;
}

//配置小圆点的位置
-(void)configPageControl
{
    NSInteger index = [_controllers indexOfObject:_pageVC.viewControllers.firstObject];
    _pageControl.currentPage = index;
}

#pragma mark - UIPageViewController 协议中必须实现的方法
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed && finished) {
        [self configPageControl];
    }
}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{//获取当前的索引
    NSInteger index = [_controllers indexOfObject:viewController];
    if (index == 0) {
        return _controllers.lastObject;
    }
    return _controllers[index-1];
}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
   NSInteger index = [_controllers indexOfObject:viewController];
    if (index == _controllers.count-1) {
        return _controllers.firstObject;
    }
    return _controllers[index+1];
}


@end
