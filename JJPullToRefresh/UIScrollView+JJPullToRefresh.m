//
//  UIScrollView+JJPullToRefresh.m
//  JJPullToRefresh
//
//  Created by Jox.J on 16/05/2017.
//  Copyright © 2017 Jox.J. All rights reserved.
//

#import "UIScrollView+JJPullToRefresh.h"

#import <objc/runtime.h>

@implementation UIScrollView (JJPullToRefresh)

- (JJPullToRefresh *)pullToRefresh
{
    return objc_getAssociatedObject(self, "JJPullToRefresh");
}

- (void)setPullToRefresh:(JJPullToRefresh *)pullToRefresh
{
    objc_setAssociatedObject(self, "JJPullToRefresh", pullToRefresh, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addPullToRefreshWithAction:(void (^)(void))action
{
    [[self pullToRefresh] removeRefreshViewFromScrollView];
    JJPullToRefresh *pullToRefresh = [[JJPullToRefresh alloc] initWithAction:action];
    [self setPullToRefresh:pullToRefresh];
    [pullToRefresh addRefreshViewToScrollView:self];
}

- (void)addPullToRefresh:(JJPullToRefresh *)pullToRefresh
{
    [[self pullToRefresh] removeRefreshViewFromScrollView];
    [self setPullToRefresh:pullToRefresh];
    [pullToRefresh addRefreshViewToScrollView:self];
}

- (void)removePullToRefresh
{
    [[self pullToRefresh] removeRefreshViewFromScrollView];
    [self setPullToRefresh:nil];
}

- (void)startRefreshing
{
    [[self pullToRefresh] startRefreshing];
}

- (void)stopRefreshing
{
    [[self pullToRefresh] stopRefreshing];
}

@end
