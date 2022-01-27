//
//  PdfDataViewerCtrlr.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 22/02/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//
#import "PDFScrollView.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UITest.h"

//@class PDFScrollView;

@interface PdfDataViewerCtrlr : UIViewController

@property (strong) IBOutlet PDFScrollView* scrollView;
@property (strong) IBOutlet UITest* scrollVw;

@property CGPDFDocumentRef pdf;
@property CGPDFPageRef page;
@property int pageNumber;
@property CGFloat myScale;

@end
