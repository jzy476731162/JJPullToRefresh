//
//  JJScrollToLoad.m
//  JJScrollToLoad
//
//  Created by Jox.J on 18/05/2017.
//  Copyright © 2017 Jox.J. All rights reserved.
//

#import "JJScrollToLoad.h"

#import "JJScrollToLoadView.h"

typedef NS_ENUM(NSUInteger, JJScrollToLoadState) {
    JJScrollToLoadStateNormal,
    JJScrollToLoadStateLoading,
};

@interface JJScrollToLoad ()

@property (nonatomic) JJScrollToLoadState state;
@property (nonatomic) JJScrollToLoadPosition position;

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) JJScrollToLoadView *loadingView;

@property (copy, nonatomic) void (^action)(void);

@property (nonatomic) UIEdgeInsets initialScrollViewInsets;

@end

@implementation JJScrollToLoad

- (instancetype)initWithAction:(void (^)(void))action position:(JJScrollToLoadPosition)position
{
    self = [super init];
    
    if (self) {
        _position = position;
        _action = action;
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserving];
}

- (void)addToScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _initialScrollViewInsets = [_scrollView contentInset];
    
    [_scrollView setAutoresizesSubviews:YES];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *podBundleUrl = [bundle URLForResource:@"JJPullToRefresh" withExtension:@"bundle"];
    NSBundle *podBundle;
    if (podBundleUrl) {
        podBundle = [NSBundle bundleWithURL:podBundleUrl];
    } else {
        podBundle = bundle;
    }
    
    JJScrollToLoadView *loadingView = [[podBundle loadNibNamed:@"JJScrollToLoadView" owner:nil options:nil] firstObject];
    [loadingView setHidden:YES];
    [loadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_scrollView addSubview:loadingView];

    CGFloat originY = -30;
    if ([self position] == JJScrollToLoadPositionBottom) {
        originY = [_scrollView contentSize].height;
    }
    
    [loadingView setFrame:CGRectMake(0, originY, CGRectGetWidth([_scrollView bounds]), 30)];
    
    _loadingView = loadingView;
    
    [self addObserving];
}

- (void)removeFromScrollView
{
    [self removeObserving];
    [[self loadingView] removeFromSuperview];
}

- (void)addObserving
{
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentInset" options:0 context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
}

- (void)removeObserving
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [_scrollView removeObserver:self forKeyPath:@"contentInset" context:nil];
    [_scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if ([_scrollView contentSize].height > 0) {
            if (_state != JJScrollToLoadStateLoading) {
                if ([self position] == JJScrollToLoadPositionTop) {
                    if ([_scrollView contentOffset].y <= -[_scrollView contentInset].top) {
                        [self startLoading];
                    }
                } else {
                    if ([_scrollView contentOffset].y >= ([_scrollView contentSize].height + [_scrollView contentInset].bottom - [_scrollView bounds].size.height)) {
                        [self startLoading];
                    }
                }
            }
        }
    } else if ([keyPath isEqualToString:@"contentInset"]) {
        [self setInitialScrollViewInsets:[_scrollView contentInset]];
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        if ([self position] == JJScrollToLoadPositionBottom) {
            [_loadingView setFrame:CGRectMake(0, [_scrollView contentSize].height, CGRectGetWidth([_scrollView bounds]), 30)];
        }
    }
}

- (void)startLoading
{
    if ([self state] != JJScrollToLoadStateLoading) {
        if ([self delegate]) {
            if (![[self delegate] shouldStartLoading]) {
                return;
            }
        }
        
        [self setState:JJScrollToLoadStateLoading];
        
        [_loadingView setHidden:NO];
        [_loadingView startLoading];
        
        [UIView animateWithDuration:0.3 animations:^{
            UIEdgeInsets insets = [[self scrollView] contentInset];
            if ([self position] == JJScrollToLoadPositionTop) {
                insets.top = insets.top + 30;
                
                [[self scrollView] setContentOffset:CGPointMake(0, -insets.top)];
            } else {
                insets.bottom = insets.bottom + 30;
                
                [[self scrollView] setContentOffset:CGPointMake(0, [_scrollView contentSize].height + insets.bottom - [_scrollView bounds].size.height)];
            }
            
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

- (void)endLoading
{
    [_loadingView setHidden:YES];
    [_loadingView endLoading];
    
    [UIView animateWithDuration:0.3 animations:^{
        [[self scrollView] setContentInset:[self initialScrollViewInsets]];
    } completion:^(BOOL finished) {
        [self setState:JJScrollToLoadStateNormal];
    }];
}

#pragma mark - JJPullToRefreshDelegate, JJScrollToLoadDelegate
- (BOOL)shouldStartLoading
{
    return [self state] != JJScrollToLoadStateLoading;
}

- (BOOL)shouldStartRefreshing
{
    return [self state] != JJScrollToLoadStateLoading;
}

@end
