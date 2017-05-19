//
//  ViewController.m
//  JJPullToRefreshDemo
//
//  Created by Jox.J on 17/05/2017.
//  Copyright © 2017 Jox.J. All rights reserved.
//

#import "ViewController.h"

#import "UIScrollView+JJPullToRefresh.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    /*
    [[self scrollView] addPullToRefreshWithAction:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[self scrollView] stopRefreshing];
        });
    }];
     */
    

    [[self scrollView] addBottomScrollToLoadWithAction:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[[self scrollView] bottomScrollToLoad] endLoading];
        });
    }];
    
    [[self scrollView] addTopScrollToLoadWithAction:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[[self scrollView] topScrollToLoad] endLoading];
        });
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
