//
//  LineView.h
//  DrawingApp
//
//  Created by SANeForce.com on 08/01/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LineView : UIView

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) CGFloat circleRadius; // defaults to 30.0
@property (nonatomic) UIColor *lineColor;

- (instancetype)initWithFrame:(CGRect)frame andLineColor:(UIColor *) lineColor;

@end

NS_ASSUME_NONNULL_END
