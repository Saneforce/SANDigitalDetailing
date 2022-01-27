//
//  TiledPDFView.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 22/02/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TiledPDFView : UIView


@property CGPDFPageRef pdfPage;
@property CGFloat myScale;

@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
- (id)initWithFrame:(CGRect)frame scale:(CGFloat)scale;
- (void)setPage:(CGPDFPageRef)newPage;

@end
