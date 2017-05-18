//
//  UIScrollView+JJPullToRefresh.h
//  JJPullToRefresh
//
//  Created by Jox.J on 16/05/2017.
//  Copyright © 2017 Jox.J. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JJPullToRefresh.h"

@interface UIScrollView (JJPullToRefresh)

- (void)addPullToRefreshWithAction:(void (^)(void))action;
- (void)addPullToRefresh:(JJPullToRefresh *)pullToRefresh;
- (void)removePullToRefresh;

- (void)startRefreshing;
- (void)stopRefreshing;

@end
