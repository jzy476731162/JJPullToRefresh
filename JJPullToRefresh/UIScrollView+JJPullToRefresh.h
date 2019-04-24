//
//  UIScrollView+JJPullToRefresh.h
//  JJPullToRefresh
//
//  Created by Jox.J on 16/05/2017.
//  Copyright © 2017 Jox.J. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JJPullToRefresh.h"
#import "JJScrollToLoad.h"

@interface UIScrollView (JJPullToRefresh)

- (void)addPullToRefreshWithAction:(void (^)(void))action;
- (void)addPullToRefreshWithAction:(void (^)(void))action AnimationCompletion:(void (^)(void))animationCompletion;
- (void)addPullToRefresh:(JJPullToRefresh *)pullToRefresh;

- (void)removePullToRefresh;

- (void)startRefreshing;
- (void)stopRefreshing;

@property (nonatomic) JJScrollToLoad *topScrollToLoad;
@property (nonatomic) JJScrollToLoad *bottomScrollToLoad;

- (void)addTopScrollToLoadWithAction:(void (^)(void))action;
- (void)addBottomScrollToLoadWithAction:(void (^)(void))action;

- (void)removeTopScrollToLoad;
- (void)removeBottomScrollToLoad;

@end
