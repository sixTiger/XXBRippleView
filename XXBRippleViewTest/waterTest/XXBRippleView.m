//
//  XXBRippleView.m
//  waterTest
//
//  Created by Jinhong on 15/2/5.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBRippleView.h"

@interface XXBRippleView ()

/**
 *  圆圈的个数
 */
@property(nonatomic , assign)NSInteger 	radiuNumber;

/**
 *  控制动画的定时器
 */
@property(nonatomic , strong)NSTimer 	*animationTimer;
/**
 *  缩放比例
 */
@property(nonatomic , assign)CGFloat 	pantographProportion;
@end

@implementation XXBRippleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupRippleView];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupRippleView];
    }
    return self;
}

- (void)setupRippleView
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self startRippleAnimation];
}
/**
 *  开始动画
 */
- (void)startRippleAnimation
{
    /**
     * 正在动画的时候停止
     */
    if (self.animationTimer)
        return;

    NSTimer *animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(rippleAnimation) userInfo:nil repeats:YES];
    
    self.animationTimer = animationTimer;
    
    /**
     *  调整timer的优先级
     */
    [[NSRunLoop currentRunLoop] addTimer:animationTimer forMode:NSRunLoopCommonModes];
}
/**
 *  动画一次
 */
- (void)startRippleAnimationOnce
{
    [self rippleAnimation];
}
/**
 *  停止动画
 */
- (void)stopRippleAnimation
{
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}
/**
 *  画圈的动画
 */
- (void)rippleAnimation
{
    UIColor *stroke = self.rippleColor;
    
    CGRect pathFrame = CGRectMake(-self.minRadius, -self.minRadius,self.minRadius * 2,self.minRadius * 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.minRadius ];
    CGPoint shapePosition = [self convertPoint:self.center fromView:nil];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = stroke.CGColor;
    circleShape.lineWidth = self.rippleWidth;
    
    [self.layer addSublayer:circleShape];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(self.pantographProportion, self.pantographProportion, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    /**
     *  动画时间
     */
    animation.duration = self.animationTime;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:nil];
}
- (UIColor *)rippleColor
{
    if (_rippleColor == nil) {
        _rippleColor = [UIColor grayColor];
    }
    return _rippleColor;
}
- (CGFloat)minRadius
{
    if(_minRadius <= 0)
    {
        _minRadius = 20.0;
    }
    return _minRadius;
}
- (CGFloat)maxRadius
{
    if (_maxRadius <= 0)
    {
        _maxRadius = 50.0;
    }
    return _maxRadius;
}
- (CGFloat)pantographProportion
{
    if (_pantographProportion <=0) {
        _pantographProportion = self.maxRadius/self.minRadius;
    }
    return _pantographProportion;
}
- (CGFloat)rippleWidth
{
    if (_rippleWidth <= 0) {
        _rippleWidth = 1.0;
    }
    return _rippleWidth;
}
- (CGFloat)animationTime
{
    if (_animationTime <= 0 ) {
        _animationTime = 2.0;
    }
    return _animationTime;
}
@end
