//
//  JJPullToRefresh.m
//  JJPullToRefresh
//
//  Created by Jox.J on 15/05/2017.
//  Copyright © 2017 Jox.J. All rights reserved.
//

#import "JJPullToRefresh.h"

@interface JJPullToRefresh ()

@property (weak, nonatomic) UIView<JJPullToRefreshAnimation> *refreshView;
@property (weak, nonatomic) UIScrollView *scrollView;

@property (nonatomic) JJPullToRefreshState state;

@property (copy, nonatomic) void (^action)(void);

@property (nonatomic) UIEdgeInsets initialScrollViewInsets;

@end

@implementation JJPullToRefresh

- (instancetype)initWithCustomRefreshView:(UIView<JJPullToRefreshAnimation> *)refreshView action:(void (^)(void))action
{
    self = [super init];
    
    if (self) {
        _state = JJPullToRefreshStateNormal;
        
        _refreshView = refreshView;
        _action = action;
    }
    
    return self;
}

- (instancetype)initWithAction:(void (^)(void))action
{
    self = [super init];
    
    if (self) {
        _state = JJPullToRefreshStateNormal;
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *podBundleUrl = [bundle URLForResource:@"JJPullToRefresh" withExtension:@"bundle"];
        NSBundle *podBundle;
        if (podBundleUrl) {
            podBundle = [NSBundle bundleWithURL:podBundleUrl];
        } else {
            podBundle = bundle;
        }

        _refreshView = [[podBundle loadNibNamed:@"JJPullToRefreshView" owner:nil options:nil] firstObject];

        _action = action;
    }
    
    return self;
}

- (void)addRefreshViewToScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _initialScrollViewInsets = [scrollView contentInset];
    
    if (@available(iOS 11.0, *)) {
        [_scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        // Fallback on earlier versions
    }
    
    [_scrollView setAutoresizesSubviews:YES];
    [_refreshView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_refreshView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [_refreshView setFrame:CGRectMake(0, -_refreshView.frame.size.height, scrollView.frame.size.width, _refreshView.frame.size.height)];
    [_scrollView addSubview:_refreshView];
    
    [self startObservingScrollViewKeypaths];
}

- (void)removeRefreshViewFromScrollView
{
    if ([self state] == JJPullToRefreshStateRefreshing) {
        [[self scrollView] setContentInset:[self initialScrollViewInsets]];
        [self setState:JJPullToRefreshStateNormal];
        [[self refreshView] stopAnimating];
    }
    
    [[self refreshView] removeFromSuperview];
    [self stopObservingScrollViewKeypaths];
    [self setScrollView:nil];
}

- (void)startObservingScrollViewKeypaths
{
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentInset" options:0 context:nil];
}

- (void)stopObservingScrollViewKeypaths
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [_scrollView removeObserver:self forKeyPath:@"contentInset" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if ([self state] != JJPullToRefreshStateRefreshing) {
            CGFloat offset = [[self scrollView] contentOffset].y + [self initialScrollViewInsets].top;

            if (offset <= 0) {
                CGFloat progress = -offset / [self refreshView].frame.size.height;
//                if (progress > 1) {
//                    progress = 1;
//                }
                
                if ((progress >= 1) && ![[self scrollView] isDragging]) {
                    [self startRefreshing];
                } else {
                    [[self refreshView] animateProgress:progress];
                    [self setState:JJPullToRefreshStateTracking];
                }
            } else {
                [[self refreshView] animateProgress:0];
                [self setState:JJPullToRefreshStateNormal];
            }
        }
    } else if ([keyPath isEqualToString:@"contentInset"]) {
        [self setInitialScrollViewInsets:[[self scrollView] contentInset]];
    }
}

- (void)startRefreshing
{
    if ([self state] != JJPullToRefreshStateRefreshing) {
        if ([self delegate]) {
            if (![[self delegate] shouldStartRefreshing]) {
                return;
            }
        }
        
        [self setState:JJPullToRefreshStateRefreshing];
        
        [[self refreshView] animateLoading];
        
        [UIView animateWithDuration:0.3 animations:^{
            UIEdgeInsets insets = [[self scrollView] contentInset];
            insets.top = insets.top + [self refreshView].frame.size.height;
            
            [[self scrollView] setContentOffset:CGPointMake(0, -insets.top)];
            
            /*
             我们只希望在scrollView的contentInset被其他对象更改时收到通知，
             但移除KVO Observer再重新添加的做法开销比较大，所以我们这里采取back up的方式再startRefreshing返回之后再恢复
             备份的contentInset的值
             */
            UIEdgeInsets backUpInsets = [self initialScrollViewInsets];
            [[self scrollView] setContentInset:insets];
            [self setInitialScrollViewInsets:backUpInsets];
        } completion:^(BOOL finished) {
            if ([self action]) {
                [self action]();
            }
        }];
    }
}

- (void)stopRefreshing
{
    [[self refreshView] stopAnimating];
    
    [UIView animateWithDuration:0.3 animations:^{
        [[self scrollView] setContentInset:[self initialScrollViewInsets]];
    } completion:^(BOOL finished) {
        [self setState:JJPullToRefreshStateNormal];
    }];
}

#pragma mark - JJPullToRefreshDelegate, JJScrollToLoadDelegate
- (BOOL)shouldStartLoading
{
    return [self state] != JJPullToRefreshStateRefreshing;
}

- (BOOL)shouldStartRefreshing
{
    return [self state] != JJPullToRefreshStateRefreshing;
}

@end
