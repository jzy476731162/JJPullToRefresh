//
//  JJScrollToLoadView.m
//  JJScrollToLoad
//
//  Created by Jox.J on 18/05/2017.
//  Copyright © 2017 Jox.J. All rights reserved.
//

#import "JJScrollToLoadView.h"

@interface JJScrollToLoadView ()

@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;

@end

@implementation JJScrollToLoadView

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
    
    [[self loadingImageView] setImage:[UIImage imageNamed:@"JJ_loading_small" inBundle:podBundle compatibleWithTraitCollection:nil]];
}

- (void)layoutSubviews
{
    [[self loadingImageView] setCenter:CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]))];
}

- (void)startLoading
{
    [[_loadingImageView layer] removeAllAnimations];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INFINITY;
    [[_loadingImageView layer] addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)endLoading
{
    [[_loadingImageView layer] removeAllAnimations];
}

@end
