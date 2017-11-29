# YHPageViewController
分页标签控制器、支持多种效果
## YHPageViewController的基础使用
  * 控制器的创建
    
    `
    CustomPageController *controller = [CustomPageController pageViewController];
    `
    
  * 添加子控制器
`  
  \- (void)viewDidLoad {

     [super viewDidLoad];

     UIViewContrller *controller1 = [[UIViewContrller alloc] init];
     controller1.title = @"控制器1";
     [self addChildViewController:controller1];

   }
`   
  
  * 控制器效果
## YHPageViewController的进阶使用
## YHPageViewController的高级使用
