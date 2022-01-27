//
//  UITest.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 15/10/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TiledPDFView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITest : UIScrollView <UIScrollViewDelegate>
@property (nonatomic) CGRect pageRect;
@property (nonatomic, weak) UIView *backgroundImageView;
@property (nonatomic, weak) TiledPDFView *tiledPDFView;
@property (nonatomic, weak) TiledPDFView *oldTiledPDFView;
@property (nonatomic) CGFloat PDFScale;
@property (nonatomic) CGPDFPageRef PDFPage;

-(void) renderPDFPage;
-(void) setPDFPage:(CGPDFPageRef)PDFPage;
-(void)replaceTiledPDFViewWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
