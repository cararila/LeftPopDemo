


// 宏里面的#，会自动把后面的参数变成C语言的字符串
#define keyPath(objc,keyPath) @(((void)objc.keyPath,#keyPath))


// 宏的操作原理，每输入一个字母就会直接把宏右边的拷贝，并且会自动补齐前面的内容。

#import "LeftViewController.h"

@interface LeftViewController ()

@property (nonatomic, weak) UIView *mainV;
@property (nonatomic, weak) UIView *leftV;
@property (nonatomic, weak) UIView *rightV;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加子控件
    [self setUpChildView];
    
    // 添加Pan手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
//    self.interactivePopGestureRecognizer.enabled = NO;
    [_mainV addObserver:self forKeyPath:keyPath(_mainV, frame) options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    // 添加点按手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [self.view addGestureRecognizer:tap];
}


#pragma mark - 点按手势
- (void)tap
{
    // 还原
    if (_mainV.frame.origin.x != 0) {
        [UIView animateWithDuration:0.25 animations:^{
            
            _mainV.frame = CGRectMake(-200, 0, 200, [UIScreen mainScreen].bounds.size.height);
        }];
    }
}

// 只要监听的属性一改变，就会调用观察者的这个方法，通知你有新值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (_mainV.frame.origin.x > 0) { // 往右边移动，隐藏蓝色的view
        _rightV.hidden = YES;
    }
}

// 在对象销毁的时候，一定要注意移除观察者
- (void)dealloc
{
    // 移除观察者
    [_mainV removeObserver:self forKeyPath:@"frame"];
}



#pragma mark - pan的方法
- (void)pan:(UIPanGestureRecognizer *)pan
{
   [UIView animateWithDuration:0.5 animations:^{
       
       CGPoint transP = [pan translationInView:self.view];
       
       // 获取X轴的偏移量
       CGFloat offsetX = transP.x;
       _leftV.alpha =1-offsetX /200;
       // 修改mainV的Frame
       _mainV.frame = [self frameWithOffsetX:0];
       
       // 复位
       [pan setTranslation:CGPointZero inView:self.view];
   }];
}

#pragma mark - 根据offsetX计算mainV的Frame
- (CGRect)frameWithOffsetX:(CGFloat)offsetX
{
    CGRect frame = _mainV.frame;
    frame.origin.x = 0.000001;
    
    return frame;
}

#pragma mark - 添加子控件
- (void)setUpChildView
{
    // left
    UITableView *leftV = [[UITableView alloc] initWithFrame:self.view.bounds];
    leftV.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:leftV];
    
    _leftV = leftV;
    
    // main
    UITableView *mainV = [[UITableView alloc] init];
    mainV.frame =CGRectMake(-200, 0, 200, [UIScreen mainScreen].bounds.size.height);
    mainV.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:mainV];
    
    _mainV = mainV;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _mainV.frame =CGRectMake(-200, 0, 200, [UIScreen mainScreen].bounds.size.height);
    
    _leftV.frame =[UIScreen mainScreen].bounds;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _mainV.frame =CGRectMake(-200, 0, 200, [UIScreen mainScreen].bounds.size.height);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
