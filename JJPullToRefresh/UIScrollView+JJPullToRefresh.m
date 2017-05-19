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
    NSAssert(![self topScrollToLoad], @"Error: using pull to refresh and top scroll to load together");
    
    JJPullToRefresh *pullToRefresh = [[JJPullToRefresh alloc] initWithAction:action];
    [self addPullToRefresh:pullToRefresh];
}

- (void)addPullToRefresh:(JJPullToRefresh *)pullToRefresh
{
    NSAssert(![self topScrollToLoad], @"Error: using pull to refresh and top scroll to load together");
    
    [[self pullToRefresh] removeRefreshViewFromScrollView];
    [self setPullToRefresh:pullToRefresh];
    [pullToRefresh addRefreshViewToScrollView:self];
    [pullToRefresh setDelegate:[self bottomScrollToLoad]];
    [[self bottomScrollToLoad] setDelegate:pullToRefresh];
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

#pragma mark - JJScrollToLoad
- (JJScrollToLoad *)topScrollToLoad
{
    return objc_getAssociatedObject(self, "JJTopScrollToLoad");
}

- (void)setTopScrollToLoad:(JJScrollToLoad *)topScrollToLoad
{
    objc_setAssociatedObject(self, "JJTopScrollToLoad", topScrollToLoad, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JJScrollToLoad *)bottomScrollToLoad
{
    return objc_getAssociatedObject(self, "JJBottomScrollToLoad");
}

- (void)setBottomScrollToLoad:(JJScrollToLoad *)bottomScrollToLoad
{
    objc_setAssociatedObject(self, "JJBottomScrollToLoad", bottomScrollToLoad, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addTopScrollToLoadWithAction:(void (^)(void))action
{
    NSAssert(![self pullToRefresh], @"Error: using pull-to-refresh and top scroll-to-load together");
    [[self topScrollToLoad] removeFromScrollView];
    [self setTopScrollToLoad:[[JJScrollToLoad alloc] initWithAction:action position:JJScrollToLoadPositionTop]];
    [[self topScrollToLoad] addToScrollView:self];
    [[self topScrollToLoad] setDelegate:[self bottomScrollToLoad]];
    [[self bottomScrollToLoad] setDelegate:[self topScrollToLoad]];
}

- (void)addBottomScrollToLoadWithAction:(void (^)(void))action
{
    [[self bottomScrollToLoad] removeFromScrollView];
    [self setBottomScrollToLoad:[[JJScrollToLoad alloc] initWithAction:action position:JJScrollToLoadPositionBottom]];
    [[self bottomScrollToLoad] addToScrollView:self];
    if ([self topScrollToLoad]) {
        [[self bottomScrollToLoad] setDelegate:[self topScrollToLoad]];
        [[self topScrollToLoad] setDelegate:[self bottomScrollToLoad]];
    } else if ([self pullToRefresh]) {
        [[self bottomScrollToLoad] setDelegate:[self pullToRefresh]];
        [[self pullToRefresh] setDelegate:[self bottomScrollToLoad]];
    }
}

- (void)removeTopScrollToLoad
{
    [[self topScrollToLoad] removeFromScrollView];
    [self setTopScrollToLoad:nil];
}

- (void)removeBottomScrollToLoad
{
    [[self bottomScrollToLoad] removeFromScrollView];
    [self setBottomScrollToLoad:nil];
}

@end
