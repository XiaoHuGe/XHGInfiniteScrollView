//
//  XHGInfiniteScrollView.m
//  XHGInfiniteScrollViewDemo
//
//  Created by xiaohuge on 16/1/25.
//  Copyright © 2016年 xiaohuge. All rights reserved.
//

#import "XHGInfiniteScrollView.h"
/** ImageView的个数 */
static int const ImageViewCount = 3;

@interface XHGInfiniteScrollView() <UIScrollViewDelegate>
@property (weak, nonatomic) UIScrollView *scrollView;
/* 定时器 */
@property (weak, nonatomic) NSTimer *timer;

@property (weak, nonatomic, readonly) UIPageControl *pageControl;
@end

@implementation XHGInfiniteScrollView
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //图片默认切换时间
        self.time = 2;
        
        // 滚动视图
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 图片控件
        for (int i = 0; i<ImageViewCount; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [scrollView addSubview:imageView];
        }
        
        // 页码视图
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    return self;
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置frame
    self.scrollView.frame = self.bounds;
    
    // 设置contentSize
    if (self.isInfiniteScrollVertical) {
        self.scrollView.contentSize = CGSizeMake(0, ImageViewCount * self.bounds.size.height);
    } else {
        self.scrollView.contentSize = CGSizeMake(ImageViewCount * self.bounds.size.width, 0);
    }
    
    // 摆放imageView
    for (int i = 0; i<ImageViewCount; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        if (self.isInfiniteScrollVertical) {
            imageView.frame = CGRectMake(0, i * self.scrollView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        } else {
            imageView.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        }
    }
    
    // 设置pageControl
    CGFloat pageW = 80;
    CGFloat pageH = 20;
    CGFloat pageX = self.scrollView.frame.size.width - pageW;
    CGFloat pageY = self.scrollView.frame.size.height - pageH;
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    
    [self updateContent];
}

#pragma mark - setter
- (void)setImages:(NSArray *)images
{
    _images = images;
    
    // 设置页码
    self.pageControl.numberOfPages = images.count;
    self.pageControl.currentPage = 0;
    
    // 设置内容
    [self updateContent];
    
    // 开始定时器
    [self startTimer];
}

- (void)setTime:(CGFloat)time{

    _time = time;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 计算当前页码（找出当前显示在最中间的imageView）
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i<ImageViewCount; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        CGFloat distance = 0;
        if (self.isInfiniteScrollVertical) {
            distance = ABS(imageView.frame.origin.y - scrollView.contentOffset.y);
        } else {
            distance = ABS(imageView.frame.origin.x - scrollView.contentOffset.x);
        }
        if (distance < minDistance) {
            minDistance = distance;
            page = imageView.tag;
        }
    }
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateContent];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateContent];
}

#pragma mark - 内容更新
- (void)updateContent
{
    // 设置图片
    for (int i = 0; i<ImageViewCount; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        // 当前页码
        NSInteger index = self.pageControl.currentPage;
        if (i == 0) { // 左边
            index--;
        } else if (i == 2) { // 右边
            index++;
        }
        // 越界处理
        if (index < 0) {
            index = self.pageControl.numberOfPages - 1;
        } else if (index >= self.pageControl.numberOfPages) {
            index = 0;
        }
        imageView.tag = index;
        imageView.image = self.images[index];
    }
    
    // 设置偏移量在中间
    if (self.isInfiniteScrollVertical) {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    } else {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }
}

#pragma mark - 定时器处理
- (void)startTimer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
//下一张图片
- (void)next
{
    if (self.isInfiniteScrollVertical) {
        [self.scrollView setContentOffset:CGPointMake(0, 2 * self.scrollView.frame.size.height) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake(2 * self.scrollView.frame.size.width, 0) animated:YES];
    }
}
@end

