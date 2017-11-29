# YHPageViewController
分页标签控制器、支持多种效果
## YHPageViewController的基础使用
  * 控制器的创建
  
        //CustomPageController : YHPageViewController
  
        CustomPageController *pageController = [CustomPageController pageViewController];
    
  * 添加子控制器
  
        - (void)viewDidLoad {
          [super viewDidLoad];
      
          UIViewContrller *controller1 = [[UIViewContrller alloc] init];
          controller1.title = @"控制器1";  //title为顶部标签页的标题
          [self addChildViewController:controller1];
          
          UIViewContrller *controller2 = [[UIViewContrller alloc] init];
          controller2.title = @"控制器2";  //title为顶部标签页的标题
          [self addChildViewController:controller2];
          
          ······
        } 
  
  * 添加效果
  
        CustomPageController *pageController = [CustomPageController pageViewController];
        pageController.normalColor = [UIColor blackColor];  //标签普通颜色
        pageController.selectedColor = [UIColor redColor];  //标签选中颜色
        pageController.titleFont = [UIFont systemOfSize:15.0f];  //标签字体大小
  
## YHPageViewController的进阶使用
## YHPageViewController的高级使用
