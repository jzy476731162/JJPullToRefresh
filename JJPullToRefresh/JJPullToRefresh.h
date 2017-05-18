//
//  JJPullToRefresh.h
//  JJPullToRefresh
//
//  Created by Jox.J on 15/05/2017.
//  Copyright © 2017 Jox.J. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JJPullToRefreshState) {
    JJPullToRefreshStateNormal,
    JJPullToRefreshStateTracking,
    JJPullToRefreshStateRefreshing,
};

@protocol JJPullToRefreshAnimation <NSObject>

- (void)animateProgress:(float)progress;
- (void)stopAnimating;
- (void)animateLoading;

@end

@interface JJPullToRefresh : NSObject

- (instancetype)initWithCustomRefreshView:(UIView<JJPullToRefreshAnimation> *)refreshView action:(void (^)(void))action;

- (instancetype)initWithAction:(void (^)(void))action;

- (void)addRefreshViewToScrollView:(UIScrollView *)scrollView;
- (void)removeRefreshViewFromScrollView;

- (void)startRefreshing;
- (void)stopRefreshing;

@end