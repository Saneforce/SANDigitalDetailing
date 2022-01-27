//
//  PDFScrollView.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 22/02/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "TiledPDFView.h"

@interface PDFScrollView : UIScrollView <UIScrollViewDelegate>


// Frame of the PDF
@property (nonatomic) CGRect pageRect;
// A low resolution image of the PDF page that is displayed until the TiledPDFView renders its content.
@property (nonatomic, weak) UIView *backgroundImageView;
// The TiledPDFView that is currently front most.
@property (nonatomic, weak) TiledPDFView *tiledPDFView;
// The old TiledPDFView that we draw on top of when the zooming stops.
@property (nonatomic, weak) TiledPDFView *oldTiledPDFView;
// Current PDF zoom scale.
@property (nonatomic) CGFloat PDFScale;
@property (nonatomic) CGPDFPageRef PDFPage;
-(void)renderPDFPage;//:(int) pdf pgNo:(int) PgNo;
-(void) setPDFPage:(CGPDFPageRef)PDFPage;
-(void)replaceTiledPDFViewWithFrame:(CGRect)frame;

@end
