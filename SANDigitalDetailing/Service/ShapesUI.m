//
//  ShapesUI.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 23/01/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import "ShapesUI.h"

@implementation ShapesUI
- (id)initWithSqure:(CGRect)frame andLineColor:(UIColor *)lColor{
    self = [super initWithFrame:frame];
    _lineColor=lColor;
    UIBezierPath *path =[UIBezierPath bezierPathWithRoundedRect:self.frame cornerRadius:10];
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.path = path.CGPath;
    _shapeLayer.strokeColor = _lineColor.CGColor;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_shapeLayer];
    [self addGesture];
    return self;
}
- (id)initWithCircle:(CGRect)frame andLineColor:(UIColor *)lColor{
    self = [super initWithFrame:frame];
    _lineColor=lColor;
    UIBezierPath *path =[UIBezierPath bezierPathWithArcCenter:self.center radius:50 startAngle:-90 endAngle:160 clockwise:YES];
    //UIBezierPath *path =[UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:10];
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.path = path.CGPath;
    _shapeLayer.strokeColor = _lineColor.CGColor;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_shapeLayer];
    [self addGesture];
    return self;
}
-(void) addGesture{
    UIPanGestureRecognizer *panGR= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    UIPinchGestureRecognizer *pinGR= [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
    UIRotationGestureRecognizer *rotationGR= [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(didRotate:)];
    
    [self addGestureRecognizer:panGR];
    [self addGestureRecognizer:pinGR];
    [self addGestureRecognizer:rotationGR];
}
-(void) didPan:(UIPanGestureRecognizer *)panGR {
    CGPoint translation = [panGR translationInView:self];
    CGPoint imageViewPosition = self.center;
    imageViewPosition.x += translation.x;
    imageViewPosition.y += translation.y;
    
    self.center = imageViewPosition;
    [panGR setTranslation:CGPointZero inView:self];
    /*[self.superview bringSubviewToFront:self];
    CGPoint translation = [panGR translationInView:self];
    self.center = CGPointMake(self.center.x  + translation.x,self.center.y  + translation.y);
    [panGR setTranslation:CGPointZero inView: self];*/
}
-(void) didPinch:(UIPinchGestureRecognizer*)pinchGR {
    [self.superview bringSubviewToFront:self];
    
    CGFloat scale = pinchGR.scale;
    self.transform = CGAffineTransformScale(self.transform, scale, scale);
    pinchGR.scale = 1.0;
    /*CGFloat scale = [pinchGR scale];
    self.transform = CGAffineTransformScale(self.transform, scale, scale);
    NSLog(@"Width: %f",self.frame.size.width);*/
    if (pinchGR.state == UIGestureRecognizerStateEnded)
    {
        /*
        CGAffineTransform transform =CGAffineTransformScale(pinchGR.view.transform, scale, scale);
        CGPathRef pathOfShape = CGPathCreateCopyByTransformingPath(_shapeLayer.path, &transform);
        _shapeLayer.path = [UIBezierPath bezierPathWithRect:CGPathGetBoundingBox(pathOfShape)].CGPath;
        */
    }
    
    //pinchGR.scale = 0.0;*/
}
-(void) didRotate:(UIRotationGestureRecognizer*)rotationGR {
    [self.superview bringSubviewToFront:self];
    CGFloat rotation = [rotationGR rotation];
    self.transform = CGAffineTransformRotate(self.transform, rotation);
    rotationGR.rotation =0.0;
}

@end
