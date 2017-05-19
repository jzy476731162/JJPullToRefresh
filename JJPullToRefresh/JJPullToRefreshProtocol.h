//
//  JJPullToRefreshProtocol.h
//  JJPullToRefresh
//
//  Created by Jox.J on 19/05/2017.
//  Copyright © 2017 Jox.J. All rights reserved.
//

#ifndef JJPullToRefreshProtocol_h
#define JJPullToRefreshProtocol_h

#import <UIKit/UIKit.h>

@protocol JJScrollToLoadDelegate <NSObject>

- (BOOL)shouldStartLoading;

@end

@protocol JJPullToRefreshDelegate <NSObject>

- (BOOL)shouldStartRefreshing;

@end

#endif /* JJPullToRefreshProtocol_h */
