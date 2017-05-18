//
//  JJPullToRefreshView.m
//  JJPullToRefresh
//
//  Created by Jox.J on 17/05/2017.
//  Copyright © 2017 Jox.J. All rights reserved.
//

#import "JJPullToRefreshView.h"

@interface JJPullToRefreshView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (nonatomic) UIImage *arrowImage;
@property (nonatomic) UIImage *loadingImage;

@property (weak, nonatomic) IBOutlet UIView *wrapperView;

@end

@implementation JJPullToRefreshView

- (void)awakeFromNib
{
    [super awakeFromNib];
            
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *podBundleUrl = [bundle URLForResource:@"JJPullToRefresh" withExtension:@"bundle"];
    NSBundle *podBundle;
    if (podBundleUrl) {
        podBundle = [NSBundle bundleWithURL:podBundleUrl];
    } else {
        podBundle = bundle;
    }
    
    [self setArrowImage:[UIImage imageNamed:@"JJ_icon_pull_arrow" inBundle:podBundle compatibleWithTraitCollection:nil]];
    [self setLoadingImage:[UIImage imageNamed:@"JJ_loading_small" inBundle:podBundle compatibleWithTraitCollection:nil]];
}

- (void)layoutSubviews
{
    [[self wrapperView] setFrame:CGRectMake(CGRectGetMidX([self bounds]) - 42, CGRectGetMidY([self bounds]) - 10.5, 84.5, 21)];
}

- (void)animateProgress:(float)progress
{
    [[self imageView] setImage:[self arrowImage]];
    if (progress == 1) {
        [[self textLabel] setText:@"松开刷新"];
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        }];
    } else {
        [[self textLabel] setText:@"下拉刷新"];
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.layer.transform = CATransform3DIdentity;
        }];
    }
}

- (void)animateLoading
{
    [[self imageView] setImage:[self loadingImage]];
    
    [[[self imageView] layer] removeAllAnimations];
    self.imageView.layer.transform = CATransform3DIdentity;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INFINITY;
    [[[self imageView] layer] addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [[self textLabel] setText:@"正在刷新"];
}

- (void)stopAnimating
{
    [[[self imageView] layer] removeAllAnimations];
    [[self imageView] setImage:[self arrowImage]];
}

@end
