//
//  ViewController.m
//  CoreAnimation
//
//  Created by 何广忠 on 2018/4/13.
//  Copyright © 2018年 Gaivin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIView *testView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#warning test code
    testView = [UIView new];
    testView.frame = CGRectMake(60, 200., 200., 200.);
    testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:testView];
    
    CGFloat startTime = 2.;
    [self performSelector:@selector(mineCABasicAnimation) withObject:nil afterDelay:startTime];
    startTime += 2. + 1.35;
    [self performSelector:@selector(mineCAKeyframeAnimation) withObject:nil afterDelay:startTime];
    startTime += 2. + 1.35;
    [self performSelector:@selector(mineCAKeyframeAnimation2) withObject:nil afterDelay:startTime];
    startTime += 2. + 1.35;
    [self performSelector:@selector(mineCASpringAnimation) withObject:nil afterDelay:startTime];
    startTime += 2. + 4.;
    [self performSelector:@selector(mineCATransition) withObject:nil afterDelay:startTime];
}

#pragma mark - CoreAnimation
- (void)mineCABasicAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = YES; //是否恢复状态
    /*e.g.:
     kCAMediaTimingFunctionLinear
     kCAMediaTimingFunctionEaseIn
     kCAMediaTimingFunctionEaseOut
     kCAMediaTimingFunctionEaseInEaseOut
     kCAMediaTimingFunctionDefault
     */
    animation.keyPath = @"transform.scale";
//     animation.delegate -  监听动画开始、完成
    /*
     transform.scale
     transform.scale.x
     transform.scale.y
     transform.rotation.z
     opacity
     margin
     zPosition
     backgroundColor
     cornerRadius
     borderWidth
     bounds
     contents
     contentsRect
     cornerRadius
     frame
     hidden
     mask
     masksToBounds
     opacity
     position
     shadowColor
     shadowOffset
     shadowOpacity
     shadowRadius
     */
    animation.fromValue = [NSNumber numberWithFloat:2.];    //初始值
    animation.toValue = [NSNumber numberWithFloat:.5];          //动画目标值
    animation.duration = 1.35;
    [testView.layer addAnimation:animation forKey:@"BasicAnimation"];
}

- (void)mineCAKeyframeAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    //设置value
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(100, 100)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(200, 100)];
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(200, 200)];
    NSValue *value4=[NSValue valueWithCGPoint:CGPointMake(100, 200)];
    NSValue *value5=[NSValue valueWithCGPoint:CGPointMake(100, 300)];
    NSValue *value6=[NSValue valueWithCGPoint:CGPointMake(200, 400)];
    animation.values=@[value1,value2,value3,value4,value5,value6];
    
    //重复次数 默认为1
    animation.repeatCount=1;
    
    //设置是否原路返回默认为不
    animation.autoreverses = YES;
    
    //设置移动速度，越小越快
    animation.duration = 1.35;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [testView.layer addAnimation:animation forKey:@"CAKeyframeAnimation"];
}

- (void)mineCAKeyframeAnimation2
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //创建一个CGPathRef对象，就是动画的路线
    CGMutablePathRef path = CGPathCreateMutable();
    //自动沿着弧度移动
    CGPathAddEllipseInRect(path, NULL, CGRectMake(150, 200, 200, 100));
    //设置开始位置
    CGPathMoveToPoint(path,NULL,100,100);
    //沿着直线移动
    CGPathAddLineToPoint(path,NULL, 200, 100);
    CGPathAddLineToPoint(path,NULL, 200, 200);
    CGPathAddLineToPoint(path,NULL, 100, 200);
    CGPathAddLineToPoint(path,NULL, 100, 300);
    CGPathAddLineToPoint(path,NULL, 200, 400);
    //沿着曲线移动
    CGPathAddCurveToPoint(path,NULL,50.0,275.0,150.0,275.0,70.0,120.0);
    CGPathAddCurveToPoint(path,NULL,150.0,275.0,250.0,275.0,90.0,120.0);
    CGPathAddCurveToPoint(path,NULL,250.0,275.0,350.0,275.0,110.0,120.0);
    CGPathAddCurveToPoint(path,NULL,350.0,275.0,450.0,275.0,130.0,120.0);
    animation.path=path;
    CGPathRelease(path);
    animation.autoreverses = YES;
    animation.repeatCount=1;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 1.350f;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [testView.layer addAnimation:animation forKey:@"CAKeyframeAnimation2"];
}

- (void)mineCASpringAnimation
{
    CASpringAnimation * animation = [CASpringAnimation animation];
    animation.keyPath = @"position.x";
    animation.fromValue = [NSNumber numberWithFloat:testView.center.x - 200];
    animation.toValue = [NSNumber numberWithFloat:testView.center.x + 200.];
    
    /*默认是1 必须大于0
    若你设置的值小于0  会有CoreAnimation: mass must be greater than 0.这个信息提示你
    并且把你的小于0的值改成1
    对象质量 质量越大 弹性越大 需要的动画时间越长
     */
    animation.mass = 100;
    
    /*必须大于0  默认是100
    若设置的小于0 会给你一个提示 并把值改成100
    刚度系数，刚度系数越大，产生形变的力就越大，运动越快。
     */
    animation.stiffness = 90;
    
    /*默认是10 必须大于或者等于0
    若设置的小于0 会给你一个提示 并把值改成10
    阻尼系数 阻止弹簧伸缩的系数 阻尼系数越大，停止越快。时间越短
     */
    animation.damping = 10;
    
    /*默认是0
    初始速度，正负代表方向，数值代表大小
     */
    animation.initialVelocity = 2;
    
    /*计算从开始到结束的动画的时间，根据当前的参数估算时间
    只读的，不能赋值
     */
    animation.duration = 4.;
    [testView.layer addAnimation:animation forKey:@"CAKeyframeAnimation2"];
}

- (void)mineCATransition
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    /*
     e.g.:
     kCATransitionFade
     kCATransitionMoveIn
     kCATransitionPush
     kCATransitionReveal
     */
    animation.subtype = kCATransitionFromLeft;
    /*
     kCATransitionFromRight
     kCATransitionFromLeft
     kCATransitionFromTop
     kCATransitionFromBottom
     */
    animation.startProgress = .3;
    animation.endProgress = .9;
    animation.duration = 1.35;
    animation.removedOnCompletion = YES;
    testView.frame = CGRectMake(0, 0, 300, 300);
    [testView.layer addAnimation:animation forKey:@"mineCATransition"];
}

- (void)mineCAAnimationGroup
{
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    
    //subAnimatoin - first
    CABasicAnimation *animationF = [CABasicAnimation animation];
    animationF.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationF.removedOnCompletion = YES; //是否恢复状态
    animationF.fromValue = [NSNumber numberWithFloat:2.];    //初始值
    animationF.toValue = [NSNumber numberWithFloat:.5];          //动画目标值
    
    //subAnimation - sec
    //贝塞尔曲线路径
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:CGPointMake(10.0, 10.0)];
     [movePath addQuadCurveToPoint:CGPointMake(100, 300) controlPoint:CGPointMake(300, 100)];
    
    CAKeyframeAnimation * animationS = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animationS.path = movePath.CGPath;
    animationS.removedOnCompletion = YES;
    
    animation.animations = @[animationF,animationS];
    [testView.layer addAnimation:animation forKey:@"mineCAAnimationGroup"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
