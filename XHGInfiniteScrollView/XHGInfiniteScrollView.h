//
//  XHGInfiniteScrollView.h
//  XHGInfiniteScrollViewDemo
//
//  Created by xiaohuge on 16/1/25.
//  Copyright © 2016年 xiaohuge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHGInfiniteScrollView : UIView
/**
 *  需要添加的图片数组
 */
@property (strong, nonatomic) NSArray *images;

/**
 *  控制水平竖直方向的滚动  默认为水平方向  设置为YES时为竖直方向
 */
@property (assign, nonatomic, getter=isInfiniteScrollVertical) BOOL infiniteScrollVertical;


/** 图片切换时间 */
@property(nonatomic, assign) CGFloat time;

@end
