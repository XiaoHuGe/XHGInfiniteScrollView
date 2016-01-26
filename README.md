# XHGInfiniteScrollView
一个ScrollVie实现的可水平,竖直方向无限循环滚动的图片轮播器

 ```
/**
 *  需要添加的图片数组
 */
@property (strong, nonatomic) NSArray *images;
```

```
/**
 *  控制水平竖直方向的滚动  默认为水平方向  设置为YES时为竖直方向
 */
@property (assign, nonatomic, getter=isInfiniteScrollVertical) BOOL infiniteScrollVertical;
```

```
/** 图片切换时间 */
@property(nonatomic, assign) CGFloat time;
```

使用:
```
    //取消自动设置Inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    XHGInfiniteScrollView *scrollView = [[XHGInfiniteScrollView alloc] init];
    //尺寸
    scrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, 180);
    //图片切换时间
    scrollView.time = 1;
    //图片数组
    scrollView.images = @[
                          [UIImage imageNamed: ]... 图片数组的存放
                          ];
    
    [self.view addSubview:scrollView];
    
    //设置竖直方向滚动  默认为水平
    scrollView1.infiniteScrollVertical = YES;
    ```
    这里需要注意的是需要automaticallyAdjustsScrollViewInsets来取消偏移
