//
//  YHPageViewController.m
//  HealthGanSu
//
//  Created by 闫寒 on 17/4/17.
//  Copyright © 2017年 gsww.gsrhc. All rights reserved.
//

#import "YHPageViewController.h"

CGFloat const duration = 0.25;
CGFloat const offSet = -999;

@interface YHPageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentTitleView;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollTitleView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContentView;

@property (nonatomic,weak) UIView *titleUnderline;
@property (nonatomic,weak) UIButton *selectButton;
@property (nonatomic,weak) UIView *currentView;
@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) NSMutableArray *divisionArray;

@property (nonatomic,assign) BOOL isInitialize;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTitleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTitleLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTitleRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollTitleTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentWitdh;


@end

@implementation YHPageViewController

- (NSMutableArray *)buttonArray
{
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray *)divisionArray
{
    if (_divisionArray == nil) {
        _divisionArray = [NSMutableArray array];
    }
    return _divisionArray;
}

- (NSMutableArray *)displayedViewControllers
{
    if (_displayedViewControllers == nil) {
        _displayedViewControllers = [NSMutableArray array];
    }
    return _displayedViewControllers;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.contentView.clipsToBounds = NO;
    
    if (self.isInitialize == NO) {
        
        [self setupFrame];
        [self setupAllTitle];
        
        self.isInitialize = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.contentView.clipsToBounds = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 要在viewDidAppear里 不然scrollTitleView依旧有可能下移64
//    [self.view bringSubviewToFront:self.line];
    
    // 在此处设置contentSize可以获取AutoLayout的真实宽度
    NSInteger count = self.childViewControllers.count;

    self.scrollContentView.contentSize = CGSizeMake(count * self.scrollContentView.bounds.size.width, 0);
    
    // 如果有动画 因为约束首个view的frame不合适 在此处矫正
    if (self.need3D && self.childViewControllers.firstObject.view.frame.size.width != (self.view.frame.size.width + self.scrollContentWitdh.constant) * 0.9) {
        self.childViewControllers.firstObject.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    YHPageViewController *pageViewController = nil;
    if ((pageViewController = [super allocWithZone:zone])) {
        pageViewController.normalColor = [UIColor darkGrayColor];
        pageViewController.selectedColor = [UIColor redColor];
        pageViewController.contentBgColor = [UIColor clearColor];
        pageViewController.titleBgColor = [UIColor whiteColor];
        pageViewController.titleFont = [UIFont systemFontOfSize:15.0f];
        pageViewController.needNavigationTitleView = NO;
        pageViewController.needUnderLine = YES;
        pageViewController.needUnderLineWitdhAuto = YES;
        pageViewController.needChangeScale = YES;
        pageViewController.needScrollTitle = YES;
        pageViewController.need3D = NO;
        pageViewController.need3DAnimation = YES;
        pageViewController.needTitleDivision = NO;
        pageViewController.topScale = 1.2;
        pageViewController.topOffset = offSet;
        pageViewController.titleRadius = 0;
        pageViewController.titleLeft = 0;
        pageViewController.titleRight = 0;
        pageViewController.bottomOffset = offSet;
        pageViewController.buttonMargin = 20;
        pageViewController.underLineHeight = 1;
    }
    return pageViewController;
}

+ (instancetype)pageViewController
{
    return [[self alloc] initPageViewController];
}

- (instancetype)initPageViewController
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"libYHPageViewControllerResources" ofType:@"bundle"];
    return [self initWithNibName:@"YHPageViewController" bundle:[NSBundle bundleWithPath:path]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置滚动内容
    [self setupScrollContent];
    
    // 设置禁止自动下移，双保险
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupScrollContent
{
    self.contentView.backgroundColor = self.contentBgColor;
    self.scrollContentView.clipsToBounds = NO;
    self.contentTitleView.backgroundColor = self.titleBgColor;
    self.contentTitleView.layer.cornerRadius = self.titleRadius;
}

- (void)resetWithViewControllers:(NSArray <UIViewController *> *)controllers
{
    // 删除所有已显示的控制器的view
    for (UIViewController *controller in self.displayedViewControllers) {
        [controller.view removeFromSuperview];
    }
    
    // 删除所有子控制器
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    
    // 删除所有button
    [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttonArray removeAllObjects];
    
    // 删除所有分割线
    [self.divisionArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.divisionArray removeAllObjects];
    
    // 添加新的子控制器
    for (UIViewController *controller in controllers) {
        [self addChildViewController:controller];
    }
    
    // 设置已加载标识为NO
    self.isInitialize = NO;
    
    self.selectButton = nil;
    self.currentView = nil;
    
    // 强制重新刷新
    [self viewWillAppear:NO];
    
    // 强制设置contentSize
    [self viewDidAppear:NO];
}

- (void)setupFrame
{
    // scrollTitleView
    CGFloat titleY;
    if (self.topOffset != offSet) {
        titleY = _topOffset;
    }else{
        if (!self.navigationController.childViewControllers.count) {
            titleY = 20;
        }else{
            titleY = self.navigationController.navigationBar.hidden ? 20 : 64;
        }
        
        if (self.needNavigationTitleView) {
            titleY = 20;
        }
    }
    self.scrollTitleTop.constant = titleY;
    
    // contentView
    CGFloat contentH;
    if (self.bottomOffset != offSet) {
        contentH = self.bottomOffset;
    }else{
        contentH = self.tabBarController.tabBar.hidden ? 0 : 48;
    }
    self.contentBottom.constant =  contentH;
    
    // scrollContentView
    if (self.need3D) {
        self.scrollContentWitdh.constant = -(60.0 / 375 * [UIScreen mainScreen].bounds.size.width);
    }

    // 处理scrollTitle
    if (self.needNavigationTitleView) {
        self.contentTitleHeight = 0;
        self.line.hidden = YES;
        self.scrollTitleView.frame = CGRectMake(0, 4, [UIScreen mainScreen].bounds.size.width * 0.6, 40);
    }else{
        self.scrollTitleView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width -  self.titleRight - self.titleLeft, self.contentTitleView.bounds.size.height);
        self.line.hidden = NO;
    }
    
    self.contentTitleLeft.constant = self.titleLeft;
    self.contentTitleRight.constant = self.titleRight;
}

- (void)setupAllTitle
{
    NSInteger count = self.childViewControllers.count;

    CGFloat btnH = self.scrollTitleView.bounds.size.height;
    CGFloat btnX = 0;
    
    for (NSInteger i = 0; i < count; i++) {
        
        UIViewController *controller = self.childViewControllers[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.titleLabel.font = self.titleFont;
        [button setTitle:controller.title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(titltClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
        
        CGFloat btnW = self.needScrollTitle ? [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : button.titleLabel.font}].width + self.buttonMargin : self.scrollTitleView.bounds.size.width / count ;
        btnX = CGRectGetMaxX([self.buttonArray.lastObject frame]);
        button.frame = CGRectMake(btnX, 0, btnW, btnH);
        
        [self.buttonArray addObject:button];
        [self.scrollTitleView addSubview:button];

        if (i == 0) {
            self.needUnderLine ? [self setupTitleUnderline] : nil;
            [self titltClick:button];
        }
        
        if (self.needTitleDivision && i != count - 1) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = self.normalColor;
            view.bounds = CGRectMake(0, 0, 1, self.titleFont.lineHeight * 0.8);
            view.center = CGPointMake(CGRectGetMaxX(button.frame), button.center.y);
            [self.scrollTitleView addSubview:view];
            [self.divisionArray addObject:view];
        }
        
        // 根据最后一个按钮调整titleScrollView的frame和contentSize
        if (i == count - 1) {
            CGFloat width = self.needScrollTitle ? CGRectGetMaxX([self.buttonArray.lastObject frame]) : self.scrollTitleView.frame.size.width ;
            if (width < self.scrollTitleView.frame.size.width) {
                self.scrollTitleView.frame = CGRectMake(self.scrollTitleView.frame.origin.x, self.scrollTitleView.frame.origin.y, width, self.scrollTitleView.frame.size.height);
            }
            self.scrollTitleView.contentSize = CGSizeMake(width, 0);
            
            // 此时添加到导航栏上frame是正确的
            if (self.needNavigationTitleView) {
                self.navigationItem.titleView = self.scrollTitleView;
            }else{
                self.scrollTitleView.center = CGPointMake(([UIScreen mainScreen].bounds.size.width - self.titleLeft - self.titleRight) / 2.0, self.scrollTitleView.center.y);
            }
        }
    }
}

- (void)setupTitleUnderline
{
    // 标题按钮
    UIButton *firstTitleButton = self.buttonArray.firstObject;
    [firstTitleButton.titleLabel sizeToFit];
    
    // 下划线
    if (!self.titleUnderline.superview) {
        UIView *titleUnderline = [[UIView alloc] init];
        titleUnderline.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
        [self.scrollTitleView addSubview:titleUnderline];
        self.titleUnderline = titleUnderline;
    }
    self.titleUnderline.frame = CGRectMake(0, self.scrollTitleView.bounds.size.height - self.underLineHeight, self.needUnderLineWitdhAuto ? firstTitleButton.titleLabel.bounds.size.width + 10 : firstTitleButton.bounds.size.width, self.underLineHeight);
    self.titleUnderline.center = CGPointMake(firstTitleButton.center.x, self.titleUnderline.center.y);
}

#pragma mark -- 标题点击

- (void)selectTagAtIndex:(NSInteger)index
{
    [self titltClick:self.buttonArray[index]];
}

- (void)titltClick:(UIButton *)button
{
    NSInteger i = button.tag;
    
    // 1.样式改变
    [self selButton:button];
    
    // 2.添加对应控制器的view
    [self selController:i];
    
    // 3.内容滚动到对应位置
    CGFloat x = i * self.scrollContentView.frame.size.width;
    self.scrollContentView.contentOffset = CGPointMake(x, 0);
    
}

- (void)selButton:(UIButton *)button
{
    // 设置居中
    if (self.needScrollTitle) {
        [self setTitleButtonCenter:button];
    }
    
    // 字体缩放
    if (self.needChangeScale) {
        self.selectButton.transform = CGAffineTransformIdentity;
        button.transform = CGAffineTransformMakeScale(self.topScale, self.topScale);
    }
    
    // 三部曲
    self.selectButton.selected = NO;
    button.selected = YES;
    self.selectButton = button;
    
    // 处理下划线
    if (self.needUnderLine) {
        [UIView animateWithDuration:duration animations:^{
            self.titleUnderline.bounds = CGRectMake(0, 0, self.needUnderLineWitdhAuto ? button.titleLabel.bounds.size.width + 10 : button.bounds.size.width, self.titleUnderline.bounds.size.height);
            self.titleUnderline.center = CGPointMake(button.center.x, self.titleUnderline.center.y);
        }];
    }
}

- (void)selController:(NSInteger)index
{
    
    UIViewController *controller = self.childViewControllers[index];
    self.currentViewController = controller;
    
    // 操作处理
    if (self.selecTagBlock) {
        self.selecTagBlock(controller.title,index);
    }
    
    if (!controller.view.superview) {
        CGFloat x = index * self.scrollContentView.bounds.size.width;
        controller.view.frame = CGRectMake(x, 0, self.scrollContentView.bounds.size.width , self.scrollContentView.bounds.size.height);
        [self.scrollContentView addSubview:controller.view];
        [self.displayedViewControllers addObject:controller];
    }
    
    if (self.need3D && self.view.superview) {
        self.currentView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        if (self.need3DAnimation) {
            controller.view.transform = CGAffineTransformMakeScale(0.95, 0.95);
        }else{
            controller.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }
        self.currentView = controller.view;
    }
}

- (void)setTitleButtonCenter:(UIButton *)button
{
    // 本质修改scrollTileView的contentOffset
    // 计算距离中心的偏移量
    CGFloat offsetX = button.center.x - self.scrollTitleView.frame.size.width * 0.5;
    
    // 处理最小偏移量
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 处理最大偏移量
    CGFloat maxOffsetX = self.scrollTitleView.contentSize.width - self.scrollTitleView.frame.size.width;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [UIView animateWithDuration:duration animations:^{
        [self.scrollTitleView setContentOffset:CGPointMake(offsetX, 0)];
    }];
}

- (void)setTitleHidden:(BOOL)titleHidden
{
    _titleHidden = titleHidden;
    
    self.contentTitleView.hidden = titleHidden;
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 字体缩放
    NSInteger leftI = scrollView.contentOffset.x / self.scrollContentView.frame.size.width;
    NSInteger rightI = leftI + 1;
    
    // 获取左边的按钮
    UIButton *leftBtn = self.buttonArray[leftI];
    UIView *leftView = self.childViewControllers[leftI].view;
    NSInteger count = self.buttonArray.count;
    
    // 获取右边的按钮
    UIButton *rightBtn;
    UIView *rightView;
    if (rightI < count) {
        rightBtn = self.buttonArray[rightI];
        rightView = self.childViewControllers[rightI].view;
    }
    
    // 0 ~ 1 =>  1 ~ 1.2
    // 计算缩放比例
    CGFloat scaleR = scrollView.contentOffset.x /  self.scrollContentView.frame.size.width;
    scaleR -= leftI;
    CGFloat scaleL = 1 - scaleR;
    
    // 缩放按钮
    if (self.needChangeScale){
        CGFloat maxScale = self.topScale - 1;
        leftBtn.transform = CGAffineTransformMakeScale(scaleL * maxScale + 1, scaleL * maxScale + 1);
        rightBtn.transform = CGAffineTransformMakeScale(scaleR * maxScale + 1, scaleR * maxScale + 1);
    }
    
    // 3D效果
    if (self.need3D && self.need3DAnimation) {
        if (leftView.superview) {
            leftView.transform = CGAffineTransformMakeScale(scaleL * 0.05 + 0.9, scaleL * 0.05 + 0.9);
        }
        if (rightView.superview) {
            rightView.transform = CGAffineTransformMakeScale(scaleR * 0.05 + 0.9, scaleR * 0.05 + 0.9);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger i = scrollView.contentOffset.x / self.scrollContentView.frame.size.width;
    
    UIButton *button = self.buttonArray[i];
    
    // 选中对应title
    [self selButton:button];
    
    // 添加对应页面
    [self selController:i];
}

@end
