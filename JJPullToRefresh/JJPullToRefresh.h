//
//  JJPullToRefresh.h
//  JJPullToRefresh
//
//  Created by Jox.J on 15/05/2017.
//  Copyright © 2017 Jox.J. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JJPullToRefreshProtocol.h"

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

@interface JJPullToRefresh : NSObject <JJPullToRefreshDelegate, JJScrollToLoadDelegate>

@property (weak, nonatomic) id<JJPullToRefreshDelegate> delegate;
@property (nonatomic, assign) CGFloat actionTriggerOffsetY;
@property (nonatomic, assign) CGFloat minimumLoadingTime;

- (instancetype)initWithCustomRefreshView:(UIView<JJPullToRefreshAnimation> *)refreshView action:(void (^)(void))action;
- (instancetype)initWithCustomRefreshView:(UIView<JJPullToRefreshAnimation> *)refreshView action:(void (^)(void))action AnimationCompletion:(void(^)(void))animationCompletion;

- (instancetype)initWithAction:(void (^)(void))action;
- (instancetype)initWithAction:(void (^)(void))action AnimationCompletion:(void(^)(void))animationCompletion;

- (void)addRefreshViewToScrollView:(UIScrollView *)scrollView;
- (void)removeRefreshViewFromScrollView;

- (void)startRefreshing;
//- (void)stopRefreshing;
- (void)stopRefreshing:(void(^)(void))completion;

@end
