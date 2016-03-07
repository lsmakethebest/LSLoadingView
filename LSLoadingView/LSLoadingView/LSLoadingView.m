

//
//  LSLoadingView.m
//  LSLoadingView
//
//  Created by ls on 16/3/7.
//  Copyright © 2016年 song. All rights reserved.
//

#import "LSLoadingView.h"

#define LoadingViewWidth 31
#define LoadingViewHeight 31

#define BottomViewWidth 37
#define BottomViewHeight 2.5

#define LabelHeight 20
#define BottomMargin 30

#define AnimationDuration 0.5
#define TimerDuration AnimationDuration
#define MinBottomScale 0.3

@interface LSLoadingView ()

@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, weak) UIImageView* loadingView;
@property (nonatomic, weak) UIImageView* bottomView;
@property (nonatomic, weak) UILabel* tipLabel;

@property (nonatomic, assign) CGFloat fromValue;
@property (nonatomic, assign) CGFloat toValue;

@property (nonatomic, copy) NSString* tipTitle;

@property (nonatomic, assign) int number; //标记当前状态 是第几张图片上还是下
@end

@implementation LSLoadingView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title
{
    if (self = [super initWithFrame:frame]) {
        self.tipTitle = title;
        self.number = 0;
        [self setupViews];
    }
    return self;
}
- (void)setupViews
{
    //圆形图片
    UIImageView* loadingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_circle"]];
    loadingView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:loadingView];
    self.loadingView = loadingView;

    //阴影线
    UIImageView* bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_shadow"]];
    bottomView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:bottomView];
    self.bottomView = bottomView;

    //提示语
    UILabel* tipLabel = [[UILabel alloc] init];
    tipLabel.text = self.tipTitle;
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipLabel];
    self.tipLabel = tipLabel;
}
- (void)startAnimation
{
    self.alpha = 1;
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:TimerDuration target:self selector:@selector(startChnage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.timer fire];
    }
}
- (void)startChnage
{
    switch (self.number) {
    case 0: {
        [self scaleFromValue:1 toValue:MinBottomScale];
        [self transformFromValue:self.fromValue toValue:self.toValue functionName:kCAMediaTimingFunctionEaseIn];

        self.loadingView.image = [UIImage imageNamed:@"loading_circle"]; //圆下

    } break;
    case 1: {
        [self scaleFromValue:MinBottomScale toValue:1];
        [self transformFromValue:self.toValue toValue:self.fromValue functionName:kCAMediaTimingFunctionEaseOut];
        self.loadingView.image = [UIImage imageNamed:@"loading_square"]; //正方形上

    } break;
    case 2: {
        [self scaleFromValue:1 toValue:MinBottomScale]; //正方形下
        [self transformFromValue:self.fromValue toValue:self.toValue functionName:kCAMediaTimingFunctionEaseIn];
    } break;
    case 3: {
        [self scaleFromValue:MinBottomScale toValue:1];
        [self transformFromValue:self.toValue toValue:self.fromValue functionName:kCAMediaTimingFunctionEaseOut];

        self.loadingView.image = [UIImage imageNamed:@"loading_triangle"]; //三角形上

    } break;

    case 4: {
        [self scaleFromValue:1 toValue:MinBottomScale]; //三角形下
        [self transformFromValue:self.fromValue toValue:self.toValue functionName:kCAMediaTimingFunctionEaseIn];
    } break;
    case 5: {
        [self scaleFromValue:MinBottomScale toValue:1];
        [self transformFromValue:self.toValue toValue:self.fromValue functionName:kCAMediaTimingFunctionEaseOut];

        self.loadingView.image = [UIImage imageNamed:@"loading_circle"]; //圆上
        self.number = -1;
    } break;

    default:
        break;
    }
    self.number++;
}
- (void)transformFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue functionName:(NSString*)functionName
{

    //移动位置动画
    CABasicAnimation* basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"position.y";
    basicAnimation.fromValue = @(fromValue);
    basicAnimation.toValue = @(toValue);
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:functionName];
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.removedOnCompletion = NO;
    

    CABasicAnimation* rotateAnimation = [CABasicAnimation animation];
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.removedOnCompletion = NO;
    rotateAnimation.autoreverses=YES;
    rotateAnimation.cumulative=YES;
    rotateAnimation.keyPath = @"transform.rotation";
//    rotateAnimation.fromValue = @0;
    rotateAnimation.toValue = @(M_PI_2);
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:functionName];
    
    //组动画
    CAAnimationGroup* groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = AnimationDuration;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.animations = @[rotateAnimation,basicAnimation ];

    [self.loadingView.layer addAnimation:groupAnimation forKey:@"transfrom"];
}
- (void)scaleFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{

    //阴影缩放
    CABasicAnimation* animation = [CABasicAnimation animation];
    animation.duration = AnimationDuration;
    animation.keyPath = @"transform.scale";
    animation.fromValue = @(fromValue);
    animation.toValue = @(toValue);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.bottomView.layer addAnimation:animation forKey:@"scale"];
}
- (void)stopAnimation
{
    if (self.timer) {
        [self.timer invalidate];
        self.alpha = 0;
        self.timer = nil;
        self.loadingView.image = [UIImage imageNamed:@"loading_circle"];
        [self.loadingView.layer removeAllAnimations];
        [self.bottomView.layer removeAllAnimations];
        self.number = 0;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    self.loadingView.frame = CGRectMake((size.width - LoadingViewWidth) / 2, 0, LoadingViewWidth, LoadingViewHeight);

    self.bottomView.frame = CGRectMake((size.width - BottomViewWidth) / 2, size.height - BottomMargin - BottomViewHeight, BottomViewWidth, BottomViewHeight);

    self.tipLabel.frame = CGRectMake(0, size.height - LabelHeight, size.width, LabelHeight);

    self.fromValue = self.loadingView.frame.size.height / 2;
    self.toValue = self.frame.size.height - BottomMargin - self.loadingView.frame.size.height / 2 - self.bottomView.frame.size.height;
}

@end
