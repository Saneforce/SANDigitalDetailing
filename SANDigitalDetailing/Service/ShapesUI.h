//
//  ShapesUI.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 23/01/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShapesUI : UIView <UIGestureRecognizerDelegate>
@property (nonatomic,assign) int lineWidth;
@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;

- (id)initWithSqure:(CGRect)frame andLineColor:(UIColor *)lColor;
- (id)initWithCircle:(CGRect)frame andLineColor:(UIColor *)lColor;
@end

NS_ASSUME_NONNULL_END
