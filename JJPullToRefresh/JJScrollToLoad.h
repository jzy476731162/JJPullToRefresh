//
//  JJScrollToLoad.h
//  JJScrollToLoad
//
//  Created by Jox.J on 18/05/2017.
//  Copyright © 2017 Jox.J. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JJPullToRefreshProtocol.h"

typedef NS_ENUM(NSUInteger, JJScrollToLoadPosition) {
    JJScrollToLoadPositionTop,
    JJScrollToLoadPositionBottom,
};

@interface JJScrollToLoad : NSObject <JJPullToRefreshDelegate, JJScrollToLoadDelegate>

@property (weak, nonatomic) id<JJScrollToLoadDelegate> delegate;

- (instancetype)initWithAction:(void (^)(void))action position:(JJScrollToLoadPosition)position;

- (void)addToScrollView:(UIScrollView *)scrollView;
- (void)removeFromScrollView;

- (void)startLoading;
- (void)endLoading;

@end
