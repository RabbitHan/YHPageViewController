//
//  YHPageViewController.h
//  YHPageViewController
//
//  Created by 闫寒 on 17/4/17.
//  Copyright © 2017年 gsww.gsrhc. All rights reserved.
//  如有疑问 联系QQ：617584527

#import <UIKit/UIKit.h>
#import "JKRootViewController.h"

// 用法
// 1.继承YHPageViewController
// 2.viewDidLoad中添加子控制器并设置子控制器的title

typedef void(^SelectTagBlock)(NSString *title,NSInteger indx);

@interface YHPageViewController : JKRootViewController

+ (instancetype)pageViewController;
- (instancetype)initPageViewController;
- (void)resetWithViewControllers:(NSArray <UIViewController *> *)controllers;
- (void)selectTagAtIndex:(NSInteger)index;

@property (nonatomic,strong) NSMutableArray *displayedViewControllers;  // 当前已显示view的viewControllers
@property (nonatomic,strong) UIViewController *currentViewController;   // 当前显示的viewController

@property (nonatomic,strong) UIColor *selectedColor;                    // 选中颜色（默认红色）
@property (nonatomic,strong) UIColor *normalColor;                      // 非选中颜色（默认黑色）
@property (nonatomic,strong) UIColor *contentBgColor;                   // 内容滚动区域背景颜色（默认透明，3D效果有用）
@property (nonatomic,strong) UIColor *titleBgColor;                     // 标题滚动区域背景颜色（默认白色）
@property (nonatomic,strong) UIFont *titleFont;                         // 标题大小 （系统默认）

@property (nonatomic,assign) BOOL needNavigationTitleView;              // 是否是导航栏顶部view
@property (nonatomic,assign) BOOL needScrollTitle;                      // 标题栏是否可滑动（一页/多页）
@property (nonatomic,assign) BOOL needUnderLine;                        // 下划线效果（默认开启）
@property (nonatomic,assign) BOOL needUnderLineWitdhAuto;               // 下划线自动宽度（默认开启）
@property (nonatomic,assign) BOOL needChangeScale;                      // 字体大小变化效果（默认开启）
@property (nonatomic,assign) BOOL need3D;                               // 内容3D切换效果（默认关闭）
@property (nonatomic,assign) BOOL need3DAnimation;                      // 内容3D切换动画效果（3D模式下默认开启）
@property (nonatomic,assign) BOOL needTitleDivision;                    // 标题之间分割栏（默认关闭）
@property (nonatomic,assign) BOOL titleHidden;                          // 标题视图是否隐藏（默认关闭，主要用在加载时）

@property (nonatomic,assign) CGFloat topScale;                          // 顶部切换动画大小倍率(默认1.2倍)
@property (nonatomic,assign) CGFloat buttonMargin;                      // 顶部按钮之间间隙 (默认20，仅needScrollTitle为YES有效)
@property (nonatomic,assign) CGFloat topOffset;                         // 顶部偏移量（默认根据navbar自动调整）
@property (nonatomic,assign) CGFloat bottomOffset;                      // 底部偏移量（默认根据tabbar自动调整）
@property (nonatomic,assign) CGFloat titleRadius;                        // 标题视图圆角（默认0）
@property (nonatomic,assign) CGFloat titleLeft;                         // 标题左侧偏移量（默认0）
@property (nonatomic,assign) CGFloat titleRight;                        // 标题右侧偏移量（默认0）
@property (nonatomic,assign) CGFloat underLineHeight;                   // 下划线高度（默认1.5）

@property (nonatomic,copy) SelectTagBlock selecTagBlock;               // 选中标签的操作
@end
